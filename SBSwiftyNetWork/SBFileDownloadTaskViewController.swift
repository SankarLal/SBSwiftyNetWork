

import UIKit

class SBFileDownloadTaskViewController: UIViewController {
    
    let HEADER_COLOR : UIColor = UIColor (red: 56.0/255, green: 185.0/255, blue: 158.0/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "SBFILE DOWNLOAD";
        self.view.backgroundColor = UIColor.whiteColor()
        
        setUpUserInterface()
    }
    
    func setUpUserInterface () {
        
        let size : CGSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        
        var yValue : CGFloat = size.height - 150
        yValue = yValue / 5
        
        var xValue : CGFloat = size.width - 200
        xValue = xValue / 2
        
        let imageDownloadButton : UIButton = UIButton (type: UIButtonType.Custom)
        imageDownloadButton.frame = CGRectMake(xValue, yValue, 200, 50)
        imageDownloadButton.backgroundColor = HEADER_COLOR
        imageDownloadButton.setTitle("DOWNLOAD IMAGES", forState: UIControlState.Normal)
        imageDownloadButton.addTarget(self, action: "performImageButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(imageDownloadButton)
        
        let videoDownloadButton : UIButton = UIButton (type: UIButtonType.Custom)
        videoDownloadButton.frame = CGRectMake(xValue, imageDownloadButton.frame.origin.y + imageDownloadButton.frame.size.height + yValue, 200, 50)
        videoDownloadButton.backgroundColor = HEADER_COLOR
        videoDownloadButton.setTitle("DOWNLOAD VIDEO", forState: UIControlState.Normal)
        videoDownloadButton.addTarget(self, action: "performVideoButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(videoDownloadButton)
        
        let audioDownloadButton : UIButton = UIButton (type: UIButtonType.Custom)
        audioDownloadButton.frame = CGRectMake(xValue, videoDownloadButton.frame.origin.y + videoDownloadButton.frame.size.height + yValue, 200, 50)
        audioDownloadButton.backgroundColor = HEADER_COLOR
        audioDownloadButton.setTitle("DOWNLOAD AUDIO", forState: UIControlState.Normal)
        audioDownloadButton.addTarget(self, action: "performAudioButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(audioDownloadButton)
        
        let pdfDownloadButton : UIButton = UIButton (type: UIButtonType.Custom)
        pdfDownloadButton.frame = CGRectMake(xValue, audioDownloadButton.frame.origin.y + audioDownloadButton.frame.size.height + yValue, 200, 50)
        pdfDownloadButton.backgroundColor = HEADER_COLOR
        pdfDownloadButton.setTitle("DOWNLOAD PDF", forState: UIControlState.Normal)
        pdfDownloadButton.addTarget(self, action: "performPDFButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(pdfDownloadButton)
        
        
    }
    
    func performImageButton () {
        
        self.navigationController?.pushViewController(SBImageDownloadTaskViewController (), animated: true)
        
    }
    
    func performVideoButton () {
        
        self.navigationController?.pushViewController(SBVideoDownloadTaskViewController (), animated: true)
        
    }
    
    func performAudioButton () {
        
        self.navigationController?.pushViewController(SBAudioDownloadTaskViewController (), animated: true)
        
    }
    
    func performPDFButton () {
        
        self.navigationController?.pushViewController(SBPDFDownloadTaskViewController (), animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
