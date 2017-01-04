//
//  MenuViewController.swift
//  sync-ios-app
//
//  Created by Vidhya Sri on 11/10/16.
//  Copyright © 2016 FeedHenry. All rights reserved.
//

import UIKit


 class MenuViewController: UIViewController, UIAlertViewDelegate {
    internal var dataManager: DataManager!

    @IBOutlet weak var createNewTicketView: UIView!
    @IBOutlet weak var assignedView: UIView!
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var closedTicketsView: UIView!
    @IBOutlet weak var openTicketsView: UIView!
    @IBOutlet weak var technicianFeedbackView: UIView!
    @IBOutlet weak var technicianOpenTicketView: UIView!
    @IBOutlet weak var technicianClosedTicketView: UIView!
    @IBOutlet weak var chatBtn: UIButton!
     override func viewDidLoad() {
        let userNameStr : String = NSUserDefaults.standardUserDefaults().valueForKey("UserName") as! String!
        let userDetails = self.dataManager.findItemByUserName(userNameStr) as UserDetails!
        
        if(userDetails.userrole == "Supervisor"){
            self.assignedView.hidden = false
            self.createNewTicketView.hidden = true
            self.technicianFeedbackView.hidden = true
            self.technicianOpenTicketView.hidden = true
            self.technicianClosedTicketView.hidden = true
            self.feedbackView.hidden = false
            self.closedTicketsView.hidden = false
            self.openTicketsView.hidden = false

        }else if(userDetails.userrole == "Technician"){
            self.assignedView.hidden = true
            self.createNewTicketView.hidden = true
            self.technicianFeedbackView.hidden = false
            self.technicianOpenTicketView.hidden = false
            self.technicianClosedTicketView.hidden = false
            self.feedbackView.hidden = true
            self.closedTicketsView.hidden = true
            self.openTicketsView.hidden = true
            chatBtn.hidden = false
            
        }else{
            self.assignedView.hidden = true
            self.createNewTicketView.hidden = false
            self.technicianFeedbackView.hidden = true
            self.technicianOpenTicketView.hidden = true
            self.technicianClosedTicketView.hidden = true
            self.feedbackView.hidden = false
            self.closedTicketsView.hidden = false
            self.openTicketsView.hidden = false
        }
        
        let anotherButton : UIBarButtonItem = UIBarButtonItem(title:"", style:UIBarButtonItemStyle.Plain, target: self, action:#selector(RootViewController.LogoutClicked(_:)))
        anotherButton.image = UIImage(named: "Signout.png")
        
        self.navigationItem.rightBarButtonItem = anotherButton
        
//        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
//            
//            self.createNewTicketView.transform = CGAffineTransformMakeScale(0.6, 0.6)
//            self.technicianFeedbackView.transform = CGAffineTransformMakeScale(0.6, 0.6)
//            self.technicianOpenTicketView.transform = CGAffineTransformMakeScale(0.6, 0.6)
//            self.technicianClosedTicketView.transform = CGAffineTransformMakeScale(0.6, 0.6)
//            self.feedbackView.transform = CGAffineTransformMakeScale(0.6, 0.6)
//            self.closedTicketsView.transform = CGAffineTransformMakeScale(0.6, 0.6)
//            self.openTicketsView.transform = CGAffineTransformMakeScale(0.6, 0.6)
//            self.assignedView.transform = CGAffineTransformMakeScale(0.6, 0.6)
//            // do stuff
//        }), completion: { finish in
//            UIView.animateWithDuration(0.6){
//                self.createNewTicketView.transform = CGAffineTransformIdentity
//                self.technicianFeedbackView.transform = CGAffineTransformIdentity
//                self.technicianOpenTicketView.transform = CGAffineTransformIdentity
//                self.technicianClosedTicketView.transform = CGAffineTransformIdentity
//                self.feedbackView.transform = CGAffineTransformIdentity
//                self.closedTicketsView.transform = CGAffineTransformIdentity
//                self.openTicketsView.transform = CGAffineTransformIdentity
//                self.assignedView.transform = CGAffineTransformIdentity
//                
//            }
//        })
        
        UIView.animateWithDuration(0.6 ,
                                   animations: {
                                    self.createNewTicketView.transform = CGAffineTransformMakeScale(0.6, 0.6)
                                    self.technicianFeedbackView.transform = CGAffineTransformMakeScale(0.6, 0.6)
                                    self.technicianOpenTicketView.transform = CGAffineTransformMakeScale(0.6, 0.6)
                                    self.technicianClosedTicketView.transform = CGAffineTransformMakeScale(0.6, 0.6)
                                    self.feedbackView.transform = CGAffineTransformMakeScale(0.6, 0.6)
                                    self.closedTicketsView.transform = CGAffineTransformMakeScale(0.6, 0.6)
                                    self.openTicketsView.transform = CGAffineTransformMakeScale(0.6, 0.6)
                                    self.assignedView.transform = CGAffineTransformMakeScale(0.6, 0.6)

            },
                                   completion: { finish in
                                    UIView.animateWithDuration(0.6){
                                        self.createNewTicketView.transform = CGAffineTransformIdentity
                                        self.technicianFeedbackView.transform = CGAffineTransformIdentity
                                        self.technicianOpenTicketView.transform = CGAffineTransformIdentity
                                        self.technicianClosedTicketView.transform = CGAffineTransformIdentity
                                        self.feedbackView.transform = CGAffineTransformIdentity
                                        self.closedTicketsView.transform = CGAffineTransformIdentity
                                        self.openTicketsView.transform = CGAffineTransformIdentity
                                        self.assignedView.transform = CGAffineTransformIdentity

                                    }
        })
        
     

      
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Dashboard"

    }
    
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            let item : ShoppingItem! = nil
        if segue.identifier == "NewTicketView" {
//            item = dataManager.getItem()
            let dest = segue.destinationViewController as! DetailledViewController
            dest.item = item
            dest.dataManager = self.dataManager
            dest.action = "create"
         
        }else if segue.identifier == "AssignedTicketsView" {
            //            item = dataManager.getItem()
            let dest = segue.destinationViewController as! RootViewController
            dest.fromViewString = "AssignedTicketsView"
            dest.dataManager = self.dataManager
        }else  if segue.identifier == "TechnicianOpenTicketsView"{
            let dest = segue.destinationViewController as! RootViewController
            dest.fromViewString = "TechnicianOpenTicketsView"
            dest.dataManager = self.dataManager
        }else  if segue.identifier == "ClosedTicketsView"{
            let dest = segue.destinationViewController as! RootViewController
            dest.fromViewString = "ClosedTicketsView"
            dest.dataManager = self.dataManager
        }else  if segue.identifier == "TechnicianClosedTicketsView"{
            let dest = segue.destinationViewController as! RootViewController
            dest.fromViewString = "TechnicianClosedTicketsView"
            dest.dataManager = self.dataManager
        }else{
            let dest = segue.destinationViewController as! RootViewController
            dest.fromViewString = "AllTicketsView"
            dest.dataManager = self.dataManager
        }
        
    }
    func LogoutClicked(sender:AnyObject){
        let showAlert : UIAlertView = UIAlertView.init(title: "", message: "Are you sure you want to logout from the application?", delegate: self, cancelButtonTitle:"No", otherButtonTitles:"Yes")
        showAlert.tag = 10
        showAlert.show()
        
    }
    
    @IBAction func OpenChatBot(sender: AnyObject) {
        
    UIApplication.sharedApplication().openURL(NSURL(string:"https://m.me/735441139942191")!)
        
    }
    // MARK: - AlertView Delegate
    
    internal func alertView(View: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
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
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.navigationController?.popToRootViewControllerAnimated(true)

                })
            }
            
        }
    }
}
