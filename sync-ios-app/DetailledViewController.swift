/*
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
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

public class DetailledViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIAlertViewDelegate {
    //    var item: ShoppingItem!
    //    var action: String!
    var datePickerView  : UIDatePicker!
    public var dataManager: DataManager!
    public var item: ShoppingItem!
    public var action: NSString = ""
    var typePickerView: UIPickerView = UIPickerView()
    var pickerData: [String] = [String]()
    var userDetails : UserDetails! = nil
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var serialNo: UITextField!
    @IBOutlet weak var manufName: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productComments: UITextView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var priorityField: UITextField!
    public override func viewDidLoad() {
        
        self.productView.layer.borderWidth = 1
        self.productView.layer.borderColor = UIColor.blackColor().CGColor
        
        
        self.navigationItem.title = "Create New Ticket"
        
        
        if let item = item {
            productComments.alpha = 1
            
            self.navigationItem.title = "Ticket Details"
            
            self.nameTextField.text = item.productname
            self.serialNo.text = item.serialno
            self.manufName.text = item.manufname
            self.productComments.text = item.productcomments
            self.dateField.text = item.dateofpurchase
            self.priorityField.text = item.priority
            
            
            
        }else{
            productComments.alpha = 0.5
            
        }
        
        let userNameStr : String = NSUserDefaults.standardUserDefaults().valueForKey("UserName") as! String!
        userDetails = self.dataManager.findItemByUserName(userNameStr)
        print("userDetails\(userDetails)")
        
        pickerData = ["Urgent", "Normal", "Low"]
        
        priorityField.tintColor = UIColor.clearColor()
        dateField.tintColor = UIColor.clearColor()
        
        
        
    }
    
    func donePicker(sender:UIButton){
        priorityField.resignFirstResponder()
        
    }
    
    override public func viewDidLayoutSubviews(){
        
        self.scrollView.layer.contents = UIImage(named: "Background-1.png")?.CGImage
        self.containerView.layer.contents = UIImage(named: "Background-1.png")?.CGImage
        
        self.containerView.frame = CGRectMake(0, 0,self.view.frame.width, self.priorityField.frame.origin.y + self.priorityField.frame.height + 50)
        self.bgImageView.frame = CGRectMake(0, 0,self.view.frame.width, self.priorityField.frame.origin.y + self.priorityField.frame.height + 50)
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.width, self.priorityField.frame.origin.y+self.priorityField.frame.height+50)
        
        
    }
    
    @IBAction func saveItem(sender: AnyObject) {
        if let name = self.nameTextField.text where name != "" {
            let userNameStr : String = NSUserDefaults.standardUserDefaults().valueForKey("UserName") as! String!
            
            userDetails = self.dataManager.findItemByUserName(userNameStr)
            
            print("userDetails\(userDetails)")
            
            
            if let item = item {
                let userNameStr : String = NSUserDefaults.standardUserDefaults().valueForKey("UserName") as! String!
                item.username = userNameStr
                item.productname = name
                item.serialno = self.serialNo.text
                item.manufname = self.manufName.text
                item.dateofpurchase = self.dateField.text
                item.productcomments = self.productComments.text
                item.partname = ""
                item.priority = self.priorityField.text
                
                item.replacementreqd = "No"
                item.severitylevel = "Low"
                
                item.costofreplacement = ""
                item.problemcomments = ""
                item.servicecharges = ""
                item.totalcharges = ""
                //                item.digitalsign = ""
                item.createddate = String(format:"%@", NSDate())
                item.closuredate = String(format:"%@", NSDate())
                item.status = "open"
                
                item.created = NSDate()
                item.guid = self.item.guid
                item.ticketid = self.item.ticketid
                item.addressline1 = userDetails.addressline1
                item.addressline2 = userDetails.addressline2
                item.phone = userDetails.phone
                item.email = userDetails.email
                item.zipcode = userDetails.zipcode
                item.city = userDetails.addressline1
                if(self.item.technician != "" && self.item.dateassigned != ""){
                    item.technician = self.item.technician
                    item.dateassigned = self.item.dateassigned
                }else{
                    item.technician = ""
                    item.dateassigned = ""
                }
                
                
                dataManager.updateItem(item)
                
                let showAlert : UIAlertView = UIAlertView.init(title: "", message: "Ticket Updated succesfully", delegate: self, cancelButtonTitle:nil, otherButtonTitles:"OK")
                showAlert.tag = 10
                showAlert.show()
                print("HIT CREATE > UPDATE BUTTON:: \(item)")
            } else {
                item = dataManager.getItem()
                let userNameStr : String = NSUserDefaults.standardUserDefaults().valueForKey("UserName") as! String!
                item.username = userNameStr
                item.productname = name
                item.serialno = self.serialNo.text
                item.manufname = self.manufName.text
                item.dateofpurchase = self.dateField.text // String(format:"%@", NSDate())
                item.productcomments = self.productComments.text
                item.priority = self.priorityField.text
                
                item.partname = ""
                item.replacementreqd = "No"
                item.severitylevel = "Low"
                let randomID = arc4random() % 9000 + 1000
                item.ticketid = String(format:"%d", randomID)
                item.costofreplacement = ""
                item.problemcomments = ""
                item.servicecharges = ""
                item.totalcharges = ""
                item.createddate = String(format:"%@", NSDate())
                item.closuredate = ""
                item.technician = ""
                item.dateassigned = ""
                //                item.digitalsign = ""
                
                item.status = "open"
                item.created = NSDate()
                print("HIT CREATE > SAVE BUTTON:: \(item)")
                item.addressline1 = userDetails.addressline1
                item.addressline2 = userDetails.addressline2
                item.phone = userDetails.phone
                item.email = userDetails.email
                item.zipcode = userDetails.zipcode
                item.city = userDetails.addressline1
                
                dataManager.createItem(item)
                
                let showAlert : UIAlertView = UIAlertView.init(title: "", message: "Ticket Created succesfully", delegate: self, cancelButtonTitle:nil, otherButtonTitles:"OK")
                showAlert.tag = 10
                showAlert.show()
                
            }
        } else {
            displayError("Name is required")
        }
   
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        if let parent = self.parentViewController as? UINavigationController {
            parent.popViewControllerAnimated(true)
        }
    }
    
    
    @IBAction func AssignTicketClicked(sender: AnyObject) {
        
        
    }
    
    @IBAction func PrioritySelected(sender: UITextField) {
        typePickerView = UIPickerView(frame: CGRectMake(0, 200, view.frame.width, 200))
        typePickerView.backgroundColor = .whiteColor()
        
        typePickerView.showsSelectionIndicator = true
        typePickerView.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailledViewController.donePicker(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        //        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailledViewController.donePicker(_:)))
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        priorityField.inputView = typePickerView
        priorityField.inputAccessoryView = toolBar
        priorityField.text = pickerData[typePickerView.selectedRowInComponent(0)]
        
    }
    
    @IBAction func DateTextFieldSelected(sender: UITextField) {
        //Create the view
        let inputView = UIView(frame: CGRectMake(0, 200, view.frame.width, 200))
        
        datePickerView  = UIDatePicker(frame: CGRectMake((self.view.frame.width/2) - (view.frame.width/2), 0, view.frame.width, 160))
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        inputView.addSubview(datePickerView) // add date picker to UIView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailledViewController.doneButton(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        //        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailledViewController.donePicker(_:)))
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        //        doneButton.addTarget(self, action: #selector(DetailledViewController.doneButton(_:)), forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        
        sender.inputView = inputView
        sender.inputAccessoryView = toolBar
        
        datePickerView.addTarget(self, action: #selector(DetailledViewController.handleDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        handleDatePicker(datePickerView) // Set the date on start.
    }
    
    @IBAction func SelectDateClicked(sender: AnyObject) {
        
        
    }
    
    // MARK: - TextView Delegate
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        if textView == productComments && textView.text == "Enter Comments" {
            textView.text = ""
        }

        return true
    }
    
    
    public func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        productComments.alpha = 1
        self.view.frame = CGRectMake(0, -100, self.view.frame.width, self.view.frame.height)
        
        if textView == productComments && textView.text == "Enter Comments" {
            textView.text = ""
        }
        return true
        
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        self.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        
    }
    
    
    @IBAction func SelectPriorityClicked(sender: AnyObject) {
        
        self.typePickerView.hidden = false
        
        
    }
    
    // MARK: - Pickerview Delegate
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        priorityField.text = pickerData[row]
        
    }
    
    
    func handleDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        self.dateField.text = dateFormatter.stringFromDate(sender.date)
        //        .text = dateFormatter.stringFromDate(sender.date)
    }
    
    func doneButton(sender:UIButton)
    {
        dateField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func displayError(error: String) {
        let alert = UIAlertController(title: error, message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - TextField Delegate
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        if(textField == priorityField || textField == dateField){
            return false
        }
        return true
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool{
                self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    // MARK: - AlertView Delegate
    
    public func alertView(View: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        if View.tag == 10 {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
  
    
    //
    //    public func textFieldDidBeginEditing(textField: UITextField){
    //        let originInSuperview  = self.view.convertPoint(textField.frame.origin, toView: self.scrollView)
    //        if(originInSuperview.y > 150){
    //            self.view.frame = CGRectMake(0, -(originInSuperview.y - 150), self.view.frame.size.width, self.view.frame.size.height)
    //            
    //        }
    //        print("originInSuperview\(originInSuperview)")
    //    }
    //
    //    public func textFieldDidEndEditing(textField: UITextField){
    //        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
    //    }
    
    
    
}