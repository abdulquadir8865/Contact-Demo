//
//  recentTableViewCell.swift
//  Contact Demo
//
//  Created by Droisys on 31/08/23.
//

import UIKit

class recentTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
