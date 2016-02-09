

import UIKit

class SBHomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "SB SWIFTY NETWORKING"
        self.view.backgroundColor = UIColor.whiteColor()
        
        setUpUserInterface()
    }
    
    func setUpUserInterface () {
        
        let size : CGSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        
        var yValue : CGFloat = size.height - 100
        yValue = yValue / 4
        
        var xValue : CGFloat = size.width - 200
        xValue = xValue / 2
        
        let jsonButton : UIButton = UIButton (type: UIButtonType.Custom)
        jsonButton.frame = CGRectMake(xValue, yValue, 200, 50)
        jsonButton.backgroundColor = UIColor.purpleColor()
        jsonButton.setTitle("JSON RESPONSE", forState: UIControlState.Normal)
        jsonButton.addTarget(self, action: "performJsonButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(jsonButton)
        
        let imageDownloadButton : UIButton = UIButton (type: UIButtonType.Custom)
        imageDownloadButton.frame = CGRectMake(xValue, jsonButton.frame.origin.y + jsonButton.frame.size.height + yValue, 200, 50)
        imageDownloadButton.backgroundColor = UIColor.purpleColor()
        imageDownloadButton.setTitle("DOWNLOAD IMAGES", forState: UIControlState.Normal)
        imageDownloadButton.addTarget(self, action: "performImageDownloadButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(imageDownloadButton)
        
        let fileDownloadButton : UIButton = UIButton (type: UIButtonType.Custom)
        fileDownloadButton.frame = CGRectMake(xValue, imageDownloadButton.frame.origin.y + imageDownloadButton.frame.size.height + yValue, 200, 50)
        fileDownloadButton.backgroundColor = UIColor.purpleColor()
        fileDownloadButton.setTitle("DOWNLOAD FILES", forState: UIControlState.Normal)
        fileDownloadButton.addTarget(self, action: "performFileDownloadButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(fileDownloadButton)
        
        
    }
    
    
    func performJsonButton () {
        
        self.navigationController?.pushViewController(SBJsonViewController (), animated: true)
        
    }
    
    func performImageDownloadButton () {
        
        self.navigationController?.pushViewController(SBImageDownloadViewController (), animated: true)
        
    }
    
    func performFileDownloadButton () {
        
        self.navigationController?.pushViewController(SBFileDownloadTaskViewController (), animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
