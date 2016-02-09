SBSwiftyNetWorking
================
This is simple Web service call using NSURLSession for iOS which is developed in Swift.

For Objective C click [here][sbnetwork-url]

### Benefits:

1. SBSwiftyNetWorking framework will hepls us to write minimal code and faster implementation of web service into our application.
2. Using this framework we can perform GET, DELETE, POST, PUT methods using NSURLSession along with Cache or without Cache.
3. Async Image Download with Cache and without Cache the response using NSURLSessionDataTask.
4. Async Images, Videos, Audios and PDF's Download with Cache and without Cache the response using NSURLSessionDownloadTask.
5. Downloads are keep on running in Background state, Supended state, Terminated state and Not Running state.
6. This framework makes it easy to quickly download one or several large file(s).
7. Supports Pause / Resume and Cancel the downloads.
8. Progression/Completion Blocks.

  - [X] If an iOS app is terminated by the system and relaunched, the app can use the same identifier to create a new configuration object and session and retrieve the status of transfers that were in progress at the time of termination. This behavior applies only for normal termination of the app by the system. If the user terminates the app from the multitasking screen, the system cancels all of the session’s background transfers. In addition, the system does not automatically relaunch apps that were force quit by the user. The user must explicitly relaunch the app before transfers can begin again.

## Demo
## Installation
1. Drag the Framework `SBSwiftyNetWorking.framework` to your project folder.
2. Add the Framework on `Project -> Targets -> General -> Embedded Binaries -> Press + Symbole -> Add SBSwiftyNetWorking.framework`
3. Make an import statement for the file as `import SBSwiftyNetWorking`
4. To run in Simulator add the Framework under the given Folder Path `SBSwiftyNetWork -> Framework -> Simulator`, For Device and Distributing to App Store use `SBSwiftyNetWork -> Framework -> Device`.

<img src="https://raw.githubusercontent.com/sankarlal/sbSwiftyNetWork/master/Screen%20Shots/Screen1.png" alt="SBSwiftyNetWorking Screenshot" />
<img src="https://raw.githubusercontent.com/sankarlal/sbSwiftyNetWork/master/Screen%20Shots/Screen2.png" alt="SBSwiftyNetWorking Screenshot" />
<img src="https://raw.githubusercontent.com/sankarlal/sbSwiftyNetWork/master/Screen%20Shots/Screen3.png" alt="SBSwiftyNetWorking Screenshot" />

## Configuration
Add to your AppDelegate class given below configuration.

```objective-c
   
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


// ********  SBNetwork Availbility ******** //
    func SBNetworkAvailbility (object : NSNotification) {
        
        let dictionary : NSDictionary = object.userInfo!
        let isSBNetworkAvailablity : Bool = (dictionary.valueForKey("isSBNetworkAvailable")?.boolValue)!
        NSLog("isSBNetworkAvailablity %d %@",isSBNetworkAvailablity, isSBNetworkAvailablity)
    }


// ********  Background Download Process ******** //
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


```
## Initialization with callback Using Blocks
### JSON RESPONSE
```objective-c
If you want to add headers, user below method before calling the services.
   

        SBManager.sharedInstance.setHeaders(["Key": "Value"])

    // ******** Each and every time, it will fetch to server ******** //

        SBManager.sharedInstance.performDataTaskWithExecuteGetURL(urlString,
            success: { (dictionary) -> Void in
                
                print(dictionary)
                
            }) { (error) -> Void in
                
                print(error?.localizedDescription)
                
            }
            
         //   ******** After five minutes only (Based on "configCacheTimeInMinutes:5" Or "defaultCacheTimeConfig") next call will go to server. Eventhough Network available or Not available ******** //
                
                SBManager.sharedInstance.performDataTaskWithCacheAndExecuteGetURL(urlString,
                    success: { (dictionary) -> Void in
                        
                        print(dictionary)
                        
                    }) { (error) -> Void in
                        
                        print(error?.localizedDescription)
                        
        }
        
        // ******** After ten minutes (Based on "cacheExpireTimeInMinutes" value) only next call will go to server. Eventhough Network available or Not available ******** \\
        
        SBManager.sharedInstance.performDataTaskWithCacheAndExecuteGetURL(urlString,
            cacheExpireTimeInMinutes: 10,
            success: { (dictionary) -> Void in
                
                self.updateResponseData(dictionary)
                
            }) { (error) -> Void in
                self.showErrorMessage((error?.localizedDescription)!)
                
        }

```
### DOWNLOAD IMAGES - DATA TASK
```objective-c
        // ******** Data Task Request For Image Download, Without Cache ******** //
        
        SBManager.sharedInstance.performDataTaskWithDownlaodImageURL(imageArray [indexPath.section],
            imageSuccess: { (image) -> Void in
                
            }) { (error) -> Void in
                
                
        }
        
        // ******** Data Task Request For Image Download, With Cache - Default System Cache Time ******** //
        SBManager.sharedInstance.performDataTaskWithCacheAndDownlaodImageURL(imageArray [indexPath.section],
            imageSuccess: { (image) -> Void in
                
            }) { (error) -> Void in
                
                
        }
        
        // ******** Data Task Request For Image Download, With Cache - Image Cache Time will be different for Each Request ******** //
        SBManager.sharedInstance.performDataTaskWithCacheAndDownlaodImageURL(imageArray [indexPath.section],
            cacheExpireTimeInMinutes:10,
            imageSuccess: { (image) -> Void in
                
                imageView.image = image
                (imageView.viewWithTag(self.INDICATOR_TAG) as! UIActivityIndicatorView).stopAnimating()
                
            }) { (error) -> Void in
                
                
        }



```
### DOWNLOAD IMAGES, VIDEOS, AUDIOS AND PDF'S - DOWNLOAD TASK
```objective-c
   
        // Download Task Request For Files Download, Without Cache
        SBManager.sharedInstance.performDownloadTaskWithDownlaodFileURL(fileArray! [indexPath.section] as! NSString,
            downloadTaskData: { (data) -> Void in
                
            }, failure: { (error) -> Void in
                
            }) { (progressValue) -> Void in
                
        }
        
        // Download Task Request For Files Download, With Cache - Default System Cache Time
        SBManager.sharedInstance.performDownloadTaskWithCacheAndDownlaodFileURL(fileArray! [indexPath.section] as! NSString,
            downloadTaskData: { (data) -> Void in
                
            }, failure: { (error) -> Void in
                
            }) { (progressValue) -> Void in
                
        }
        
        // Download Task Request For Files Download, With Cache - File Cache Time will be different for Each Request
        SBManager.sharedInstance.performDownloadTaskWithCacheAndDownlaodFileURL(fileArray! [indexPath.section] as! NSString,
            cacheExpireTimeInMinutes: 10,
            downloadTaskData: { (data) -> Void in
                
            }, failure: { (error) -> Void in
                
            }) { (progressValue) -> Void in
            
        }
        
 

```
[sbnetwork-url]: https://github.com/SankarLal/SBNetWork/

## Contact
sankarlal20@gmail.com

## License

SBSwiftyNetWorking is available under the MIT license.

Copyright © 2016 SBSwiftyNetWorking

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

