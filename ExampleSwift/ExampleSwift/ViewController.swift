
import UIKit
import Analytics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func identifyButtonDidPress(_ sender: Any) {
        let floatAttribute = 12.3
        let intAttribute = 18
        let traits: [String: Any] = [
            "email": "supportsw@clevertap.com",
            "bool": true,
            "floatAttribute": floatAttribute,
            "intAttribute" : intAttribute,
            "name": "Segment CleverTap",
            "phone" : "0234567891",
            "gender": "female",
            ]
        
        SEGAnalytics.shared().identify("cleverTapSegementTestUseriOSsw", traits: traits)
    }
    
    @IBAction func trackButtonDidPress(_ sender: Any) {
        SEGAnalytics.shared().track("cleverTapSegmentTrackEvent", properties: ["eventProperty":"eventPropertyValue"])
    }
    
    @IBAction func aliasButtonDidPress(_ sender: Any) {
        SEGAnalytics.shared().alias("654321A")
    }
}

