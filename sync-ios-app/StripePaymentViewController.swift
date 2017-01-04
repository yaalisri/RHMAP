//
//  StripePaymentViewController.swift
//  sync-ios-app
//
//  Created by Vidhya Sri on 12/1/16.
//  Copyright © 2016 FeedHenry. All rights reserved.
//

import UIKit
import AFNetworking
import Stripe
import MBProgressHUD
import FeedHenry

public class StripePaymentViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate{
    
    var item: ShoppingItem!

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var cvcField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var headerView: UIView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")


        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

    // MARK: - Text field delegate
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    // MARK: Actions
    
    @IBAction func MakePaymentClicked(sender: AnyObject) {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.label.text = "Making Payment"
        
        // Initiate the card
        let stripCard = STPCard()
        
        // Split the expiration date to extract Month & Year
        if self.dateField.text!.isEmpty == false {
            let expirationDate = self.dateField.text!.componentsSeparatedByString("/")
            let expMonth = Int(expirationDate[0])
            let expYear = Int(expirationDate[1])
            
            // Send the card info to Strip to get the token
            stripCard.number = self.cardNumberField.text
            stripCard.cvc = self.cvcField.text
            stripCard.expMonth = UInt(expMonth!)
            stripCard.expYear = UInt(expYear!)
            
        }
        
        //        var underlyingError: NSError?
        do {
            try stripCard.validateCardReturningError()
        } catch let error as NSError {
            print("error saving core data: \(error)")
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

            self.handleError(error)
            return
        }
   
        
        STPAPIClient.sharedClient().createTokenWithCard(stripCard, completion: { (token, error) -> Void in
            
            if error != nil {
                self.handleError(error!)
                return
            }
            
            self.postStripeToken(token!)
        })
        
        
    }
    
    func handleError(error: NSError) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

        UIAlertView(title: "Please Try Again",
                    message: error.localizedDescription,
                    delegate: nil,
                    cancelButtonTitle: "OK").show()
        
    }
    
    func postStripeToken(token: STPToken) {
        var params = [:]
        params = ["stripeToken": token.tokenId,
                  "amount": Int(self.amountField.text!)!,
                  "currency": "usd",
                  "description": self.emailField.text!]
        FH.cloud("/payment",
                 args: params as? [String : AnyObject],
                 completionHandler: {(resp: Response, error: NSError?) -> Void in
                    if error != nil {
                        print("Cloud Call Failed, \\(error)")
                        return
                    }
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    
                    if let response = resp.parsedResponse as? [String: String] {
                       
                        UIAlertView(title: response["status"],
                            message: response["message"],
                            delegate: self,
                            cancelButtonTitle: "OK").show()
                        let resStatus = response["status"]
                        if(resStatus! == "Success" ){
                            NSUserDefaults.standardUserDefaults().setObject("Success", forKey: "Payment\(self.item.ticketid)")
                            NSUserDefaults.standardUserDefaults().synchronize()
                        }
                    }
                    
                    print("Success \(resp.parsedResponse)")
        })
        
        
//        let URL = "http://localhost/donate/payment.php"
       
        
//        let manager = AFHTTPRequestOperationManager()
//        manager.POST(URL, parameters: params, success: { (operation, responseObject) -> Void in
//            
//            if let response = responseObject as? [String: String] {
//                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//
//                UIAlertView(title: response["status"],
//                    message: response["message"],
//                    delegate: self,
//                    cancelButtonTitle: "OK").show()
//            }
//
//        }) { (operation, error) -> Void in
//            self.handleError(error!)
//        }
    }
    
    // MARK: - AlertView Delegate
    
    public func alertView(View: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
 



}
