

import UIKit

class SBVideoDownloadTaskViewController: UIViewController, SBDetailDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "SBVIDEO DOWNLOAD TASK";
        self.view.backgroundColor = UIColor.whiteColor()
        
        let sbTblView : SBTableView = SBTableView (frame: self.view.bounds)
        sbTblView.delegate = self
        
        sbTblView.setFileArrayValue([
            "http://techslides.com/demos/sample-videos/small.mp4",
            "http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4"
            ],
            sbDownloadFileType: .SBDownloadFileTypeVideo)
        
        self.view.addSubview(sbTblView)
        
    }
    
    func selectedFileType(fileType: SBDownloadFileType, filePath: NSString) {
        
        let sbDVCtrl : SBDetailsViewController = SBDetailsViewController ()
        sbDVCtrl.showSBDetailFileType(fileType, filePath: filePath)
        self.navigationController?.pushViewController(sbDVCtrl, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
