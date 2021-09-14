import UIKit
import UserNotifications

import Segment
import CleverTapSDK
import Segment_CleverTap

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // NOTE:  if you are using CleverTap for push notifications with deep links, to have a launch deep link automatically called
        // please add your CleverTap account id and token to your plist
        // as described here:  https://support.clevertap.com/docs/ios/getting-started.html#add-clevertap-credentials
        
        Analytics.debug(true)
        CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue+1)
        
        let config = AnalyticsConfiguration(writeKey: "qp2acCBE3Ph9v4EhOPpXeJtUXa2xepQz")
        config.use(SEGCleverTapIntegrationFactory())
        Analytics.setup(with: config)
        
        // push notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) {
            (granted, error) in
            if (granted) {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Analytics.shared().registeredForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("APPDELEGATE: open url \(url)")
        DispatchQueue.main.async {
            self.showAlert(message: "APPDELEGATE: open url \(url)")
        }
        return true
    }
    
    func open(_ url: URL, options: [String : Any] = [:],
              completionHandler completion: ((Bool) -> Swift.Void)? = nil){
        print("APPDELEGATE: open url \(url) with completionHandler")
        DispatchQueue.main.async {
            self.showAlert(message: "APPDELEGATE: open url \(url) with completionHandler")
        }
        completion?(false)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("did receive remote notification \(userInfo)")
        
        Analytics.shared().receivedRemoteNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("did receive remote notification completionHandler \(userInfo)")
        Analytics.shared().receivedRemoteNotification(userInfo)
    }
    
    func showAlert(message:String) {
        let alertController = UIAlertController(title: "Deeplink", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

