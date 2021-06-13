//
//  SimilarVideosCollectionViewCell.swift
//  filmapp
//
//  Created by MacBook Pro on 6/13/21.
//

import UIKit

class SimilarVideosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieRating: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
