//
//  ShoppingItem+CoreDataProperties.swift
//  sync-ios-app
//
//  Created by Vidhya Sri on 11/23/16.
//  Copyright © 2016 FeedHenry. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ShoppingItem {

    @NSManaged var addressline1: String?
    @NSManaged var addressline2: String?
    @NSManaged var city: String?
    @NSManaged var closuredate: String?
    @NSManaged var costofreplacement: String?
    @NSManaged var created: NSDate?
    @NSManaged var createddate: String?
    @NSManaged var dateofpurchase: String?
    @NSManaged var email: String?
    @NSManaged var guid: String?
    @NSManaged var manufname: String?
    @NSManaged var partname: String?
    @NSManaged var phone: String?
    @NSManaged var priority: String?
    @NSManaged var problemcomments: String?
    @NSManaged var productcomments: String?
    @NSManaged var productname: String?
    @NSManaged var replacementreqd: String?
    @NSManaged var serialno: String?
    @NSManaged var servicecharges: String?
    @NSManaged var severitylevel: String?
    @NSManaged var status: String?
    @NSManaged var ticketid: String?
    @NSManaged var totalcharges: String?
    @NSManaged var uid: String?
    @NSManaged var username: String?
    @NSManaged var zipcode: String?
    @NSManaged var technician: String?
    @NSManaged var dateassigned: String?
    @NSManaged var digitalsign: String?

}
