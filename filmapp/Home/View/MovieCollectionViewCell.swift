//
//  MovieCollectionViewCell.swift
//  filmapp
//
//  Created by MacBook Pro on 6/12/21.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieRating: UIButton!
    @IBOutlet weak var movieBanner: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
