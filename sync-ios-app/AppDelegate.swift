/*
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
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
import CoreData
import MBProgressHUD
import Stripe

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {
    var syncClient: FHSyncClient!
    var dataManager: DataManager!
    public var window: UIWindow?
    
    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Stripe.setDefaultPublishableKey("pk_test_Tjpop2EamdecTbkrc3cnqtLl")

        let navController = self.window?.rootViewController as? UINavigationController
        navController?.navigationBar.barTintColor = UIColor.init(red: 18/255 , green: 158/255, blue: 60/255, alpha: 1)
        navController?.navigationBar.tintColor = UIColor.whiteColor()
        
        navController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "KlavikaRegular-Plain", size: 20)!]
        
        
        FH.pushEnabledForRemoteNotification(application)
        FH.sendMetricsWhenAppLaunched(launchOptions)
        
        if launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] != nil {
            if launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey]?.isKindOfClass(NSDictionary) != nil {
                print("Was opened with notification:\(launchOptions![UIApplicationLaunchOptionsRemoteNotificationKey])")
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(self.pushMessageContent((launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey])! as! [NSObject : AnyObject]), forKey: "message_received")
                defaults.synchronize()
            }
        }
        syncClient = FHSyncClient.getInstance()
        dataManager = DataManager()
        dataManager.syncClient = syncClient
        dataManager.managedObjectContext = managedObjectContext
        
        //        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.window!, animated: true)
        //        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        //        loadingNotification.label.text = "Loading"
        
        
                let loginViewController = navController?.topViewController as? LoginViewController
                loginViewController?.dataManager = self.dataManager
        print("didFinishLaunchingWithOptions")

        FH.init {(resp: Response, error: NSError?) -> Void in
            if let error = error {
                print("FH init failed. Error = \(error)")
                if FH.isOnline == false {
                    print("Make sure you're online.")
                    let loginViewController = navController?.topViewController as? LoginViewController
                    loginViewController?.dataManager = self.dataManager
                    print("Please fill in fhconfig.plist file.")
                    print("initialized OK:: Starting SyncClient", resp)
                    
                } else {
                    
                }
                return
            }
//            let loginViewController = navController?.topViewController as? LoginViewController
//            loginViewController?.dataManager = self.dataManager
            print("Please fill in fhconfig.plist file.")
            print("initialized OK:: Starting SyncClient", resp)
            
            
            
        }
        return true
    }
    
    
    
    public func startSyncClient(userName: String){
        dataManager.start(userName)
    }
    
    
    
    public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("RHMAP push registration successful deviceToken \(deviceToken)");
        NSUserDefaults.standardUserDefaults().setObject(deviceToken, forKey: "DeviceToken")
        NSUserDefaults.standardUserDefaults().synchronize()
        //                                        FH.setPushAlias("Vidhya",  success:{ res in
        //                                            print("alias Push registration successful")
        //                                            }, error: {failed in
        //                                                print("alias Push registration Error \(failed.error)")
        //                                        })
        
            //let conf = PushConfig()
        
       
            FH.pushRegister(deviceToken, success: { res in
            let notification = NSNotification(name: "success_registered", object: nil)
            NSNotificationCenter.defaultCenter().postNotification(notification)
            
            
            print("Unified Push registration successful")
            }, error: {failed in
                let notification = NSNotification(name: "error_register", object: nil)
                NSNotificationCenter.defaultCenter().postNotification(notification)
                print("Unified Push registration Error \(failed.error)")
        })
    }
    
    public func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        let notification:NSNotification = NSNotification(name:"error_register", object:nil, userInfo:nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
        print("Unified Push registration Error \(error)")
    }
    
    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject]) {
        // When a message is received, send NSNotification, would be handled by registered ViewController
        let notification:NSNotification = NSNotification(name:"message_received", object:nil, userInfo:userInfo)
        NSNotificationCenter.defaultCenter().postNotification(notification)
        print("UPS message received: \(userInfo)")
        
        // Send metrics when app is launched due to push notification
        FH.sendMetricsWhenAppAwoken(application.applicationState, userInfo: userInfo)
    }
    
    public func pushMessageContent(userInfo: [NSObject : AnyObject]) -> String {
        var content: String
        if let alert = userInfo["aps"]!["alert"]! as? String {
            content = alert
        }
        else {
            content = (userInfo["aps"]!["alert"] as! Dictionary)["body"]!
        }
        return content
    }
    
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "org.feedhenry.sync-ios-app" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("ShoppingItem", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("ShoppingItem.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

