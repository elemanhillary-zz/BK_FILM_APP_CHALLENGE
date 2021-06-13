//
//  CastTableViewCell.swift
//  filmapp
//
//  Created by MacBook Pro on 6/13/21.
//

import UIKit

class CastTableViewCell: UITableViewCell {
    @IBOutlet weak var castImage: UIImageView!
    @IBOutlet weak var castName: UILabel!
    @IBOutlet weak var castCharacter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
