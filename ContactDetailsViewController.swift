//
//  ContactDetailsViewController.swift
//  Contact Demo
//
//  Created by Droisys on 08/08/23.
//

import UIKit
import CoreData

class ContactDetailsViewController: UIViewController,contactData {
    
    @IBOutlet weak var lblFstName: UILabel!
    @IBOutlet weak var lblLstName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var lblShowName: UILabel!  // show label
    @IBOutlet var roundedViewCollection: [UIView]! //cornerRadius
    
    //for edit
    var isUpdate = false
    var indexRow = Int()  // which index edit
    var contactDetails:Contact?
    var contactDetailss = [Contact] ()
    
    var favoriteData = [FavoritesContact]()

    
    //checkFave
    var isFavorite = false

    //recent
    var mobile = ""
    var name = ""
    
    override func viewDidLoad() {
        
        lblFstName.text = name
        lblPhone.text = mobile
        
        
        super.viewDidLoad()
        lblShowName.layer.cornerRadius = 75
        lblShowName.clipsToBounds = true
        
        imageUser.layer.cornerRadius = 75
        imageUser.clipsToBounds = true
        
        for view in roundedViewCollection {
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.contactDetailss = databaseHandler.shareInstance.getContactData()
        self.favoriteData = databaseHandler.shareInstance.getFaveriteData()
        print(favoriteData)
        if isFavorite{ //check
            let vc = storyboard?.instantiateViewController(withIdentifier: "FavouriteViewController") as! FavouriteViewController
          
            self.lblFstName.text = favoriteData[indexRow].userName?.capitalized
            self.lblPhone.text = favoriteData[indexRow].userPhone
            self.lblEmail.text = favoriteData[indexRow].userEmail
            self.lblLstName.text = favoriteData[indexRow].userLastName
            
            
        }else{
            self.lblFstName.text = contactDetailss[indexRow].firstName?.capitalized  // for cptl
            self.lblLstName.text = contactDetailss[indexRow].lastName?.capitalized
            self.lblPhone.text = contactDetailss[indexRow].phone
            self.lblEmail.text = contactDetailss[indexRow].email
            if  contactDetailss[indexRow].userProfile != nil {
                let image = UIImage(data: contactDetailss[indexRow].userProfile!)
                self.imageUser.image = image
                lblShowName.isHidden = true
                self.imageUser.isHidden = false
            }
            else {
                
                //show fo firstCharacter
                lblShowName.isHidden = false
                
                self.imageUser.isHidden = true
                
                let firstNameInitials = lblFstName.text?.first?.uppercased()
                var lastNameInitials = String()
                var finalInitials = firstNameInitials
                if let lastNameChar = lblLstName.text?.first {
                    lastNameInitials = lastNameChar.uppercased()
                    finalInitials = (finalInitials ?? "") + lastNameInitials
                }
                lblShowName.text! = finalInitials ?? ""
                
            }
            
        }
       
        
      
       
    }
    
    func getData(dict: [String : Any]) {
//        self.arrContacts = databaseHandler.shareInstance.getContactData()
        
        self.lblFstName.text = dict["firstName"] as? String
        self.lblLstName.text = dict["lastName"] as? String
        self.lblPhone.text = dict["phone"] as? String
        self.lblEmail.text = dict["email"] as? String
  
        if let dataa = dict["image"] as? Data,
           let myImage = UIImage(data: dataa) {
            // You have successfully converted the data back to a UIImage
            // You can use `myImage` here
            lblShowName.isHidden = true
            self.imageUser.isHidden = false
            self.imageUser.image = myImage
        }
        else {
            let firstNameInitials = lblFstName.text?.first?.uppercased()
            var lastNameInitials = String()
            var finalInitials = firstNameInitials
            if let lastNameChar = lblLstName.text?.first {
                lastNameInitials = lastNameChar.uppercased()
                finalInitials = (finalInitials ?? "") + lastNameInitials
            }
            lblShowName.text! = finalInitials ?? ""
            lblShowName.isHidden = false
            self.imageUser.isHidden = true
        }

    }
    
    //cancel
    @IBAction func cancelContactBtn(_ sender: Any){
        self.navigationController?.popViewController(animated: true)

    }
    
    
    @IBAction func editContactBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddContactViewController") as! AddContactViewController
        
        vc.isUpdate = true  //
        vc.contactDetails = contactDetailss[indexRow]   // details in textfield for edit click
        vc.indexRow = indexRow
        vc.phone = lblPhone.text!
        vc.delegate = self
        self.navigationController?.present(vc, animated: true)
        
    }
    
    
    
    //calling
    @IBAction func btncall(_ sender: Any) {
        var dicCallHistory:[String:Any] =  ["firstName" : lblFstName.text!]
        dicCallHistory["phoneNumber"] = lblPhone.text!
        dicCallHistory["name"] = lblFstName.text

        let time = getCurrentDateTime()  //call
        dicCallHistory["time"] = time
        databaseHandler.shareInstance.savePhoneData(phoneDict: dicCallHistory)
        self.dialNumber(number: lblPhone.text!) //call
    }

    
    //time
    func getCurrentDateTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"//"EE" to get short style   // "MMM d, h:mm a"
        let mydata = dateFormatter.string(from: date).capitalized

        return "\(mydata)"
    }
    //call
    func dialNumber(number : String) {

     if let url = URL(string: "tel://\(number)"),
       UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       } else {
                // add error message here
       }
    }
    
    
    
    @IBAction func deleteBtn(_ sender: Any) {
  
        print(indexRow)

        databaseHandler.shareInstance.deleteContactData(index: indexRow)
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
