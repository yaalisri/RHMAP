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

import UIKit
import FeedHenry

public class RootViewController: UITableViewController, UIAlertViewDelegate {
    public var items: [ShoppingItem]!
    public var sharedItem : ShoppingItem!
    public var dataManager: DataManager!
    public var fromViewString: String!
    var userDetails : UserDetails! = nil
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        self.navigationItem.title = "Tickets List"
        
        
        let anotherButton : UIBarButtonItem = UIBarButtonItem(title:"", style:UIBarButtonItemStyle.Plain, target: self, action:#selector(RootViewController.LogoutClicked(_:)))
        anotherButton.image = UIImage(named: "Signout.png")
        
        self.navigationItem.rightBarButtonItem = anotherButton
        
        //        self.editButtonItem.enabled = NO;
        self.navigationItem.leftBarButtonItem = nil;
        
        if(fromViewString == "AssignedTicketsView" || fromViewString == "TechnicianOpenTicketsView"){
            self.items = dataManager.listFilteredItems("assigned")
            
        }else  if(fromViewString == "TechnicianClosedTicketsView" || fromViewString == "ClosedTicketsView"){
            self.items = dataManager.listFilteredItems("closed")
            
        }else{
            let userNameStr : String = NSUserDefaults.standardUserDefaults().valueForKey("UserName") as! String!
            userDetails = self.dataManager.findItemByUserName(userNameStr)
            print("userDetails\(userDetails)")
            
            
            
            if(userDetails.userrole == "Customer}" || userDetails.userrole == "Customer"){
                self.items = dataManager.listBothOpenAndAssignedItems()
                
            }else{
                self.items = dataManager.listFilteredItems("open")
                
            }
            
            
        }
        // TODO once Swift2.2 is released change selector
        //let sel = #selector(RootViewController.onDataUpdated(_))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RootViewController.onDataUpdated(_:)), name: "kAppDataUpdatedNotification", object: nil)
        tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCellOne")
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func onDataUpdated(note: NSNotification) {
        print("::onDataUpdated::refresh tableview")
        if(fromViewString == "AssignedTicketsView" || fromViewString == "TechnicianOpenTicketsView"){
            self.items = dataManager.listFilteredItems("assigned")
            
        }else  if(fromViewString == "TechnicianClosedTicketsView" || fromViewString == "ClosedTicketsView"){
            self.items = dataManager.listFilteredItems("closed")
            
        }else{
            let userNameStr : String = NSUserDefaults.standardUserDefaults().valueForKey("UserName") as! String!
            userDetails = self.dataManager.findItemByUserName(userNameStr)
            print("userDetails\(userDetails)")
            
            
            
            if(userDetails.userrole == "Customer}" || userDetails.userrole == "Customer"){
                self.items = dataManager.listBothOpenAndAssignedItems()
                
            }else{
                self.items = dataManager.listFilteredItems("open")
                
            }
            
            
        }

        
        tableView.reloadData()
    }
    
    func LogoutClicked(sender:AnyObject){
        let showAlert : UIAlertView = UIAlertView.init(title: "", message: "Are you sure you want to logout from the application?", delegate: self, cancelButtonTitle:"No", otherButtonTitles:"Yes")
        showAlert.tag = 10
        showAlert.show()
        
        
    }
    
    // MARK: - AlertView Delegate
    
    public func alertView(View: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        if View.tag == 10 {
            if(buttonIndex == 1){
                let syncClient = dataManager.syncClient
                // Unique Id for the dataset to manage.
                syncClient.destroy();
                
                NSUserDefaults.standardUserDefaults().setObject("", forKey: "UserName")
                NSUserDefaults.standardUserDefaults().synchronize()
                syncClient.stopWithDataId(DATA_ID)
                
                NSNotificationCenter.defaultCenter().removeObserver("kFHSyncStateChangedNotification")
                //                   FHAuthSession.clear(false);
                
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            
        }
    }
}




// MARK: UITableViewDataSource, UITableViewDelegate
extension RootViewController {
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCellOne", forIndexPath: indexPath) as! CustomTableViewCell
        
        tableView.separatorColor = UIColor.lightGrayColor()
        cell.backgroundColor = UIColor(patternImage:UIImage(named: "Background-1.png")!)
        
        let item = self.items[indexPath.row]
        print("item \(item)")
        if let itemName = item.productname {
            if(item.guid == "" || item.guid == nil){
                cell.syncIcon.hidden = false
            }else{
                cell.syncIcon.hidden = true
                
            }
            cell.ticketNoLbl.text = item.ticketid!
            cell.productNameLbl.text = "\(itemName)"
            
        }
        
        tableView.layer.contents = UIImage(named: "Background-1.png")?.CGImage
        
        return cell
    }
    public override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            dataManager.deleteItem(items[indexPath.row])
            tableView.reloadData()
        }
    }
    public override func tableView(showExistingItemDetails: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        sharedItem = self.items[indexPath.row]
        print("sharedItem\(sharedItem)")
        if(sharedItem.guid == "" || sharedItem.guid == nil){
            let showAlert : UIAlertView = UIAlertView.init(title: "", message: "You cannot modify this record until it is synchronized with the backend.", delegate: nil, cancelButtonTitle:nil, otherButtonTitles:"Ok")
            showAlert.show()
        }else{
            
            
            let userNameStr : String = NSUserDefaults.standardUserDefaults().valueForKey("UserName") as! String!
            
            let userDetails = self.dataManager.findItemByUserName(userNameStr) as UserDetails!
            
            print("userDetails\(userDetails)")
            
            if(sharedItem.status == "closed"){
                performSegueWithIdentifier("TechnicianTicketView", sender:nil)

            }else{
                if(userDetails.userrole == "Supervisor"){
                    performSegueWithIdentifier("SupervisorTicketView", sender:nil)
                    
                }else if(userDetails.userrole == "Technician"){
                    performSegueWithIdentifier("TechnicianTicketView", sender:nil)
                    
                }else{
                    performSegueWithIdentifier("showExistingItemDetails", sender:nil)
                    
                }
                
            }
            
          
            
        }
    }
}

// MARK: Segue
extension RootViewController {
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier where identifier == "showExistingItemDetails" {
            
            let dest = segue.destinationViewController as? DetailledViewController
            dest?.item = sharedItem
            dest?.dataManager = dataManager
        } else if let identifier = segue.identifier where identifier == "showNewItemDetails" {
            let dest = segue.destinationViewController as? DetailledViewController
            //dest?.item = dataManager.getItem()
            dest?.dataManager = dataManager
        }else  if let identifier = segue.identifier where identifier == "SupervisorTicketView" {
            
            let dest = segue.destinationViewController as? SupervisorEditViewController
            dest?.item = sharedItem
            dest?.dataManager = dataManager
        }else  if let identifier = segue.identifier where identifier == "TechnicianTicketView" {
            
            let dest = segue.destinationViewController as? TechnicianViewController
            dest?.item = sharedItem
            dest?.dataManager = dataManager
        }
        
        
    }
}