//
//  FavouriteViewController.swift
//  Contact Demo
//
//  Created by Droisys on 08/08/23.
//

import UIKit
import CoreData
class FavouriteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    
    
    var arrfavorite = [FavoritesContact]()
 
    var arrContact = [Contact]()
    var index = 0
    var isUpdate = false


    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrContact = databaseHandler.shareInstance.getContactData()
        tableview.delegate = self
        tableview.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.arrContact = databaseHandler.shareInstance.getContactData()
        arrfavorite = databaseHandler.shareInstance.getFaveriteData()
        for temp in arrfavorite{
            print(temp)
        }
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrfavorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! FavouriteTableViewCell
        
        cell.FavoriteDetails.tag = indexPath.row

        
//        cell.FavoriteDetails.addTarget(self, action: #selector(FvtDetails(sender:)), for: .touchUpInside)

        let faveData = arrContact.filter({$0.phone == arrfavorite[indexPath.row].userPhone})
        if faveData.isEmpty{
            cell.addNumber.text = arrfavorite[indexPath.row].userPhone
        }else
        {
            cell.addNumber.text = arrfavorite[indexPath.row].userName

        }
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = arrfavorite[indexPath.row].userName
        let number = arrfavorite[indexPath.row].userPhone
  

        print(number!)
        print(name!)
        
        
        let time = getCurrentDateTime()
        var dicCallHistory:[String:Any] = ["name" : name!]
        dicCallHistory["phoneNumber"] = number!
        dicCallHistory["time"] = time
        databaseHandler.shareInstance.savePhoneData(phoneDict: dicCallHistory)
      

       
    }

    
    //for calling
    //time
    func getCurrentDateTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"//"EE" to get short style
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
       }
        
    }
 
    
    //2
//    @objc func FvtDetails(sender:UIButton){
//
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailsViewController") as? ContactDetailsViewController
//        print(arrfavorite[sender.tag].userPhone as Any)
////        vc?.indexRow = indexpath.row
//
//                  self.navigationController?.pushViewController(vc!, animated: true)
//    }
  
    
    @IBAction func addFarouteBtn(_ sender: Any) {
        
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as? ContactViewController
        vc!.isFav = true
                  self.navigationController?.pushViewController(vc!, animated: true)
   
    }

    @IBAction func editFavoriteBtn(_ sender: UIBarButtonItem) {
        tableview.isEditing = !tableview.isEditing
        if tableview.isEditing{
            editBtn.title = "Done"
        }else{
            editBtn.title = "Edit"

        }

        
    }

    @IBAction func fvtinfoBtn(_ sender: UIButton) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailsViewController") as? ContactDetailsViewController
        vc?.indexRow = sender.tag
        vc?.contactDetails?.firstName = arrfavorite[sender.tag].userName
        vc?.contactDetails?.phone = arrfavorite[sender.tag].userPhone
        vc?.contactDetails?.email = arrfavorite[sender.tag].userEmail
        vc?.contactDetails?.lastName = arrfavorite[sender.tag].userLastName
//        vc?.contactDetails?.userProfile = arrfavorite[sender.tag].self
        vc?.isFavorite = true
        print("ok")

        self.navigationController?.pushViewController(vc!, animated: true)
  
    }
        
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            arrfavorite = databaseHandler.shareInstance.deleteFavoriteData(index: indexPath.row)
//            self.tableview.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let selectedItem = arrfavorite[sourceIndexPath.row]
        arrfavorite.remove(at: sourceIndexPath.row)
        arrfavorite.insert(selectedItem, at: destinationIndexPath.row)
        tableView.reloadData()
    }
}

