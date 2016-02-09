
import UIKit

class SBPDFDownloadTaskViewController: UIViewController, SBDetailDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "SBPDF DOWNLOAD TASK";
        self.view.backgroundColor = UIColor.whiteColor()
        
        let sbTblView : SBTableView = SBTableView (frame: self.view.bounds)
        sbTblView.delegate = self
        
        sbTblView.setFileArrayValue([
            "http://swift-lang.org/guides/trunk/userguide/userguide.pdf"
            ],
            sbDownloadFileType: .SBDownloadFileTypePDF)
        
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
