//
//  SimilarMoviesViewController.swift
//  filmapp
//
//  Created by MacBook Pro on 6/13/21.
//

import UIKit

protocol SimilarViewDelegate: NSObject {
    func didSelect(movie withId: Int)
}

class SimilarMoviesViewController: UIViewController {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var movieViewModel = MovieViewModel()
    weak var parentVC: MovieViewController?
    var movieId = 0
    private lazy var dataSource = movieViewModel.makeSimilarDataSource(collectionView: collectionView)
    weak var delegate: SimilarViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib.init(nibName: String(describing: SimilarVideosCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SimilarVideosCollectionViewCell.self))
        self.collectionView.collectionViewLayout = createLayout()
        self.collectionView.delegate = self
        movieViewModel.getSimilarMovie(movieId: self.movieId, completion: {[weak self] (response, error) in
            if error == nil {
                self?.movieViewModel.updateSimilarMovie(with: response!, dataSource: self!.dataSource)
            }
        })
    }
    
    
    static func showPopup(parentVC: UIViewController) -> SimilarMoviesViewController {
        let popupViewController = UIStoryboard(name: "Movie", bundle: nil).instantiateViewController(withIdentifier: "SimilarMoviesViewController") as! SimilarMoviesViewController
        if let parentVC = parentVC as? MovieViewController {
            popupViewController.parentVC = parentVC
            popupViewController.delegate = parentVC
            popupViewController.movieId = parentVC.movieId
        }
        popupViewController.modalPresentationStyle = .custom
        popupViewController.modalTransitionStyle = .crossDissolve
        parentVC.present(popupViewController, animated: true)
        return popupViewController
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension SimilarMoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelect(movie: self.movieViewModel.similarMovies[indexPath.item].id ?? 0)
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
}

extension SimilarMoviesViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
        
        
    }
}
