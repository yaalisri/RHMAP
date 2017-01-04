//
//  CreateAccountController.swift
//  sync-ios-app
//
//  Created by Vidhya Sri on 11/11/16.
//  Copyright © 2016 FeedHenry. All rights reserved.
//

import UIKit
import FeedHenry


class CreateAccountController: UIViewController, UIScrollViewDelegate, UIAlertViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var addressLine1Field: UITextField!
    @IBOutlet weak var addressLine2Field: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "User Details"

        self.scrollView.delegate = self
        self.scrollView.scrollEnabled = true
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,1000)
     

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
//        self.navigationItem.hidesBackButton = true
        
    }
    override internal func viewDidLayoutSubviews(){
        
        self.scrollView.layer.contents = UIImage(named: "Background-1.png")?.CGImage
        self.containerView.layer.contents = UIImage(named: "Background-1.png")?.CGImage
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignUpClicked(sender: AnyObject) {
        var data = [String: AnyObject]()

        if let userName = self.usernameField.text where userName != "", let password = self.passwordField.text where password != "", let addressLine1 = self.addressLine1Field.text where addressLine1 != "", let addressLine2 = self.addressLine2Field.text where addressLine2 != "", let city = self.cityField.text where city != "", let zipCode = self.zipCodeField.text where zipCode != "", let phone = self.phoneField.text where phone != "", let email = self.emailField.text where email != "" {
            
            let utf8str = self.passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding)
            let base64Encoded = utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))

            data["username"] = self.usernameField.text
            data["password"] = base64Encoded
            data["addressline1"] = self.addressLine1Field.text
            data["addressline2"] = self.addressLine2Field.text
            data["city"] = self.cityField.text
            data["zipcode"] = self.zipCodeField.text
            data["phone"] = self.zipCodeField.text
            data["email"] = self.emailField.text
            data["userrole"] = "Customer"
            if(NSUserDefaults.standardUserDefaults().objectForKey("DeviceToken") != nil){
                data["devicetoken"] = NSUserDefaults.standardUserDefaults().objectForKey("DeviceToken") as! String!
            }else{
                data["devicetoken"] = ""
                
            }
            FH.cloud("/hello",
                     args: data,
                     completionHandler: {(resp: Response, error: NSError?) -> Void in
                        if let error = error {
                            print("Cloud Call Failed, \(error)")
                            return
                        }
                        
                        print("Success \(resp.parsedResponse)")
                        
                        let showAlert : UIAlertView = UIAlertView.init(title: "", message: "Account created successfully. Please login with your new credentials", delegate: self, cancelButtonTitle:nil, otherButtonTitles:"Ok")
                        showAlert.tag = 12
                        showAlert.show()
                      
            })

        }else{
            let showAlert : UIAlertView = UIAlertView.init(title: "", message: "All Fields are mandatory", delegate: nil, cancelButtonTitle:nil, otherButtonTitles:"Ok")
            showAlert.show()
        }
        
        
            }
    

    
    // MARK: - AlertView Delegate
    
    func alertView(View: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        if View.tag == 12 {
            
            if let parent = self.parentViewController as? UINavigationController {
                parent.popViewControllerAnimated(true)
            }
        }
    }
    
    // MARK: - TextField Delegate
    
    internal func textFieldShouldReturn(textField: UITextField) -> Bool{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        textField.resignFirstResponder()
        return true
    }
    
    internal func textFieldDidBeginEditing(textField: UITextField) -> Bool{
        
        let originInSuperview  = self.view.convertPoint(textField.frame.origin, toView: self.scrollView)
        if(textField == phoneField || textField == emailField){
            if(originInSuperview.y > 150){
                self.view.frame = CGRectMake(0, -(originInSuperview.y - 210), self.view.frame.size.width, self.view.frame.size.height)
            }
        }else{
            if(originInSuperview.y > 150){
                self.view.frame = CGRectMake(0, -(originInSuperview.y - 150), self.view.frame.size.width, self.view.frame.size.height)
            }
        }
       
        print("originInSuperview\(originInSuperview)")
        return true
    }
    
    internal func textFieldDidEndEditing(textField: UITextField) -> Bool{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        return true
    }
    
    
  
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
