//
//  KeypadViewController.swift
//  Contact Demo
//
//  Created by Droisys on 09/08/23.
//

import UIKit

class KeypadViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,contactData,UITextFieldDelegate{
    func getData(dict: [String : Any]) {
        self.textFieldkeypad.text = dict["phone"] as? String

    }
    
//    var dictt = [String:String]()
//    var arr2 = [Contact]()
//


    @IBOutlet weak var textFieldkeypad: UITextField!
    
        
    @IBOutlet var collection: UICollectionView!
    
    var arrNumber = ["1","2","3","4","5","6","7","8","9","*","0","#"]
    var arrCharacter = ["","ABC","DEF","GHI","JKL","MNO","PQRS","TUV","WXYZ","","+",""]
    
  
    var str = "" //for remove
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var btnCall: UIButton!   // for ciecle
  
    @IBOutlet weak var removeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       arr2 = databaseHandler.shareInstance.getContactData()   // for lblname show
        
        textFieldkeypad.delegate = self
        self.btnCall.layer.cornerRadius = 40
        addBtn.isHidden = true
        removeBtn.isHidden = true
//        self.textFieldkeypad.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        textFieldkeypad.text = ""
        str = ""
//        addBtn.isHidden = true
//        removeBtn.isHidden = true   // for back will apear

        
    }
    
    //collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrNumber.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! KeypadCollectionViewCell
        cell.lblNumber.text = arrNumber[indexPath.row]
        cell.lblchracter.text = arrCharacter[indexPath.row]
        
        cell.cellView.layer.cornerRadius = 40
        
//        cell.cellView.layer.cornerRadius = cell.cellView.frame.width/2
//        cell.cellView.layer.cornerRadius = cell.frame.height/2     //2:
        return cell
    }
    //textField Data enter
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        str.append(arrNumber[indexPath.row])
        if str.count != 0 {
            addBtn.isHidden = false
            removeBtn.isHidden = false
        }
        textFieldkeypad.text?.append(arrNumber[indexPath.row])
        collection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width:self.view.frame.width - 32/3, height: 84)
//        let collectionWidth = collection.frame.width

        return CGSize(width: (self.view.frame.width - 72)/3 , height: 80)     // cell height

    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {

    return UIEdgeInsets(top: 5, left: 18, bottom: 5, right: 18)

    }

 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 2

    }
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
 {
return 8.0

}
 
    


    
    //calling keyboard
    func getCurrentDateTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"//"EE" to get short style   // "MMM d, h:mm a"
        let mydt = dateFormatter.string(from: date).capitalized

        return "\(mydt)"
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
    
    @IBAction func btnCalling(_ sender: Any) {
        if textFieldkeypad.text?.count != 0 {
            let time = getCurrentDateTime()
            var dicCallHistory:[String:Any] = ["name" : ""]
            dicCallHistory["phoneNumber"] = textFieldkeypad.text!
            dicCallHistory["time"] = time
            databaseHandler.shareInstance.savePhoneData(phoneDict: dicCallHistory)
            self.dialNumber(number: textFieldkeypad.text!)
        }
    }
    //clear number
    
    @IBAction func removeBtn(_ sender: Any) {
        textFieldkeypad.text?.removeLast()
        if textFieldkeypad.text!.count != 0 {
            removeBtn.isHidden = false
            addBtn.isHidden = false
          
        }
        else {
            addBtn.isHidden = true
            removeBtn.isHidden = true
        }
        
    }


    @IBAction func addNumber(_ sender: Any) {
        adNumber()

    }
    //addNumber
    func adNumber(){
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let save = UIAlertAction(title: "Save Existing Contact!", style: .default) {_ in
            let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "AddContactViewController") as! AddContactViewController
            vc2.phone = self.textFieldkeypad.text!
            vc2.delegate = self
            self.navigationController?.present(vc2, animated: true)
        }
        let save2 = UIAlertAction(title: "Add New Contact!", style: .default){_ in
            let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "AddContactViewController") as? AddContactViewController
            self.navigationController?.present(vc2!, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(cancel)
        alert.addAction(save)
        alert.addAction(save2)

        present(alert, animated: true)
    }

    
    //removeBtn2:
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//            textFieldkeypad.resignFirstResponder()
//            return true
//        }
//
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        if ((textFieldkeypad.text?.isEmpty) != nil) {
//            addBtn.isHidden = true
//        } else {
//            addBtn.isHidden = false
//        }
//    }
    
}



extension KeypadViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.textFieldkeypad {
            let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string

            // Perform 10-digit number validation
            let numericCharacterSet = CharacterSet.decimalDigits
            let newCharacterSet = CharacterSet(charactersIn: string)
            let isValidNumber = numericCharacterSet.isSuperset(of: newCharacterSet)
            let newLength = (textField.text?.count ?? 0) + string.count - range.length
            return isValidNumber && newLength <= 10
        }

        return true
    }

}
