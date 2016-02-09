
import UIKit
import SBSwiftyNetWorking

@UIApplicationMain

class SBAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var backgroundTransferCompletionHandler: (() -> Void)?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow (frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        
        // Configure The URL Cache -  MemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024
        SBManager.sharedInstance.defaultURLCacheConfig()
        //        SBManager.sharedInstance.configURLCacheInMemoryCapacity(10*1024*1024, dCapacity: 20*1024*1024)
        
        // Configure The Cache Time - 5 Minutes
        SBManager.sharedInstance.defaultCacheTimeConfig()
        //        SBManager.sharedInstance.configCacheTimeInMinutes(5)
        
        
        // Update NetWork Failure Message
        SBManager.sharedInstance.updateNetWorkFailureMessage("Internet connection appears offline.")
        
        // SB Reachability Notification
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "SBNetworkAvailbility:",
            name: "SB_NETWORK_REACHABILITY",
            object: nil)
        
        // Background Download Process
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "URLSessionDidFinishEventsForBackgroundURLSession:",
            name: "SB_BACKGROUND_URLSESSION",
            object: nil)
        
        //need to enable background fetch
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        // Register Notification
        if UIApplication.instancesRespondToSelector("registerUserNotificationSettings:") {
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Sound, .Alert,.Badge], categories: nil))
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
        
        // Root View Controller
        let rootNavigationController : UINavigationController = UINavigationController(rootViewController: SBHomeViewController ())
        self.window?.rootViewController = rootNavigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: SBNetwork Availbility
    func SBNetworkAvailbility (object : NSNotification) {
        
        let dictionary : NSDictionary = object.userInfo!
        let isSBNetworkAvailablity : Bool = (dictionary.valueForKey("isSBNetworkAvailable")?.boolValue)!
        NSLog("isSBNetworkAvailablity %d %@",isSBNetworkAvailablity, isSBNetworkAvailablity)
    }
    
    // MARK: Background Download Process
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        
        self.backgroundTransferCompletionHandler = completionHandler
        
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession (object: NSNotification) {
        
        let dictionary : NSDictionary = object.userInfo!
        
        let session : NSURLSession = dictionary.valueForKey("sbURLSession") as! NSURLSession
        
        session.getTasksWithCompletionHandler{ dataTasks, uploadTasks, downloadTasks in
            
            if downloadTasks.count == 0 {
                let completionHandler: (() -> Void)? = self.backgroundTransferCompletionHandler
                self.backgroundTransferCompletionHandler = nil;
                
                NSOperationQueue .mainQueue().addOperationWithBlock({ () -> Void in
                    completionHandler!();
                    self.presentNotification ()
                    
                })
            }
            else {
                for ( _ , elementValue) in downloadTasks.enumerate() {
                    let task : NSURLSessionDownloadTask = elementValue
                    task.resume()
                }
            }
        }
        
    }
    
    func presentNotification () {
        
        let localNotification : UILocalNotification = UILocalNotification ()
        localNotification.fireDate = NSDate (timeIntervalSinceNow: 0)
        localNotification.alertBody = ""
        localNotification.alertAction = ""
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}
