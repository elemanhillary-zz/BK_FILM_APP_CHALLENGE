//
//  HomeViewModel.swift
//  filmapp
//
//  Created by MacBook Pro on 6/12/21.
//

import Foundation
import UIKit
import SDWebImage

class HomeViewModel {
    var genres = [
        "Comedy", "Mystery", "Fantasy", "Horror", "Drama", "Romance",
        "Adventure", "Action"
    ]
    
    var nowPlaying = [MovieModel]()
    var imageBaseURL = "https://image.tmdb.org/t/p/original"
    
    enum Section: CaseIterable {
        case nowPlaying
    }

    func getNowPlayingList(completion: ((_ products: [MovieModel]?, _ error: Error?)->())?=nil) {
        MovieRequest.getNowPlayingMovies(success: {[weak self] response in
            if let _response = response as? NowPlayingResponse {
                self?.nowPlaying = _response.results.sorted { ($0.title ?? "").lowercased() < ($1.title ?? "").lowercased() }
                completion?(self?.nowPlaying, nil)
            }
        }, failure: { error in
            completion?(nil, error)
        })
    }
}

extension HomeViewModel {
    
    func makeDataSource(collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, MovieModel> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self](collectionView, indexPath, movie) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.self), for: indexPath) as? MovieCollectionViewCell else {
                return MovieCollectionViewCell()
            }
            DispatchQueue.main.async {
                cell.loader.startAnimating()
            }
            cell.movieRating.setTitle("\(movie.vote_average ?? 0) Ratings", for: .normal)
            if let url = URL.init(string: self!.imageBaseURL + (movie.poster_path ?? "")) {
                cell.movieBanner.sd_setImage(with: url, completed: {_,_,_,_ in
                    DispatchQueue.main.async {
                        cell.loader.stopAnimating()
                    }
                })
            }
            cell.movieTitle.text = movie.title
            cell.releaseDate.text = movie.release_date
            return cell
        })
    }
    
    func update(with data: [MovieModel], animate: Bool = true, dataSource: UICollectionViewDiffableDataSource<Section, MovieModel>) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, MovieModel>()
        snapShot.appendSections(Section.allCases)
        snapShot.appendItems(data, toSection: .nowPlaying)
        dataSource.apply(snapShot, animatingDifferences: animate)
    }
}
