//
//  MovieRequests.swift
//  filmapp
//
//  Created by MacBook Pro on 6/12/21.
//

import Foundation
import Alamofire

class MovieRequest: BaseRequest {
    var api_key = "5bf7da6c01c6518d51f3e70abf4b73df"
    var page = 1
    var language = "en-US"
    var value: CGFloat?
    var guest_session_id: String?
    
    static func getNowPlayingMovies(success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let request = MovieRequest.init()
        APIManager.shared.getRequest(urlPath: APIList.now_playing, headers: nil, request: request, encoding: URLEncoding.default, success: { response in
            if let _response = NowPlayingResponse.deserialize(from: response as? [String: Any]) {
                success(_response)
            }
        }, failure: { error in
            failure(error)
        })
    }
    
    static func getMovieDetails(movieId: Int, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let request = MovieRequest.init()
        APIManager.shared.getRequest(urlPath: "movie/\(movieId)", headers: nil, request: request, encoding: URLEncoding.default, success: { response in
            if let _response = MovieModel.deserialize(from: response as? NSDictionary) {
                success(_response)
            }
        }, failure: { error in
            failure(error)
        })
    }
    
    static func getMovieCast(movieId: Int, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let request = MovieRequest.init()
        APIManager.shared.getRequest(urlPath: "movie/\(movieId)/credits", headers: nil, request: request, encoding: URLEncoding.default, success: { response in
            if let _response = MovieCastResponse.deserialize(from: response as? [String: Any]) {
                success(_response)
            }
        }, failure: { error in
            failure(error)
        })
    }
    
    static func GetGuestSession(success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let request = MovieRequest.init()
        APIManager.shared.getRequest(urlPath: APIList.guest_account, headers: nil, request: request, encoding: URLEncoding.default, success: { response in
            if let _response = GuestSession.deserialize(from: response as? NSDictionary) {
                success(_response)
            }
        }, failure: { error in
            failure(error)
        })
    }
    
    static func postARating(movieId: Int, rating: CGFloat?, guest_session_id: String, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let request = MovieRequest.init()
        request.value = rating
        request.guest_session_id = guest_session_id
        let url = "movie/\(movieId)/rating?api_key=\(request.api_key)&guest_session_id=\(request.guest_session_id ?? "")"
        APIManager.shared.postRequest(urlPath: url, headers: nil, request: request, encoding: URLEncoding.default, success: { response in
            if let _response = MovieCastResponse.deserialize(from: response as? [String: Any]) {
                success(_response)
            }
        }, failure: { error in
            failure(error)
        })
    }
    
    static func getSimilarMoview(movieId: Int, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let request = MovieRequest.init()
        APIManager.shared.getRequest(urlPath: "movie/\(movieId)/similar", headers: nil, request: request, encoding: URLEncoding.default, success: { response in
            if let _response = NowPlayingResponse.deserialize(from: response as? [String: Any]) {
                success(_response)
            }
        }, failure: { error in
            failure(error)
        })
    }
}

