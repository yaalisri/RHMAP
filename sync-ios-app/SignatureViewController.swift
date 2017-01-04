//
//  SignatureViewController.swift
//  sync-ios-app
//
//  Created by Vidhya Sri on 11/25/16.
//  Copyright © 2016 FeedHenry. All rights reserved.
//

import UIKit
import SwiftSignatureView

public class SignatureViewController: UIViewController, UIAlertViewDelegate, SwiftSignatureViewDelegate {
    public var item: ShoppingItem!

    @IBOutlet weak var signatureImageView: UIImageView!
    
    @IBOutlet weak var signatureView: SwiftSignatureView!
    override public func viewDidLoad() {
        super.viewDidLoad()
       
        if(item.status == "closed"){
            signatureImageView.hidden = false
            signatureView.hidden = false
            signatureView.userInteractionEnabled = false
            let dataDecoded:NSData = NSData(base64EncodedString: item.digitalsign!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            signatureImageView.image =  UIImage(data:dataDecoded,scale:1.0)
        }else{
            if(NSUserDefaults.standardUserDefaults().objectForKey(item.ticketid!) != nil ){
                signatureImageView.hidden = false
                signatureView.hidden = false
                signatureView.userInteractionEnabled = false
                let dataDecoded:NSData = NSData(base64EncodedString: NSUserDefaults.standardUserDefaults().objectForKey(item.ticketid!) as! String!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                signatureImageView.image =  UIImage(data:dataDecoded,scale:1.0)
                let anotherButton : UIBarButtonItem = UIBarButtonItem(title:"Clear", style:UIBarButtonItemStyle.Plain, target: self, action:#selector(SignatureViewController.ClearButtonClicked(_:)))
                self.navigationItem.rightBarButtonItem = anotherButton
                
            }else{
                let anotherButton : UIBarButtonItem = UIBarButtonItem(title:"", style:UIBarButtonItemStyle.Plain, target: self, action:#selector(SignatureViewController.SaveButtonClicked(_:)))
                anotherButton.image = UIImage(named: "Save.png")
                
                self.navigationItem.rightBarButtonItem = anotherButton
                signatureImageView.hidden = true
                signatureView.hidden = false
                signatureView.userInteractionEnabled = true
                
            }
        }
        
        self.signatureView.delegate = self


        // Do any additional setup after loading the view.
    }
    
    func SaveButtonClicked(sender:AnyObject){
       
        let image : UIImage = signatureView!.signature!
        let imageData : NSData  = UIImagePNGRepresentation(image)!
        print("imageData \(imageData)")
//        let avatar64 = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
        let avatar64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)

//        let datastring = NSString(data:imageData, encoding:NSUTF8StringEncoding)
//        if let datastring = NSString(data:imageData, encoding:NSUTF8StringEncoding){
            NSUserDefaults.standardUserDefaults().setObject(avatar64, forKey: item.ticketid!)
            NSUserDefaults.standardUserDefaults().synchronize()
//        }


        let showAlert : UIAlertView = UIAlertView.init(title: "", message: "Signature Saved", delegate: self, cancelButtonTitle:nil, otherButtonTitles:"OK")
        showAlert.tag = 10
        showAlert.show()
        
        
    }
    
    func ClearButtonClicked(sender:AnyObject){
        let anotherButton : UIBarButtonItem = UIBarButtonItem(title:"", style:UIBarButtonItemStyle.Plain, target: self, action:#selector(SignatureViewController.SaveButtonClicked(_:)))
        anotherButton.image = UIImage(named: "Save.png")
        
        self.navigationItem.rightBarButtonItem = anotherButton
        signatureImageView.hidden = true
        signatureView.hidden = false
        signatureView.userInteractionEnabled = true

        
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AlertView Delegate
    
    public func alertView(View: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        if View.tag == 10 {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    //MARK: Delegate
    
    public func swiftSignatureViewDidTapInside(view: SwiftSignatureView) {
//        print("Did tap inside")
    }
    
    public func swiftSignatureViewDidPanInside(view: SwiftSignatureView) {
//        print("Did pan inside")
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
