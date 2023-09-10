//
//  FavouriteTableViewCell.swift
//  Contact Demo
//
//  Created by Droisys on 08/08/23.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {


    
    @IBOutlet weak var addNumber: UILabel!
    
    
    @IBOutlet weak var FavoriteDetails: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
    
    
}
