import UIKit
import CleverTapSDK
import Analytics

class ViewController: UIViewController, CleverTapInboxViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerAppInbox()
        initializeAppInbox()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerAppInbox() {
        CleverTap.sharedInstance()?.registerInboxUpdatedBlock({
            let messageCount = CleverTap.sharedInstance()?.getInboxMessageCount()
            let unreadCount = CleverTap.sharedInstance()?.getInboxMessageUnreadCount()
            print("Inbox Message updated:\(String(describing: messageCount))/\(String(describing: unreadCount)) unread")
        })
    }
    
    func initializeAppInbox() {
        CleverTap.sharedInstance()?.initializeInbox(callback: ({ (success) in
            if (success) {
                let messageCount = CleverTap.sharedInstance()?.getInboxMessageCount()
                let unreadCount = CleverTap.sharedInstance()?.getInboxMessageUnreadCount()
                print("Inbox Message:\(String(describing: messageCount))/\(String(describing: unreadCount)) unread")
            }
        }))
    }
    
    @IBAction func screenButtonPressed(_ sender: Any) {
        Analytics.shared().screen("TestScreen")
    }
    
    @IBAction func identifyButtonDidPress(_ sender: Any) {
        let floatAttribute = 12.3
        let intAttribute = 18
        let traits: [String: Any] = [
            "email": "support@clevertap.com",
            "bool": true,
            "floatAttribute": floatAttribute,
            "intAttribute" : intAttribute,
            "name": "Segment CleverTap",
            "phone" : "0234567891",
            "gender": "female",
        ]
        
        Analytics.shared().identify("cleverTapSegementTestUseriOS", traits: traits)
    }
    
    @IBAction func trackButtonDidPress(_ sender: Any) {
        Analytics.shared().track("cleverTapSegmentTrackEvent", properties: ["eventProperty":"eventPropertyValue"])
    }
    
    @IBAction func aliasButtonDidPress(_ sender: Any) {
        Analytics.shared().alias("654321A")
    }
    
    @IBAction func showAppInbox() {
        // config the style of App Inbox Controller
        let style = CleverTapInboxStyleConfig.init()
        style.title = "App Inbox"
        if let inboxController = CleverTap.sharedInstance()?.newInboxViewController(with: style, andDelegate: self) {
            let navigationController = UINavigationController.init(rootViewController: inboxController)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    func messageDidSelect(_ message: CleverTapInboxMessage, at index: Int32, withButtonIndex buttonIndex: Int32) {
        // This method is called when an inbox message is clicked(tapped or call to action)
    }
}

