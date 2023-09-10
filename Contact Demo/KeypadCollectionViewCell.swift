//
//  KeypadCollectionViewCell.swift
//  Contact Demo
//
//  Created by Droisys on 09/08/23.
//

import UIKit




class KeypadCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblNumber: UILabel!
    
    
    @IBOutlet weak var lblchracter: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    
//    override class func awakeFromNib() {
////        self.cellView = self.cellView.frame.size.height/2
        //self.cellView.layer.cornerRadius = 47
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
       // self.cellView.layer.cornerRadius = (self.cellView.frame.size.width)/2
    }
    
}
