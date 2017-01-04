//
//  UserDetails+CoreDataProperties.swift
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

extension UserDetails {

    @NSManaged var addressline1: String?
    @NSManaged var addressline2: String?
    @NSManaged var city: String?
    @NSManaged var email: String?
    @NSManaged var password: String?
    @NSManaged var phone: String?
    @NSManaged var username: String?
    @NSManaged var userrole: String?
    @NSManaged var zipcode: String?
    @NSManaged var devicetoken: String?


}
