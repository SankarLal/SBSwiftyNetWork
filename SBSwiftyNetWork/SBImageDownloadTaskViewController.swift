
import UIKit

class SBImageDownloadTaskViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "SBIMAGE DOWNLOAD TASK";
        self.view.backgroundColor = UIColor.whiteColor()
        
        let sbTblView : SBTableView = SBTableView (frame: self.view.bounds)
        sbTblView.setFileArrayValue([
            "https://www.gstatic.com/webp/gallery3/5.png",
            "http://oi44.tinypic.com/16hvtok.jpg"
            ],
            sbDownloadFileType: .SBDownloadFileTypeImage)
        
        self.view.addSubview(sbTblView)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
