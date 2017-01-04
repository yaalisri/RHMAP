//
//  TechnicianViewController.swift
//  sync-ios-app
//
//  Created by Vidhya Sri on 11/24/16.
//  Copyright © 2016 FeedHenry. All rights reserved.
//

import UIKit

public class TechnicianViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate, UITextViewDelegate {
    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var addressText: UITextView!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeTicketBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var manufName: UITextField!
    @IBOutlet weak var serialNo: UITextField!
    @IBOutlet weak var priorityField: UITextField!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var productComments: UITextView!
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var partName: UITextField!
    @IBOutlet weak var severeitySegment: UISegmentedControl!
    @IBOutlet weak var costOfReplacement: UITextField!
    @IBOutlet weak var problemComments: UITextView!
    @IBOutlet weak var serviceCharges: UITextField!
    @IBOutlet weak var totalCharges: UITextField!
    @IBOutlet weak var replacementSwitch: UISwitch!
    @IBOutlet weak var problemView: UIView!

    @IBOutlet weak var selectPaymentBtn: UIButton!
    @IBOutlet weak var dateOfPurchase: UITextField!
    @IBOutlet weak var productName: UITextField!
    public var dataManager: DataManager!
    public var item: ShoppingItem!
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.productView.layer.borderWidth = 1
        self.productView.layer.borderColor = UIColor.blackColor().CGColor
        
        self.customerView.layer.borderWidth = 1
        self.customerView.layer.borderColor = UIColor.blackColor().CGColor
        
        self.problemView.layer.borderWidth = 1
        self.problemView.layer.borderColor = UIColor.blackColor().CGColor
        

        self.costOfReplacement.addTarget(self, action: #selector(TechnicianViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
         self.serviceCharges.addTarget(self, action: #selector(TechnicianViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        self.totalCharges.userInteractionEnabled = false

        // Do any additional setup after loading the view.
    }
    
    override public func viewWillAppear(animated: Bool) {

        if(NSUserDefaults.standardUserDefaults().objectForKey("Payment\(self.item.ticketid)") != nil &&  NSUserDefaults.standardUserDefaults().objectForKey("Payment\(self.item.ticketid)") as! String! == "Success" ){
            
        self.selectPaymentBtn.titleLabel!.text = "$\(self.totalCharges.text as String!) paid"
      

        }
    }
    
    public func textFieldDidChange(textField: UITextField){
        if(textField == serviceCharges || textField == costOfReplacement || textField == totalCharges){
          
            print("\(serviceCharges.text)=======\(costOfReplacement.text)")
            if(serviceCharges.text != "" && costOfReplacement.text != ""){
                totalCharges.text = "\(Int(serviceCharges.text!)! + Int(costOfReplacement.text!)!)"
                
            }else if(serviceCharges.text == "" && costOfReplacement.text != ""){
                totalCharges.text = "\(Int(costOfReplacement.text!)!)"
                
            }else if(serviceCharges.text != "" && costOfReplacement.text == ""){
                totalCharges.text = "\(Int(serviceCharges.text!)!)"
                
            }
        }

    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func viewDidLayoutSubviews(){
        
        self.scrollView.layer.contents = UIImage(named: "Background-1.png")?.CGImage
        self.containerView.layer.contents = UIImage(named: "Background-1.png")?.CGImage
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.width, self.closeTicketBtn.frame.origin.y+self.closeTicketBtn.frame.height+50)
        self.containerView.frame = CGRectMake(0, 0,self.view.frame.width, 2000)
        problemComments.alpha = 0.5

        if let item = item {
            productComments.alpha = 1
            problemComments.alpha = 1
            self.navigationItem.title = "Ticket Details"
            self.customerName.text = item.username
            self.addressText.text = item.addressline1! + "\n" + item.addressline2!
            self.cityField.text = item.city
            self.zipCodeField.text = item.zipcode
            self.phoneNo.text = item.phone
            self.emailField.text = item.email
            self.productName.text = item.productname
            self.serialNo.text = item.serialno
            self.manufName.text = item.manufname
            self.productComments.text = item.productcomments
            self.dateOfPurchase.text = item.dateofpurchase
            self.priorityField.text = item.priority
            
            if(item.status == "closed"){
                closeTicketBtn.hidden = true
                selectPaymentBtn.userInteractionEnabled = false
                selectPaymentBtn.titleLabel!.text = "$\(item.totalcharges as String!) paid"
                partName.text = item.partname
                partName.userInteractionEnabled = false
                severeitySegment.userInteractionEnabled = false
                replacementSwitch.userInteractionEnabled = false
                costOfReplacement.userInteractionEnabled = false
                serviceCharges.userInteractionEnabled = false
                totalCharges.userInteractionEnabled = false
                problemComments.userInteractionEnabled = false
                if(item.severitylevel == "Low"){
                    severeitySegment.selectedSegmentIndex = 0
                }else if(item.severitylevel == "Med"){
                    severeitySegment.selectedSegmentIndex = 1
                    
                }else if(item.severitylevel == "High"){
                    severeitySegment.selectedSegmentIndex = 2
                    
                }
                if(item.replacementreqd == "Yes"){
                    replacementSwitch.on = true
                }
                costOfReplacement.text = item.costofreplacement
                serviceCharges.text = item.servicecharges
                totalCharges.text = item.totalcharges
                problemComments.text = item.problemcomments
                
            }
            
        }
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("Payment\(self.item.ticketid)") != nil &&  NSUserDefaults.standardUserDefaults().objectForKey("Payment\(self.item.ticketid)") as! String! == "Success" ){
            
            self.selectPaymentBtn.titleLabel!.text = "$\(self.totalCharges.text as String!) paid"
            
            
        }
        
        
    }
  

    @IBAction func DigitalSignatureClicked(sender: AnyObject) {
        
        
    }
    @IBAction func CloseTicketClicked(sender: AnyObject) {
              if let itemObj = item {
        itemObj.technician = item.technician
        itemObj.dateassigned = item.dateassigned
        itemObj.status = "closed"
        itemObj.addressline1 = item.addressline1
        itemObj.addressline2 = item.addressline2
        itemObj.city = item.city
        itemObj.closuredate = String(format:"%@", NSDate())
        itemObj.costofreplacement = costOfReplacement.text
        //                itemObj.created = String(format:"%@", NSDate())
        itemObj.createddate = item.createddate
        itemObj.dateofpurchase = item.dateofpurchase
        itemObj.email = item.email
        itemObj.guid = item.guid
        itemObj.manufname = item.manufname
        itemObj.partname = partName.text
        itemObj.phone = item.phone
        itemObj.priority = item.priority
        itemObj.problemcomments = problemComments.text
        itemObj.productcomments = item.productcomments
        itemObj.productname = item.productname
                if(self.replacementSwitch.on){
                    itemObj.replacementreqd = "Yes"
                    
                }else{
                    itemObj.replacementreqd = "No"
                    
                }
        itemObj.serialno = item.serialno
        itemObj.servicecharges = serviceCharges.text
        itemObj.totalcharges = totalCharges.text
        itemObj.username = item.username
        itemObj.zipcode = item.zipcode
//                let avatarData = NSData(base64EncodedString: NSUserDefaults.standardUserDefaults().objectForKey(item.ticketid!) as! String!, options: NSDataBase64DecodingOptions(rawValue: 0));
                print("avatarData \(NSUserDefaults.standardUserDefaults().objectForKey(item.ticketid!) as! String!)")

                if(NSUserDefaults.standardUserDefaults().objectForKey(item.ticketid!) != nil && itemObj.problemcomments != "" && itemObj.costofreplacement != "" && itemObj.servicecharges != "" && itemObj.totalcharges != "" ){
                    
                    let title : String = self.severeitySegment.titleForSegmentAtIndex(self.severeitySegment.selectedSegmentIndex)!
                    
                    itemObj.severitylevel = title
                    
                    itemObj.digitalsign = NSUserDefaults.standardUserDefaults().objectForKey(item.ticketid!) as! String!
                    dataManager.updateItem(itemObj)
                    
                    let showAlert : UIAlertView = UIAlertView.init(title: "", message: "Ticket closed successfully", delegate: self, cancelButtonTitle:nil, otherButtonTitles:"OK")
                    showAlert.show()
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("Payment\(self.item.ticketid)")
                    NSUserDefaults.standardUserDefaults().synchronize()

                }else{
                    
                    let showAlert : UIAlertView = UIAlertView.init(title: "", message: "All fields are mandatory", delegate: nil, cancelButtonTitle:nil, otherButtonTitles:"OK")
                    showAlert.show()
                    
                }
        
        }
        
    }
    
    // MARK: - TextField Delegate

    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(textField == serviceCharges || textField == costOfReplacement || textField == totalCharges){
            let aSet = NSCharacterSet(charactersInString:"0123456789.").invertedSet
            let compSepByCharInSet = string.componentsSeparatedByCharactersInSet(aSet)
            let numberFiltered = compSepByCharInSet.joinWithSeparator("")

            return string == numberFiltered
        }
        
   return true
        
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool{
        //        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        textField.resignFirstResponder()
        return true
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier where identifier == "DigitalSignView" {
            let dest = segue.destinationViewController as? SignatureViewController
            dest?.item = item
        
        }else if let identifier = segue.identifier where identifier == "PaymentView" {
            let svc = segue.destinationViewController as! StripePaymentViewController
            svc.item = item
            
        }
        
    }
    
    // MARK: - AlertView Delegate
    
    public func alertView(View: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - TextView Delegate
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        if(textView.text == "Enter Comments"){
            textView.text = ""
        }
        return true
    }
    
    
    public func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        problemComments.alpha = 1
        if textView == problemComments && textView.text == "Enter Comments" {
            textView.text = ""
        }
        return true
        
    }

    @IBAction func SelectPaymentClicked(sender: AnyObject) {
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "", preferredStyle: .ActionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Cash", style: .Default)
        { action -> Void in
            print("Cash")
        self.selectPaymentBtn.titleLabel!.text = "$\(self.totalCharges.text as String!) paid"
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Credit Card", style: .Default)
        { action -> Void in
            print("card")
            self.performSegueWithIdentifier("PaymentView", sender: nil)
            
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.presentViewController(actionSheetControllerIOS8, animated: true, completion: nil)
        
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
