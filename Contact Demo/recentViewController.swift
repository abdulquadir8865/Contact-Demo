//
//  recentViewController.swift
//  Contact Demo
//
//  Created by Droisys on 31/08/23.
//

import UIKit

class recentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var callHistory = [CallHistory]()
    
    
//    var dictt = [String:String]()
    var arrContacts = [Contact] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrContacts = databaseHandler.shareInstance.getContactData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {

        self.callHistory = databaseHandler.shareInstance.getCallData()
        self.callHistory = self.callHistory.reversed()
        print(callHistory)
        
        //forname
        for temp in callHistory{
            print(temp)
        }
        
        tableView.reloadData()

    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? recentTableViewCell
        cell?.lblTime.text = callHistory[indexPath.row].time
        let existingContact =  arrContacts.filter({$0.phone == callHistory[indexPath.row].phoneNumber})
        if existingContact.isEmpty {
            cell?.lblPhoneNumber.text = callHistory[indexPath.row].phoneNumber
        } else {
            cell?.lblPhoneNumber.text = existingContact.first?.firstName
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = callHistory[indexPath.row].name
        let number = callHistory[indexPath.row].phoneNumber
        print(number!)
        print(name!)
        let time = getCurrentDateTime()
        var dicCallHistory:[String:Any] = ["name" : name!]
        dicCallHistory["phoneNumber"] = number!
        dicCallHistory["time"] = time
        databaseHandler.shareInstance.savePhoneData(phoneDict: dicCallHistory)


        tableView.reloadData()
    }
    
    //calling
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
    
    
//delete
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            callHistory = databaseHandler.shareInstance.deleteCallhistoryData(index: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }





}
