//
//  AddContactViewController.swift
//  Contact Demo
//
//  Created by Droisys on 06/08/23.
//

import UIKit

protocol contactData{
    
    func getData(dict: [String: Any])
    
}
class AddContactViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var imgview: UIImageView!
    var img = UIImage()
    @IBOutlet weak var firstName: UITextField!
    var fstName = ""
    @IBOutlet weak var lastName: UITextField!
    var lstName = ""

    @IBOutlet weak var phoneNumber: UITextField!
    var phone = ""
    @IBOutlet weak var email: UITextField!
    var emaill = ""

    @IBOutlet weak var saveBtn: UIButton!   // for editBtn
            
    //edit
    var isUpdate = false
    var indexRow = Int()
    var contactDetails:Contact?  // pass

    var delegate:contactData?
    
    //label show
    @IBOutlet weak var lblShow: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstName.text = contactDetails?.firstName
        self.lastName.text = contactDetails?.lastName
        self.phoneNumber.text = phone   // phone number pass
        self.email.text = contactDetails?.email
        lblShow.layer.cornerRadius = 75
        lblShow.clipsToBounds = true
        
//        imageUser.layer.cornerRadius = 75
//        imageUser.clipsToBounds = true
        imgview.layer.cornerRadius = imgview.frame.height/2
        
  
 //keyboard
        firstName.keyboardType = .alphabet
        lastName.keyboardType = .alphabet
        phoneNumber.keyboardType = .numberPad

        email.keyboardType = .emailAddress

    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        
        phone = phoneNumber.text!
        
        if isUpdate{
            self.imgview.image = img
            saveBtn.setTitle("Update", for: .normal)
//            imgEdit
            if contactDetails?.userProfile != nil {
                let image = UIImage(data: (contactDetails?.userProfile)!)
                self.imgview.image = image
               
                lblShow.isHidden = true
                self.imgview.isHidden = false
            }
            else {
                let firstNameInitials = firstName.text?.first?.uppercased()
                var lastNameInitials = String()
                var finalInitials = firstNameInitials
                if let lastNameChar = lastName.text?.first {
                    lastNameInitials = lastNameChar.uppercased()
                    finalInitials = (finalInitials ?? "") + lastNameInitials
                }
                lblShow.text! = finalInitials ?? ""
                lblShow.isHidden = false
                self.imgview.isHidden = true
            }
      
        }else{
            //savecontact
            saveBtn.setTitle("Done", for: .normal)
            lblShow.isHidden = true
            self.imgview.isHidden = true
        
        }
    
    }
    
    // addContact data
    func saveAndUpdateData(){
        var dictionary:[String:Any] = ["firstName" : firstName.text!]
        dictionary["lastName"] = lastName.text!
        dictionary["phone"] = phoneNumber.text!
        dictionary["email"] = email.text!
        let myImage = imgview.image
        if let myImage = myImage {
            if let imageData = myImage.jpegData(compressionQuality: 1.0) {
                dictionary["image"] = imageData
            }
        }

        if isUpdate{
            //for eidt
            databaseHandler.shareInstance.editContactData(contactDict: dictionary, indx: indexRow) // indexRowTopDeclare
            isUpdate = false  // so edit krta rahega
            
        }else{
            //for save
            lblShow.isHidden = false
            if firstName.text != "" && phoneNumber.text != "" {
                databaseHandler.shareInstance.saveContactData(contactDict: dictionary)
                
            }
        }
        delegate?.getData(dict: dictionary)
        self.dismiss(animated: true, completion: nil)
    
    }



    
    @IBAction func cancelBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)

    }
    
    
    
    @IBAction func SaveBtn(_ sender: Any) {
//        saveAndUpdateData()  // method call

        if email.text?.isEmpty ?? true{
            saveAndUpdateData()
        } else {
            //email
            if (email.text?.isValidEmail)!{
                print("your email is valid ")
                saveAndUpdateData()  // method call
            }else
             {
                print("your email is not valid ")
                let alert = UIAlertController(title: "Invalid Email", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
            }
        }
    }
   
    @IBAction func addImage(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let cemerBtn =    UIAlertAction(title: "Camera", style: .default){ [self] (_) in
            showImage(selectedSource: .camera)
            print("cemera press!")
 
        }
        let photoBtn =    UIAlertAction(title: "Library", style: .default){ [self] (_) in
            showImage(selectedSource: .photoLibrary)

            print("cemera selected!")
        }
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        
        alert.addAction(cemerBtn)
        alert.addAction(photoBtn)
        alert.addAction(cancelBtn)
        
        self.present(alert, animated: true,completion: nil)
 
    }
    
    func showImage(selectedSource:UIImagePickerController.SourceType){
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else{
            print("selected source not available!")
            
            return
        }
        
        let imgePiker = UIImagePickerController()
        imgePiker.delegate = self
        imgePiker.sourceType = selectedSource
        imgePiker.allowsEditing = false     //by default false hota hai
        
        self.present(imgePiker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectImage = info[.originalImage] as? UIImage {
            imgview.image = selectImage
            lblShow.isHidden = true
            imgview.isHidden = false
            
        }else
        {
            print("image not found!")
        }
        picker.dismiss(animated: true)
        
        //for cancel
        func imagePickerControllerDidCancel(_picker:UIImagePickerController){
            picker.dismiss(animated: true)
        }
    }

}

//validaton
extension AddContactViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.phoneNumber {
            let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string

            // Perform email validation if the text contains '@' symbol
            if updatedText.contains("@") {
                return isValidEmailFormat(email: updatedText) || string.isEmpty
            }

            // Perform 10-digit number validation
            let numericCharacterSet = CharacterSet.decimalDigits
            let newCharacterSet = CharacterSet(charactersIn: string)
            let isValidNumber = numericCharacterSet.isSuperset(of: newCharacterSet)
            let newLength = (textField.text?.count ?? 0) + string.count - range.length
            return isValidNumber && newLength <= 13
        }

        return true
    }

    func isValidEmailFormat(email: String) -> Bool {
        let email = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let email2 = NSPredicate(format: "SELF MATCHES %@", email)
        return email2.evaluate(with: email)
    }
}


//email
extension String{
    var isValidEmail:Bool{
                let emailRegister = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}" // co,com valid
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegister)
        return emailTest.evaluate(with: self)
    }
    

    //for name
    func isNameValid(_ name: String) -> Bool {
        // Define a regular expression pattern to match names without only whitespace
        let nameregister = "^(?!\\s*$)[A-Za-z\\s]+$"
        
        // Create a regular expression object
        guard let regester = try? NSRegularExpression(pattern: nameregister) else {
            return false
        }
        
        // Evaluate the regular expression against the name
        let range = NSRange(location: 0, length: name.utf16.count)
        return regester.firstMatch(in: name, options: [], range: range) != nil
    }

}
