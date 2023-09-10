//
//  ContactTableViewCell.swift
//  Contact Demo
//
//  Created by Droisys on 07/08/23.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    
    @IBOutlet weak var fstName: UILabel!
    @IBOutlet weak var lstName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var email: UILabel!
    
    
//    var contact:Contact?{
//        didSet{
//            fstName.text = contact?.firstName?.capitalized ?? ""
//            lstName.text = contact?.lastName?.capitalized ?? ""
//            phoneNumber.text = contact?.phone ?? ""
//            email.text = contact?.email ?? ""
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
