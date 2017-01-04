/*
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation
import FeedHenry
import CoreData

public let DATA_ID = "myShoppingList"

public let TASKS_DATA_ID = "tasks"



public class DataManager: NSObject, UIAlertViewDelegate {
    public var syncClient: FHSyncClient!
    public var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    public func start(userName: String) {
        let conf = FHSyncConfig()
        conf.syncFrequency = 30
        conf.notifySyncStarted = true
        conf.notifySyncCompleted = true
        conf.notifySyncFailed = true
        conf.notifyRemoteUpdateApplied = true
        conf.notifyRemoteUpdateFailed = true
        conf.notifyLocalUpdateApplied = true
        conf.notifyDeltaReceived = true
        conf.crashCountWait = 0;
        syncClient = FHSyncClient(config: conf)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(DataManager.onSyncMessage(_:)), name:"kFHSyncStateChangedNotification", object:nil)
        let userId : NSMutableDictionary = [:]
        userId.setObject(userName, forKey: "username")

        let userDetails = self.findItemByUserName(userName) as UserDetails!
        
        print("userDetails\(userDetails)")
        userId.setObject(userDetails.userrole!, forKey: "userrole")
        syncClient.manageWithDataId(DATA_ID, andConfig:nil, andQuery:[:], andMetaData: userId)

        
    }
    
    public func onSyncMessage(note: NSNotification) {
        if let msg = note.object as? FHSyncNotificationMessage, let code = msg.code {
            print("Got notification: \(msg)")
            if code == REMOTE_UPDATE_APPLIED_MESSAGE {
                print("onSyncMessage::REMOTE_UPDATE_APPLIED_MESSAGE")
                if  let obj = msg.message.objectFromJSONString() as? [String: AnyObject], let action = obj["action"] as? String where action == "create" {
                    if let oldUid = obj["hash"] as? String,
                        let newUid = obj["uid"] as? String,
                        let item = findItemById(oldUid) {
                            item.uid = newUid
                    }
                    if managedObjectContext.hasChanges {
                        do {
                            try managedObjectContext.save()
                        } catch {
                            print("Failed to save in CoreData")
                        }
                    }
                }
            } else if code == LOCAL_UPDATE_APPLIED_MESSAGE || (code == DELTA_RECEIVED_MESSAGE && msg.UID != nil) {
                print("onSyncMessage::LOCAL_UPDATE_APPLIED_MESSAGE or DELTA_RECEIVED_MESSAGE")
                if let action = msg.message, let uid = msg.UID {
                    if action == "create" { // replace temporary id with the one assinged in cloud DB
                        let data = syncClient.readWithDataId(DATA_ID, andUID: uid)
                        let dataSource = data["data"]
                        if let item = findItemById(uid) {
                            if let dataSource = dataSource as? [String: AnyObject] {
                        
                                item.ticketid = dataSource["ticketid"] as? String
                                item.productname = dataSource["productname"] as? String
                                item.username = dataSource["username"] as? String
                                item.serialno = dataSource["serialno"] as? String
                                item.manufname = dataSource["manufname"] as? String
                                item.dateofpurchase = dataSource["dateofpurchase"] as? String
                                item.priority = dataSource["priority"] as? String
                                item.productcomments = dataSource["productcomments"] as? String
                                item.partname = dataSource["partname"] as? String
                                item.severitylevel = dataSource["severitylevel"] as? String
                                item.replacementreqd = dataSource["replacementreqd"] as? String
                                item.costofreplacement = dataSource["costofreplacement"] as? String
                                item.problemcomments = dataSource["problemcomments"] as? String
                                item.servicecharges = dataSource["servicecharges"] as? String
                                item.totalcharges = dataSource["totalcharges"] as? String
                                item.createddate = dataSource["createddate"] as? String
                                item.closuredate = dataSource["closuredate"] as? String
                                item.status = dataSource["status"] as? String
                                item.guid = dataSource["guid"] as? String
                                item.addressline2 = dataSource["addressline2"] as? String
                                item.addressline1 = dataSource["addressline1"] as? String
                                item.phone = dataSource["phone"] as? String
                                item.city = dataSource["city"] as? String
                                item.zipcode = dataSource["zipcode"] as? String
                                item.email = dataSource["email"] as? String
                                item.technician = dataSource["technician"] as? String
                                item.dateassigned = dataSource["dateassigned"] as? String
                                item.digitalsign = dataSource["digitalsign"] as? String

                            }
                        } else if let dataSource = dataSource as? [String: AnyObject]  {
                            //if findItemById(uid) == nil {
                                let newItem = NSEntityDescription.insertNewObjectForEntityForName("ShoppingItem", inManagedObjectContext: self.managedObjectContext) as! ShoppingItem
                                newItem.uid = uid
                            newItem.ticketid = dataSource["ticketid"] as? String
                            newItem.productname = dataSource["productname"] as? String
                            newItem.username = dataSource["username"] as? String
                            newItem.serialno = dataSource["serialno"] as? String
                            newItem.manufname = dataSource["manufname"] as? String
                            newItem.dateofpurchase = dataSource["dateofpurchase"] as? String
                            newItem.priority = dataSource["priority"] as? String
                            newItem.productcomments = dataSource["productcomments"] as? String
                            newItem.partname = dataSource["partname"] as? String
                            newItem.severitylevel = dataSource["severitylevel"] as? String
                            newItem.replacementreqd = dataSource["replacementreqd"] as? String
                            newItem.costofreplacement = dataSource["costofreplacement"] as? String
                            newItem.problemcomments = dataSource["problemcomments"] as? String
                            newItem.servicecharges = dataSource["servicecharges"] as? String
                            newItem.totalcharges = dataSource["totalcharges"] as? String
                            newItem.createddate = dataSource["createddate"] as? String
                            newItem.closuredate = dataSource["closuredate"] as? String
                            newItem.status = dataSource["status"] as? String
                            newItem.guid = dataSource["guid"] as? String
                            newItem.addressline2 = dataSource["addressline2"] as? String
                            newItem.addressline1 = dataSource["addressline1"] as? String
                            newItem.phone = dataSource["phone"] as? String
                            newItem.city = dataSource["city"] as? String
                            newItem.zipcode = dataSource["zipcode"] as? String
                            newItem.email = dataSource["email"] as? String
                            newItem.technician = dataSource["technician"] as? String
                            newItem.dateassigned = dataSource["dateassigned"] as? String
                            newItem.digitalsign = dataSource["digitalsign"] as? String

                                let createDoubleValue = dataSource["created"] as? NSNumber
                                if let doubleTime = createDoubleValue?.doubleValue {
                                    let date = NSDate(timeIntervalSince1970: doubleTime/1000)
                                    newItem.created = date
                                }
                            //}
                        }
                    } else if let item = findItemById(uid) where action == "update" {
                        let data = syncClient.readWithDataId(DATA_ID, andUID: uid)
                        if let dataSource = data["data"] as? [String: AnyObject] {
                            item.ticketid = dataSource["ticketid"] as? String
                            item.productname = dataSource["productname"] as? String
                            item.username = dataSource["username"] as? String
                            item.serialno = dataSource["serialno"] as? String
                            item.manufname = dataSource["manufname"] as? String
                            item.dateofpurchase = dataSource["dateofpurchase"] as? String
                            item.priority = dataSource["priority"] as? String
                            item.productcomments = dataSource["productcomments"] as? String
                            item.partname = dataSource["partname"] as? String
                            item.severitylevel = dataSource["severitylevel"] as? String
                            item.replacementreqd = dataSource["replacementreqd"] as? String
                            item.costofreplacement = dataSource["costofreplacement"] as? String
                            item.problemcomments = dataSource["problemcomments"] as? String
                            item.servicecharges = dataSource["servicecharges"] as? String
                            item.totalcharges = dataSource["totalcharges"] as? String
                            item.createddate = dataSource["createddate"] as? String
                            item.closuredate = dataSource["closuredate"] as? String
                            item.status = dataSource["status"] as? String
                            item.guid = dataSource["guid"] as? String
                            item.addressline2 = dataSource["addressline2"] as? String
                            item.addressline1 = dataSource["addressline1"] as? String
                            item.phone = dataSource["phone"] as? String
                            item.city = dataSource["city"] as? String
                            item.zipcode = dataSource["zipcode"] as? String
                            item.email = dataSource["email"] as? String
                            item.technician = dataSource["technician"] as? String
                            item.dateassigned = dataSource["dateassigned"] as? String
                            item.digitalsign = dataSource["digitalsign"] as? String

                        }
                    } else if let item = findItemById(uid) where action == "delete" {
                        self.managedObjectContext.deleteObject(item)
                    }
                }
                if managedObjectContext.hasChanges {
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print("Failed to save in CoreData")
                    }
                }
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName("kAppDataUpdatedNotification", object: nil)
    }
    
    public func findItemById(uid: String) -> ShoppingItem? {
        let fetchRequest = NSFetchRequest(entityName: "ShoppingItem")
        fetchRequest.predicate = NSPredicate(format: "uid == %@", argumentArray: [uid])
        var fetchResults: [ShoppingItem]? = nil
        do {
            fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [ShoppingItem]
        } catch {
            print("DataManager::findItemById::Error fetching list")
        }
        if let results = fetchResults where results.count == 1 {
            return results[0]
        }
        return nil
    }
    
    public func listItems() -> [ShoppingItem]? {
        let fetchRequest = NSFetchRequest(entityName: "ShoppingItem")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        var fetchResults: [ShoppingItem]? = nil
        do {
            fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [ShoppingItem]
        } catch {
            print("DataManager::listItems::Error fetching list")
        }
        return fetchResults
    }
    public func listBothOpenAndAssignedItems() -> [ShoppingItem]? {
        let fetchRequest = NSFetchRequest(entityName: "ShoppingItem")
      
        var parameter: [NSPredicate] = [NSPredicate]()
//        parameter.append(NSPredicate(format: "status == %@", argumentArray: ["open"]))
        parameter.append(NSPredicate(format: "status == %@ OR status == %@ ", argumentArray: ["assigned","open"]))
        
        let compoundpred = NSCompoundPredicate.init(andPredicateWithSubpredicates: parameter)
        fetchRequest.predicate = compoundpred
        var fetchResults: [ShoppingItem]? = nil
        do {
            fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [ShoppingItem]
        } catch {
            print("DataManager::listBothOpenAndAssignedItems::Error fetching list")
        }
        
        return fetchResults
    }
    
    public func listFilteredItems(status: String) -> [ShoppingItem]? {
        let fetchRequest = NSFetchRequest(entityName: "ShoppingItem")
        fetchRequest.predicate = NSPredicate(format: "status == %@", argumentArray: [status])
        var fetchResults: [ShoppingItem]? = nil
        do {
            fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [ShoppingItem]
        } catch {
            print("DataManager::listAssignedItems::Error fetching list")
        }
        
        return fetchResults
        
    }
    
    public func createItem(item: ShoppingItem) {
      
        if let name = item.productname, let created = item.created?.timeIntervalSince1970 {
            let myItem: [String: AnyObject] = ["productname": name, "created": created*1000, "closuredate": item.closuredate!,"costofreplacement": item.costofreplacement!,"createddate": item.createddate!,"dateofpurchase": item.dateofpurchase!,"priority": item.priority!,"manufname": item.manufname!,"partname": item.partname!,"problemcomments": item.problemcomments!,"productcomments": item.productcomments!,"replacementreqd": item.replacementreqd!,"serialno": item.serialno!,"severitylevel": item.severitylevel!,"status": item.status!,"ticketid": item.ticketid!,"totalcharges": item.totalcharges!,"servicecharges": item.servicecharges!,"username": item.username!,"addressline1":  item.addressline1!,"addressline2": item.addressline2!,"phone": item.phone!,"email": item.email!,"zipcode":item.zipcode!,"city":item.city!,"technician":item.technician!,"dateassigned":item.dateassigned!,"digitalsign":""]
            managedObjectContext.deleteObject(item) // Remove the temporary coredata item for crete action
            syncClient.createWithDataId(DATA_ID, andData: myItem)
        }
    }

    public func updateItem(item: ShoppingItem) {
        if let uid = item.uid, let name = item.productname, let created = item.created?.timeIntervalSince1970, let digitalSign = item.digitalsign {
            let myItem: [String: AnyObject] = ["productname": name, "created": created*1000, "closuredate": item.closuredate!,"costofreplacement": item.costofreplacement!,"createddate": item.createddate!,"dateofpurchase": item.dateofpurchase!,"priority": item.priority!,"manufname": item.manufname!,"partname": item.partname!,"problemcomments": item.problemcomments!,"productcomments": item.productcomments!,"replacementreqd": item.replacementreqd!,"serialno": item.serialno!,"severitylevel": item.severitylevel!,"status": item.status!,"totalcharges": item.totalcharges!,"servicecharges": item.servicecharges!,"username": item.username!,"ticketid": item.ticketid!,"guid": item.guid!,"addressline1":  item.addressline1!,"addressline2": item.addressline2!,"phone": item.phone!,"email": item.email!,"zipcode":item.zipcode!,"city":item.city!,"technician":item.technician!,"dateassigned":item.dateassigned!,"digitalsign":digitalSign]
            syncClient.updateWithDataId(DATA_ID, andUID: uid, andData: myItem)

        }else if let uid = item.uid, let name = item.productname, let created = item.created?.timeIntervalSince1970{
            let myItem: [String: AnyObject] = ["productname": name, "created": created*1000, "closuredate": item.closuredate!,"costofreplacement": item.costofreplacement!,"createddate": item.createddate!,"dateofpurchase": item.dateofpurchase!,"priority": item.priority!,"manufname": item.manufname!,"partname": item.partname!,"problemcomments": item.problemcomments!,"productcomments": item.productcomments!,"replacementreqd": item.replacementreqd!,"serialno": item.serialno!,"severitylevel": item.severitylevel!,"status": item.status!,"totalcharges": item.totalcharges!,"servicecharges": item.servicecharges!,"username": item.username!,"ticketid": item.ticketid!,"guid": item.guid!,"addressline1":  item.addressline1!,"addressline2": item.addressline2!,"phone": item.phone!,"email": item.email!,"zipcode":item.zipcode!,"city":item.city!,"technician":item.technician!,"dateassigned":item.dateassigned!,"digitalsign":""]
            syncClient.updateWithDataId(DATA_ID, andUID: uid, andData: myItem)

        }
        

    }
    
    public func deleteItem(item: ShoppingItem) {
        if let uid = item.uid {
            syncClient.deleteWithDataId(DATA_ID, andUID: uid)
        }
    }
    
    public func getItem() -> ShoppingItem { // create a temporary coredata item to be created
        let entity = NSEntityDescription.entityForName("ShoppingItem", inManagedObjectContext: managedObjectContext)
        let newItem = ShoppingItem(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        return newItem
    }
    
    public func findItemByUserName(uName: String) -> UserDetails? {
        let fetchRequest = NSFetchRequest(entityName: "UserDetails")
        fetchRequest.predicate = NSPredicate(format: "username == %@", argumentArray: [uName])
        var fetchResults: [UserDetails]? = nil
        do {
            fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [UserDetails]
        } catch {
            print("DataManager::findItemByuName::Error fetching list")
        }
        if let results = fetchResults where results.count == 1 {
            return results[0]
        }
        return nil
    }
    
    public func findItemByUserNamePassword(uName: String, pWord: String) -> UserDetails? {
        let fetchRequest = NSFetchRequest(entityName: "UserDetails")
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", argumentArray: [uName,pWord])
        var fetchResults: [UserDetails]? = nil
        do {
            fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [UserDetails]
        } catch {
            print("DataManager::findItemByUserNamePassword::Error fetching list")
        }
        if let results = fetchResults where results.count == 1 {
            return results[0]
        }
        return nil
    }

    
    public func insertUserDetailRow(userDetailsDict:Dictionary<String,String>) -> Bool{
        print("userDetailsDict \(userDetailsDict)")

        if  (findItemByUserName(userDetailsDict["username"]!) as UserDetails! == nil) {
            let userArray = self.listUserDetailItems()
            if(userArray?.count != 0){
                self.DeleteAllObjectsFromUserDetails()
//                self.DeleteAllObjectsFromShoppingItem()
//                return false
            }
//            else{
                let existingObj = NSEntityDescription.insertNewObjectForEntityForName("UserDetails", inManagedObjectContext: managedObjectContext) as! UserDetails
                existingObj.setValue(userDetailsDict["username"], forKey: "username")
                existingObj.setValue(userDetailsDict["password"], forKey: "password")
                existingObj.setValue(userDetailsDict["userrole"], forKey: "userrole")
                existingObj.setValue(userDetailsDict["addressline1"], forKey: "addressline1")
                existingObj.setValue(userDetailsDict["addressline2"], forKey: "addressline2")
                existingObj.setValue(userDetailsDict["city"], forKey: "city")
                existingObj.setValue(userDetailsDict["email"], forKey: "email")
                existingObj.setValue(userDetailsDict["phone"], forKey: "phone")
                existingObj.setValue(userDetailsDict["zipcode"], forKey: "zipcode")
            if(NSUserDefaults.standardUserDefaults().objectForKey("DeviceToken") != nil){
                existingObj.setValue(userDetailsDict["username"], forKey: "devicetoken")
                NSUserDefaults.standardUserDefaults().removeObjectForKey("DeviceToken")
                NSUserDefaults.standardUserDefaults().synchronize()
            }else{
                existingObj.setValue("", forKey: "devicetoken")

            }

                print("existingObj \(existingObj)")
//            }
           

        }
        do {
            try managedObjectContext.save()
//            existing.append(existing)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return true
    }
    
    public func listUserDetailItems() -> [UserDetails]? {
        let fetchRequest = NSFetchRequest(entityName: "UserDetails")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "username", ascending: false)]
        var fetchResults: [UserDetails]? = nil
        do {
            fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [UserDetails]
        } catch {
            print("DataManager::listItems::Error fetching list")
        }
        return fetchResults
    }
    
    public func DeleteAllObjectsFromUserDetails() {
        
     
        let fetchRequest = NSFetchRequest(entityName: "UserDetails")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedObjectContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \("UserDetails") error : \(error) \(error.userInfo)")
        }
    
    }
    
    public func DeleteAllObjectsFromShoppingItem(){
        let fetchRequest = NSFetchRequest(entityName: "ShoppingItem")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedObjectContext.deleteObject(managedObjectData)
            }
//            let newUserAlert = UIAlertView.init(title: "", message: "Are you sure you want to login as a different user? All your saved data will be cleared.", delegate: self, cancelButtonTitle:"Cancel", otherButtonTitles: "Ok");
//            newUserAlert.show()
            
        } catch let error as NSError {
            print("Detele all data in \("UserDetails") error : \(error) \(error.userInfo)")
        }
    }
    

    
    
    public func deleteAllTicketData(entity: String)
    {
    
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedObjectContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    // MARK: - AlertView Delegate
    
    public func alertView(View: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
            if(buttonIndex == 1){
       
//                exit(10)
            }
            
        
    }
    
  
}