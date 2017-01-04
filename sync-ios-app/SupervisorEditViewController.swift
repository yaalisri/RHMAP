//
//  SupervisorEditViewController.swift
//  sync-ios-app
//
//  Created by Vidhya Sri on 11/17/16.
//  Copyright © 2016 FeedHenry. All rights reserved.
//

import UIKit
import FeedHenry
import MBProgressHUD

public class SupervisorEditViewController: UIViewController, UIPickerViewDelegate, UIAlertViewDelegate {

    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var addressText: UITextView!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var bgImageView: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var assignTicketBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var manufName: UITextField!
    @IBOutlet weak var serialNo: UITextField!
    @IBOutlet weak var priorityField: UITextField!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var productComments: UITextView!
    @IBOutlet weak var technicianField: UITextField!
    @IBOutlet weak var assignDateField: UITextField!
    @IBOutlet weak var customerView: UIView!
    public var dataManager: DataManager!
    public var item: ShoppingItem!
    var typePickerView: UIPickerView = UIPickerView()
    var pickerData: [String] = [String]()
    var technicianObjectArray = [AnyObject]()
    var technicianDict : NSDictionary = [:]

    var datePickerView  : UIDatePicker!

    override public func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        self.productView.layer.borderWidth = 1
        self.productView.layer.borderColor = UIColor.blackColor().CGColor
        
        self.customerView.layer.borderWidth = 1
        self.customerView.layer.borderColor = UIColor.blackColor().CGColor
        
        if let item = item {
            productComments.alpha = 1
            
            self.navigationItem.title = "Ticket Details"
            self.customerName.text = item.username
            self.addressText.text = item.addressline1! + "\n" + item.addressline2!
            self.cityField.text = item.city
            self.zipCodeField.text = item.zipcode
            self.phoneNo.text = item.phone
            self.emailField.text = item.email

            self.nameTextField.text = item.productname
            self.serialNo.text = item.serialno
            self.manufName.text = item.manufname
            self.productComments.text = item.productcomments
            self.dateField.text = item.dateofpurchase
            self.priorityField.text = item.priority
            
            assignDateField.text = item.dateassigned
         
        }else{
            productComments.alpha = 0.5
            
        }
//        self.assignTicketBtn.hidden = true
        
      
        
        priorityField.tintColor = UIColor.clearColor()
        assignDateField.tintColor = UIColor.clearColor()
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.label.text = "Loading"
        FH.cloud("/technician",
                 args: nil,
                 completionHandler: {(resp: Response, error: NSError?) -> Void in
                    if let error = error {
                        print("Cloud Call Failed, \(error)")
                        return
                    }
                    self.technicianDict  = resp.parsedResponse as NSDictionary!
                    var technicianObj  = []
                    technicianObj = self.technicianDict.valueForKey("msg") as! NSArray!
                    for i in 0...technicianObj.count - 1 {
                        self.pickerData.append(technicianObj[i].valueForKey("techname") as! String)
                        self.technicianObjectArray.append(technicianObj[i])
                        if(self.item.technician != ""){
                        if(technicianObj[i].valueForKey("username") as? String == self.item.technician){
                                self.technicianField.text = self.item.technician
                            }
                        }
                        
                    }
                    
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

                    
                    print("pickerData ---- \(self.pickerData)\(self.technicianObjectArray)")
                 
        })
        
        technicianField.textAlignment = NSTextAlignment.Right

        technicianField.tintColor = UIColor.clearColor()
        dateField.tintColor = UIColor.clearColor()

        // Do any additional setup after loading the view.
    }
    
    override public func viewDidLayoutSubviews(){
        
        self.scrollView.layer.contents = UIImage(named: "Background-1.png")?.CGImage
        self.containerView.layer.contents = UIImage(named: "Background-1.png")?.CGImage
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.width, self.assignTicketBtn.frame.origin.y+self.assignTicketBtn.frame.height+50)
         self.containerView.frame = CGRectMake(0, 0,self.view.frame.width, 2000)

    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AssignTicketClicked(sender: AnyObject) {
        if(technicianField.text == "" || assignDateField.text == "" || technicianField.text == nil || assignDateField.text == nil){
            
            let showAlert : UIAlertView = UIAlertView.init(title: "", message: "Please select Technician and date", delegate: nil, cancelButtonTitle:nil, otherButtonTitles:"OK")
            showAlert.show()
            
        }else{
            
            if let itemObj = item {
                itemObj.ticketid = item.ticketid
                var index = 0
                for i in 0...self.pickerData.count - 1 {
                    if(self.pickerData[i] == self.technicianField.text){
                        index = i
                    }
                }
                
                var technicianObj  = []
                technicianObj = self.technicianDict.valueForKey("msg") as! NSArray!
                
                itemObj.technician = technicianObj[index].valueForKey("username") as? String
                itemObj.dateassigned = assignDateField.text
                itemObj.status = "assigned"
                itemObj.addressline1 = item.addressline1
                itemObj.addressline2 = item.addressline2
                itemObj.city = item.city
                itemObj.closuredate = item.closuredate
                itemObj.costofreplacement = item.costofreplacement
//                itemObj.created = String(format:"%@", NSDate())
                itemObj.createddate = item.createddate
                itemObj.dateofpurchase = item.dateofpurchase
                itemObj.email = item.email
                itemObj.guid = item.guid
                itemObj.manufname = item.manufname
                itemObj.partname = item.partname
                itemObj.phone = item.phone
                itemObj.priority = item.priority
                itemObj.problemcomments = item.problemcomments
                itemObj.productcomments = item.productcomments
                itemObj.productname = item.productname
                itemObj.replacementreqd = item.replacementreqd
                itemObj.serialno = item.serialno
                itemObj.servicecharges = item.servicecharges
                itemObj.severitylevel = item.severitylevel
                itemObj.totalcharges = item.totalcharges
                itemObj.username = item.username
                itemObj.zipcode = item.zipcode
//                itemObj.digitalsign = ""

                dataManager.updateItem(itemObj)
                let showAlert : UIAlertView = UIAlertView.init(title: "", message: "Ticket Assigned succesfully", delegate: self, cancelButtonTitle:nil, otherButtonTitles:"OK")
                showAlert.tag = 10
                showAlert.show()

                print("HIT CREATE > UPDATE BUTTON:: \(item)")
            }

        }
   
    }

    @IBAction func SelectDateClicked(sender: UITextField) {
        
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
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SupervisorEditViewController.doneButton(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        assignDateField.textAlignment = NSTextAlignment.Right

        
        sender.inputView = inputView
        sender.inputAccessoryView = toolBar
        
        datePickerView.addTarget(self, action: #selector(SupervisorEditViewController.handleDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        handleDatePicker(datePickerView) // Set the date on start.
        
    }
    @IBAction func SelectTechnicianClicked(sender: UITextField) {
        self.typePickerView = UIPickerView(frame: CGRectMake(0, 200, self.view.frame.width, 200))
        self.typePickerView.backgroundColor = .whiteColor()
        
        self.typePickerView.showsSelectionIndicator = true
        self.typePickerView.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SupervisorEditViewController.donePicker(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)

        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        technicianField.textAlignment = NSTextAlignment.Right

        self.technicianField.inputView = self.typePickerView
        self.technicianField.inputAccessoryView = toolBar
        if(self.technicianField.text == ""){
            self.technicianField.text = self.pickerData[0]
        }else{
            var index = 0
            for i in 0...self.pickerData.count - 1 {
                if(self.pickerData[i] == self.technicianField.text){
                    index = i
                }
            }
            self.typePickerView.selectRow(index, inComponent: 0, animated: true)
        }
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
        technicianField.text = pickerData[row]
        
    }
    
    
    func handleDatePicker(sender: UIDatePicker) {
        assignDateField.textAlignment = NSTextAlignment.Right
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        self.assignDateField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func donePicker(sender:UIButton)
    {
        technicianField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func doneButton(sender:UIButton)
    {
        assignDateField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    // MARK: - TextField Delegate
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        if(textField == technicianField || textField == assignDateField){
            return false
        }
        return true
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - AlertView Delegate
    
    public func alertView(View: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        if View.tag == 10 {
                self.navigationController?.popViewControllerAnimated(true)
        }
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
