//
//  MovieViewController.swift
//  filmapp
//
//  Created by MacBook Pro on 6/12/21.
//

import UIKit
import SnapKit
import Cosmos
import SPIndicator

class MovieViewController: UIViewController {
    @IBOutlet weak var movieBanner: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieRatings: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieOverView: UITextView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var castCard: UIView!
    @IBOutlet weak var showMore: UIButton!
    @IBOutlet weak var ratingStars: CosmosView!
    @IBOutlet weak var cardHeight: NSLayoutConstraint!
    private var viewTranslation = CGPoint(x: 0, y: 0)
    private var movieViewModel = MovieViewModel()
    private lazy var dataSource = movieViewModel.makeDataSource(tableView: tableView)
    
    private var expandedCount = 0
    
    var movieId: Int = 0
    var genres = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.loader.startAnimating()
            self.cardHeight.constant = UIApplication.shared.statusBarFrame.height + 44
            self.view.layoutIfNeeded()
        }
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableView.automaticDimension
        self.castCard.isUserInteractionEnabled = true
        self.showMore.addTarget(self, action: #selector(self.handleDismiss(sender:)), for: .touchUpInside)
        self.view.bringSubviewToFront(self.castCard)
        movieViewModel.getMovie(movieId: movieId, completion: {[weak self] (response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self?.movieTitle.text = response?.original_title
                    self?.movieRatings.text = "\(response?.vote_average ?? 0) Ratings"
                    self?.releaseDate.text = "Release Date: \(response?.release_date ?? "")"
                    response?.genres?.forEach{
                        self?.genres.append($0.name ?? "")
                    }
                    self?.ratingStars.rating = response?.vote_average ?? 0
                    self?.movieGenre.text = self?.genres.joined(separator: " | ")
                    self?.movieOverView.text = response?.overview ?? ""
                    if let url = URL.init(string: self!.movieViewModel.imageBaseURL + (response!.poster_path ?? "")) {
                        self?.movieBanner.sd_setImage(with: url, completed: {_,_,_,_ in
                            DispatchQueue.main.async {
                                self?.loader.stopAnimating()
                            }
                        })
                    }
                    
                }
            } else {}
        })
        
        movieViewModel.getMovieCast(completion: {[weak self] (response, error) in
            if error == nil {
                self?.movieViewModel.update(with: response!, dataSource: self!.dataSource)
            }
        })
        
        self.ratingStars.didFinishTouchingCosmos = { ratings in
            MovieRequest.GetGuestSession(success: { response in
               if let _response = response as? GuestSession {
                   MovieRequest.postARating(movieId: self.movieId, rating: ratings, guest_session_id: _response.guest_session_id ?? "", success: { response in
                       SPIndicator.present(title: "Success", message: "Rated with a \(ratings) rating", haptic: .success, from: .top)
                   }, failure: { error in
                       SPIndicator.present(title: "Error", message: "Failed Rating", haptic: .error, from: .top)
                   })
                }
            }, failure: { error in
                SPIndicator.present(title: "Error", message: "Failed Rating", haptic: .error, from: .top)
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let roundedCorners = UIBezierPath.init(roundedRect: self.castCard.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 10, height: 10))
        let shape = CAShapeLayer.init()
        shape.path = roundedCorners.cgPath
        self.castCard.layer.mask = shape
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    @IBAction func closeMoveScreen(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openSimilarVideos(_ sender: Any) {
        let controller = SimilarMoviesViewController.showPopup(parentVC: self)
        controller.movieId = self.movieId
    }
    
}

extension MovieViewController: SimilarViewDelegate {
    func didSelect(movie withId: Int) {
        self.movieId = withId
        movieViewModel.getMovie(movieId: withId, completion: {[weak self] (response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self?.movieTitle.text = response?.original_title
                    self?.movieRatings.text = "\(response?.vote_average ?? 0) Ratings"
                    self?.releaseDate.text = "Release Date: \(response?.release_date ?? "")"
                    response?.genres?.forEach{
                        self?.genres.append($0.name ?? "")
                    }
                    self?.ratingStars.rating = response?.vote_average ?? 0
                    self?.movieGenre.text = self?.genres.joined(separator: " | ")
                    self?.movieOverView.text = response?.overview ?? ""
                    if let url = URL.init(string: self!.movieViewModel.imageBaseURL + (response!.poster_path ?? "")) {
                        self?.movieBanner.sd_setImage(with: url, completed: {_,_,_,_ in
                            DispatchQueue.main.async {
                                self?.loader.stopAnimating()
                            }
                        })
                    }
                    
                }
            } else {}
        })
        
        movieViewModel.getMovieCast(completion: {[weak self] (response, error) in
            if error == nil {
                self?.movieViewModel.update(with: response!, dataSource: self!.dataSource)
            }
        })
    }
}

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
}

extension MovieViewController {
    @objc func handleDismiss(sender: UIButton) {
        self.expandedCount += 1
        if self.expandedCount == 1 {
            DispatchQueue.main.async {
                self.cardHeight.constant = UIScreen.main.bounds.size.height - UIApplication.shared.statusBarFrame.height - 50
                sender.setImage(UIImage.init(systemName: "chevron.down"), for: .normal)
                self.view.layoutIfNeeded()
            }
        } else {
            self.expandedCount = 0
            DispatchQueue.main.async {
                self.cardHeight.constant = UIApplication.shared.statusBarFrame.height + 44
                sender.setImage(UIImage.init(systemName: "chevron.up"), for: .normal)
                self.view.layoutIfNeeded()
            }
        }
    }
}
