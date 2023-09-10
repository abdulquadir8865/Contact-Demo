//
//  ContactViewController.swift
//  Contact Demo
//
//  Created by Droisys on 04/08/23.
//

import UIKit
import CoreData

class ContactViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,contactData, UITextFieldDelegate{
    func getData(dict: [String : Any]) {

   
        
        arrContacts.removeAll()  //
        self.arrContacts = databaseHandler.shareInstance.getContactData()
        print(arrContacts)
        arrFilter = arrContacts
      
        self.table.reloadData()
    }
    
 
 
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var searchContact: UITextField!
    
    //check
    var isFav = false
    

    var arrContacts = [Contact] () // alldata from database
    var arrFilter = [Contact] ()

    
    
    //groupping section
    var sectionTitle = [String]()
    var dictt = [String:String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sorting
        self.arrContacts = databaseHandler.shareInstance.sorting()
        
        
//                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.table.frame.width, height: 50))
//                headerView.backgroundColor = .white
//                let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.table.frame.width, height: 50))
//                label.textAlignment = .left
//                label.text = "Abdul Quadir"
//                headerView.addSubview(label)
//                self.table.tableHeaderView = headerView
        
                searchContact.delegate = self
        
        searchContact.addTarget(self, action: #selector(ContactViewController.textFieldDidChange(_:)), for: .editingChanged)
 
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        self.arrContacts = databaseHandler.shareInstance.sorting()

        self.arrContacts = databaseHandler.shareInstance.getContactData()
        
        arrFilter = arrContacts
        print(arrFilter)
        table.reloadData()

    }
    //text
    @objc func textFieldDidChange(_ textField: UITextField) {
        let searchContacts = searchContact.text!
        if searchContacts.isEmpty{
            arrFilter = arrContacts    // if search empty then show all data
        }else {
 
            arrFilter = arrContacts.filter {
                ($0.firstName?.lowercased().contains(searchContacts.lowercased()) ?? false) ||
                ($0.phone?.lowercased().contains(searchContacts.lowercased()) ?? false)
            }

            
            
        }
        table.reloadData()
    }

    
    
    @IBAction func AddContact(_ sender: Any) {

        let vc = storyboard?.instantiateViewController(withIdentifier: "AddContactViewController") as? AddContactViewController
        vc?.delegate = self
        vc?.isUpdate = false

        self.navigationController?.present(vc!, animated: true)
    }

    
    //table method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return  arrFilter.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ContactTableViewCell
//        cell?.contact = arrFilter[indexPath.row]
        
        cell?.fstName.text? = arrFilter[indexPath.row].firstName!
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//favorites & Details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFav == true {
            let vc = storyboard?.instantiateViewController(withIdentifier: "FavouriteViewController") as! FavouriteViewController
          
            let firstname =   arrFilter[indexPath.row].firstName!
            let lastName = arrFilter[indexPath.row].lastName
            let phone =   arrFilter[indexPath.row].phone
            let email = arrFilter[indexPath.row].email
//            let myImage = imgview.image
//            if let myImage = myImage {
//                if let imageData = myImage.jpegData(compressionQuality: 1.0) {
//                    dictionary["image"] = imageData
//                }
//            }

            

            
            var dictionary:[String:Any] = ["userName" : firstname]
            dictionary["userLastName"] = lastName
            dictionary["userPhone"] = phone
            dictionary["userEmail"] = email
           

      
                databaseHandler.shareInstance.savefavoritesData(faveDict: dictionary)
            
            self.navigationController?.popViewController(animated: true)
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailsViewController") as? ContactDetailsViewController
            vc?.indexRow = indexPath.row // for index 0,1,2,3 on edit click
            vc?.contactDetails = arrFilter[indexPath.row]
    //        arrFilter.remove(at: indexPath.row)

            self.navigationController?.pushViewController(vc!, animated: true)
        }

    }
 
    // for delete
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            arrContacts = databaseHandler.shareInstance.deleteContactData(index: indexPath.row)
            self.table.deleteRows(at: [indexPath], with: .automatic)
            table.reloadData()
        }
    }

    //groupping data
//    func grpContacts(){
//        sectionTitle = Array(Set(arrContacts.compactMap({String($0).prefix(1)})))
//        sectionTitle.sort()
//
//        for stitle in sectionTitle{
//            dictt[stitle] = [String]()
//        }
//
//        for conts in arrContacts{
//            dictt[String(conts.prefix(1))]?.append(conts)
//        }
//    }
    
    
}

extension ViewController{
//    let groups = Dictionary(grouping: countries) { (country) -> Character in
//                return country.first!
//    }
//        .map { (key: Character, value: [String]) -> (letter: Character, countries: [String]) in
//            (letter: key, countries: value)
//        }
//        .sorted { (left, right) -> Bool in
//            left.letter < right.letter
//        }
}

