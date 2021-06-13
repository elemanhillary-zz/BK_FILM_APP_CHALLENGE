//
//  MovieModel.swift
//  filmapp
//
//  Created by MacBook Pro on 6/12/21.
//

import Foundation
import UIKit

class MovieModel: BaseModel {
    var poster_path: String?
    var adult: Bool?
    var overview: String?
    var release_date: String?
    var genre_ids: [Int]?
    var id: Int?
    var original_title: String?
    var title: String?
    var backdrop_path: String?
    var popularity: Int?
    var vote_count: Int?
    var video: Bool?
    var vote_average: CGFloat?
    var runtime: Int?
    var genres: [Genre]?
}

class Genre: BaseModel {
    var name: String?
}
