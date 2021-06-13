//
//  GenrePickCollectionViewCell.swift
//  filmFan
//
//  Created by MacBook Pro on 6/12/21.
//

import UIKit

class GenrePickCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var genreName: UILabel!
    @IBOutlet weak var genreIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.container.layer.cornerRadius = self.container.bounds.height / 2
    }

}
