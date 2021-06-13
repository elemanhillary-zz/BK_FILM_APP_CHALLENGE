//
//  MovieViewModel.swift
//  filmapp
//
//  Created by MacBook Pro on 6/12/21.
//

import Foundation
import UIKit

class MovieViewModel {
    var imageBaseURL = "https://image.tmdb.org/t/p/original"
    var movieId: Int?
    var similarMovies = [MovieModel]()
    
    enum Section: CaseIterable {
        case castMembers
    }
    
    enum SectionSimilar: CaseIterable {
        case similar
    }
    
    func getSimilarMovie(movieId: Int, completion: ((_ products: [MovieModel]?, _ error: Error?)->())?=nil) {
        MovieRequest.getSimilarMoview(movieId: movieId, success: {[weak self] response in
            if let _response = response as? NowPlayingResponse {
                self?.similarMovies = _response.results.sorted { ($0.title ?? "").lowercased() < ($1.title ?? "").lowercased() }
                completion?(self?.similarMovies, nil)
            }
        }, failure: { error in
            completion?(nil, error)
        })
    }
    
    func getMovie(movieId: Int, completion: ((_ products: MovieModel?, _ error: Error?)->())?=nil) {
        self.movieId = movieId
        MovieRequest.getMovieDetails(movieId: movieId, success: { response in
            if let _response = response as? MovieModel {
                completion?(_response, nil)
            }
        }, failure: { error in
            completion?(nil, error)
        })
    }
    
    func getMovieCast(completion: ((_ products: [Cast]?, _ error: Error?)->())?=nil) {
        MovieRequest.getMovieCast(movieId: self.movieId ?? 0, success: { response in
            if let _response = response as? MovieCastResponse {
                completion?(_response.cast, nil)
            }
        }, failure: { error in
            completion?(nil, error)
        })
    }
}

extension MovieViewModel {
    func makeDataSource(tableView: UITableView) -> UITableViewDiffableDataSource<Section, Cast> {
        return UITableViewDiffableDataSource(tableView: tableView, cellProvider: {(tableView, indexPath, castMember) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CastTableViewCell.self), for: indexPath) as? CastTableViewCell else {
                return CastTableViewCell()
            }
            cell.castName.text = castMember.name ?? ""
            cell.castCharacter.text = "As: \(castMember.character ?? "")"
            if let url = URL.init(string: self.imageBaseURL + (castMember.profile_path ?? "")) {
                cell.castImage.sd_setImage(with: url)
            }
            return cell
        })
    }
    
    func update(with data: [Cast], dataSource: UITableViewDiffableDataSource<Section, Cast>) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Cast>()
        snapShot.appendSections(Section.allCases)
        snapShot.appendItems(data, toSection: .castMembers)
        dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    
    func makeSimilarDataSource(collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<SectionSimilar, MovieModel> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: {(collectionView, indexPath, movie) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SimilarVideosCollectionViewCell.self), for: indexPath) as? SimilarVideosCollectionViewCell else {
                return SimilarVideosCollectionViewCell()
            }
            DispatchQueue.main.async {
                cell.loader.startAnimating()
            }
            cell.movieRating.setTitle("\(movie.vote_average ?? 0) Ratings", for: .normal)
            if let url = URL.init(string: self.imageBaseURL + (movie.poster_path ?? "")) {
                cell.moviePoster.sd_setImage(with: url, completed: {_,_,_,_ in
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
    
    func updateSimilarMovie(with data: [MovieModel], dataSource: UICollectionViewDiffableDataSource<SectionSimilar, MovieModel>) {
        var snapShot = NSDiffableDataSourceSnapshot<SectionSimilar, MovieModel>()
        snapShot.appendSections(SectionSimilar.allCases)
        snapShot.appendItems(data, toSection: .similar)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}
