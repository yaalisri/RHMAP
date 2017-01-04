//
//  LoginViewController.swift
//  sync-ios-app
//
//  Created by Vidhya Sri on 07/10/16.
//  Copyright © 2016 FeedHenry. All rights reserved.
//

import UIKit
import FeedHenry
import MBProgressHUD

import SystemConfiguration



public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}



public class LoginViewController: UIViewController, UITextFieldDelegate {
    public var dataManager: DataManager!

    var messages: [String] = []
    var isRegistered = false
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
 
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.delegate = self
        usernameField.delegate = self
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.registered), name: "success_registered", object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.errorRegistration), name: "error_register", object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.messageReceived(_:)), name: "message_received", object: nil)
        // Do any additional setup after loading the view.
    }
    
    func registered() {
        print("registered")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let msg = defaults.objectForKey("message_received")
        defaults.removeObjectForKey("message_recieved")
        defaults.synchronize()
        
        if (msg != nil) {
            messages.append(msg as! String)
        }
        
        isRegistered = true
    }
    
    func errorRegistration() {
        let alert = UIAlertView()
        alert.title = "Registration Error"
        alert.message = "Please verify the provisionioning profile and the UPS details have been setup correctly."
        alert.show()
    }
    
    func messageReceived(notification: NSNotification) {
        print("received")
        
        let obj:AnyObject? = notification.userInfo!["aps"]!["alert"]
        
        // if alert is a flat string
        if let msg = obj as? String {
            messages.append(msg)
        } else {
            // if the alert is a dictionary we need to extract the value of the body key
            let msg = obj!["body"] as! String
            messages.append(msg)
        }
        
    }
    public override func viewWillAppear(animated: Bool) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

    }


    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginWithGmailClicked(sender: AnyObject) {
        
//        //To check if user is already authenticated
//        let hasSession =
//        if(hasSession) {
//            //optionally we can also verify the session is acutally valid from client. This requires network connection.
//            [FH verifyAuthSessionWithSuccess:nil AndFailure:nil];
//        }
       
      
        
        let request = FH.authRequest("Google") //"MyOAuthPolicy" should be replaced with policy id you created
        request.parentViewController = self //Important, this will enable the built-in OAuth handler
        request.exec({ (response: Response, error: NSError?) -> Void in
            if let error = error {
                print("Error connecting \(error)")
                return
            }
            
            print("Response first \(response.parsedResponse)")

            if let response = response.parsedResponse {

                if let status = response["status"] where status as! String == "complete" {
                    let authDict : NSDictionary  = response["authResponse"] as! NSDictionary!
                    var userDetailObj  = [String: String]()
                    userDetailObj["email"] = authDict.valueForKey("email") as! String!
                    userDetailObj["username"] = authDict.valueForKey("given_name") as! String!
                    userDetailObj["password"] = ""
                    userDetailObj["phone"] = ""
                    userDetailObj["zipcode"] = ""
                    userDetailObj["addressline1"] = ""
                    userDetailObj["addressline2"] = ""
                    userDetailObj["city"] = ""
                    userDetailObj["userrole"] = "Customer"
                    print("self.dataManager \(self.dataManager)")

                  let insertSuccess =  self.dataManager.insertUserDetailRow(userDetailObj)
                    
                    if(insertSuccess){
                        let myDelegate = UIApplication.sharedApplication().delegate as! AppDelegate!
                        
                        myDelegate.startSyncClient(authDict.valueForKey("given_name") as! String)
                        
                        NSUserDefaults.standardUserDefaults().setObject(authDict.valueForKey("given_name") as! String, forKey: "UserName")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        let menuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MenuView") as! MenuViewController
                        menuViewController.dataManager = self.dataManager
                        self.navigationController?.pushViewController(menuViewController, animated: true)
                    }
                   
                    print("Response here \(authDict.valueForKey("given_name"))")
                } else if let status = response["status"] where status as! String == "error" {
                    let message = response["message"] ?? ""
                    print("OAuth failed \(message)")
                    
                }
            }

        })
    }
    
     @IBAction func LoginWithUserCred(sender: AnyObject) {
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.label.text = "Loading"

        
       print("network", Reachability.isConnectedToNetwork())
        
        if(Reachability.isConnectedToNetwork() == true){
            
            FH.init {(resp: Response, error: NSError?) -> Void in
                if let error = error {
                    print("FH init failed. Error = \(error)")
                    if FH.isOnline == false {
                        print("Make sure you're online.")
                    } else {
                        
                        
                    }
                }
                
                let utf8str = self.passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding)
                let base64Encoded = utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))

                    FH.auth("mBassAuthService", userName: self.usernameField.text!, password: base64Encoded, completionHandler: { (response: Response, error: NSError?) -> Void in
                        if let error = error {
                            print("Error \(error)")
                            return
                        }
                        if let response = response.parsedResponse as? [String: String]{
                            if let status = response["status"] where status == "ok" {
                                if let msg = response["msg"] where msg == "Login Failure"{
                                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                    
                                    let invalidUserAlert = UIAlertView.init(title: "", message: "Invalid Username or Password", delegate: nil, cancelButtonTitle:nil, otherButtonTitles: "Ok");
                                    invalidUserAlert.show()
                                    
                                }else{
                                    var fbIds = response["userdata"]
                                    
                                    if ((fbIds?.hasPrefix("{")) != nil){
                                        fbIds = (fbIds! as NSString).substringFromIndex(1)
                                    }
                                    fbIds = (fbIds! as NSString).substringToIndex(fbIds!.characters.count)
                                    
                                    
                                    var userDetailObj = [String : String]()
                                    
                                    var userArray = []
                                    userArray = (fbIds?.componentsSeparatedByString(", "))!
                                    
                                    
                                    var sum = 0
                                    for i in 0...userArray.count - 1 {
                                        sum += i
                                        let componentsArray = userArray[i].componentsSeparatedByString("=")
                                        userDetailObj[componentsArray[0]] = componentsArray[1]
                                        if(componentsArray[0] == "username"){
                                            NSUserDefaults.standardUserDefaults().setObject(componentsArray[1], forKey: "UserName")
                                            NSUserDefaults.standardUserDefaults().synchronize()
                                        }
                                        
                                    }
                                    
                                    print("self.dataManager \(self.dataManager)")
                                    
                                    let insertSuccess =  self.dataManager.insertUserDetailRow(userDetailObj)
                                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

                                    if(insertSuccess){
                                        
                                        #if (arch(i386) || arch(x86_64)) && os(iOS)
                                        
                                            //Simulator
                                            
                                        #else
                                            
                                            // Device
                                            FH.setPushAlias(NSUserDefaults.standardUserDefaults().objectForKey("UserName") as! String!,  success:{ res in
                                                print("alias Push registration successful")
                                                }, error: {failed in
                                                    print("alias Push registration Error \(failed.error)")
                                            })
                                            
                                        #endif
                                          
                                       
                                        let myDelegate = UIApplication.sharedApplication().delegate as! AppDelegate!
                                        
                                        myDelegate.startSyncClient(userDetailObj["username"]!)

                                        let menuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MenuView") as! MenuViewController
                                        menuViewController.dataManager = self.dataManager
                                        self.navigationController?.pushViewController(menuViewController, animated: true)
                                    }
                                   
                                    print("Response \(response)")
                                }
                                
                                
                            } else if let status = response["status"] where status == "error" {
                                let message = response["message"] ?? ""
                                print("OAuth failed \(message)")
                            }
                        }
                    })
                }
                //Example to authenticate user using username and password
               //                print("initialized OK:: Starting SyncClient login", resp)

                //            self.dataManager.start()
//            }

            
        }else{
            
            print("self.dataManager \(self.dataManager)")
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)


            if  (self.dataManager.findItemByUserNamePassword(self.usernameField.text!, pWord: self.passwordField.text!) as UserDetails! == nil) {
                if(self.dataManager.listUserDetailItems()?.count != 0){
                    let invalidUserAlert = UIAlertView.init(title: "", message: "Invalid Username or Password", delegate: nil, cancelButtonTitle:nil, otherButtonTitles: "Ok");
                    invalidUserAlert.show()
                }else{
                    let offlineUserAlert = UIAlertView.init(title: "", message: "Application is not synchronized even once. Please connect to network and try again", delegate: nil, cancelButtonTitle:nil, otherButtonTitles: "Ok");
                    offlineUserAlert.show()
                }
              
                
            }else{
                NSUserDefaults.standardUserDefaults().setObject(self.usernameField.text!, forKey: "UserName")
                NSUserDefaults.standardUserDefaults().synchronize()
                let myDelegate = UIApplication.sharedApplication().delegate as! AppDelegate!
                
                myDelegate.startSyncClient(self.usernameField.text!)
                let menuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MenuView") as! MenuViewController
                menuViewController.dataManager = self.dataManager
                self.navigationController?.pushViewController(menuViewController, animated: true)

            }
            
            
        }
        
       
    }
    
    // MARK: - TextField Delegate
    
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool{
        //        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        textField.resignFirstResponder()
        return true
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let identifier = segue.identifier where identifier == "CreateNewAccount" {
//            FH.init {(resp: Response, error: NSError?) -> Void in
//                if let error = error {
//                    print("FH init failed. Error = \(error)")
//                    if FH.isOnline == false {
//                        print("Make sure you're online.")
//             
//                        print("Please fill in fhconfig.plist file.")
//                        print("initialized OK:: Starting SyncClient", resp)
//                        
//                    } else {
//                        
//                    }
//                    return
//                }
//         
//            }
//
//        }
        
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
