//
//  ContactDatabase.swift
//  Contact Demo
//
//  Created by Droisys on 26/08/23.
//

import Foundation
import CoreData
import UIKit

class databaseHandler: NSObject{
    
    static  let shareInstance = databaseHandler()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // save contact data
    func saveContactData(contactDict:[String:Any]){
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context) as! Contact
        contact.firstName = contactDict["firstName"] as? String
        contact.lastName = contactDict["lastName"] as? String
        contact.phone = contactDict["phone"] as? String
        contact.email = contactDict["email"] as? String
        let myImage = contactDict["image"]
        contact.userProfile = myImage as? Data

//        contact.userProfile = img?.jpegData(compressionQuality: 1) as? NSData as? Data   //convert

        do{
            try context.save()
        }
        catch{
            print("error college")
        }
    }
    
    // fetch contact data
    func getContactData()->[Contact]{
        var arContact = [Contact]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        do{
            arContact = try context.fetch(fetchRequest) as! [Contact]
//            arContact = try context.fetch(Contact.fetchRequest()) as! [Contact] //type2
            print(arContact)
            for idx in arContact{
                print(idx)
            }
            
        }catch{
            print("error for save data!")
        }
        
        return arContact
        
    }
    
    //for edit contactdata
    func editContactData(contactDict:[String:Any],indx:Int){
        var contact = self.getContactData()   // all data get
        print(contact)
        //originaldata                , pass krega then save krega
        contact[indx].firstName = contactDict["firstName"] as? String  //editdata
        contact[indx].lastName = contactDict["lastName"] as? String
        contact[indx].phone = contactDict["phone"] as? String
        contact[indx].email = contactDict["email"] as? String
        contact[indx].userProfile = contactDict["image"] as? NSData as Data?

        do{
            print(contact)
            try context.save()
        }catch{
            print("error for eidt data!")
        }
    }
    
    
    // delete contact data
    func deleteContactData(index:Int)->[Contact]{
        var contactData = getContactData()  // get data
        print(contactData)
        context.delete(contactData[index])   // remove from coredata
        contactData.remove(at: index)  // remove from contact array
        
        do{
            try context.save()
        }catch{
            print("error for detete contact!")
        }
       return contactData
    }
    
    
    // for recent
    
    
    // save call History
    func savePhoneData(phoneDict:[String:Any]){
        let call = NSEntityDescription.insertNewObject(forEntityName: "CallHistory", into: context) as! CallHistory
        call.name = phoneDict["name"] as? String
        call.phoneNumber = phoneDict["phoneNumber"] as? String
        call.time = phoneDict["time"] as? String
        do{
            try context.save()
        }
        catch{
            print("error college")
        }
        
    }
    // fetch call history data
    func getCallData()->[CallHistory]{
        var arHistory = [CallHistory]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CallHistory")
        do{
            arHistory = try context.fetch(fetchRequest) as! [CallHistory]
            print(arHistory)
            for indx in arHistory{
                print(indx)
            }
            
        }catch{
            print("error for save data!")
        }
        
        return arHistory
        
    }

    // delete callhistory data
    func deleteCallhistoryData(index:Int)->[CallHistory]{
        var callHistory = getCallData()  // get data
        print(callHistory)
        context.delete(callHistory[index])   // remove from coredata
        callHistory.remove(at: index)  // remove from contact array
        
        do{
            try context.save()
        }catch{
            print("error for detete recent contact!")
        }
       return callHistory
    }

    //favorites:
        func savefavoritesData(faveDict:[String:Any]){
            let favorites = NSEntityDescription.insertNewObject(forEntityName: "FavoritesContact", into: context) as? FavoritesContact
            favorites?.userName = faveDict["userName"] as? String
            favorites?.userPhone = faveDict["userPhone"] as? String
            favorites?.userEmail = faveDict["userEmail"] as? String
            favorites?.userLastName = faveDict["userLastName"] as? String
            
            
//            let myImage = faveDict["image"]
//            favorites.userImage = myImage as? Data
           
    do{
        print("userName")
        try context.save()
    }
    catch{
        print("error college")
    }
    
}
    
    
    func getFaveriteData()->[FavoritesContact]{
        var arFaverite = [FavoritesContact]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoritesContact")
        do{
            arFaverite = try context.fetch(fetchRequest) as! [FavoritesContact]
            for indx in arFaverite{
                print(indx)
            }
            
        }catch{
            print("error for save data!")
        }
        
        return arFaverite
        
    }

    func deleteFavoriteData(index:Int)->[FavoritesContact]{
        var faveHistory = getFaveriteData()  // get data
        print(faveHistory)
        context.delete(faveHistory[index])   // remove from coredata
        faveHistory.remove(at: index)  // remove from contact array
        
        do{
            try context.save()
        }catch{
            print("error for detete fevorite!")
        }
       return faveHistory
    }
    
    
    //sort
    func sorting() -> [Contact]{
        var arData = [Contact]()
        let appDe = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDe.persistentContainer.viewContext
        let fectRequest : NSFetchRequest = Contact.fetchRequest()
        
        let sortDesc = NSSortDescriptor(key: "firstName", ascending: true)
        fectRequest.sortDescriptors = [sortDesc]
        
        do{
            arData = try (context.fetch(fectRequest))
            print("sorting...")
        }
        catch{
            print("sorting error")

        }
        return arData
    }
    
}
