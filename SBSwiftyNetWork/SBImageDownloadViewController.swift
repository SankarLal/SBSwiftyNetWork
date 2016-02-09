

import UIKit
import SBSwiftyNetWorking

class SBImageDownloadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var imageArray  = [String]()
    var tblView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "SBIMAGE DOWNLOAD";
        self.view.backgroundColor = UIColor.whiteColor()
        
        imageArray = ["https://www.gstatic.com/webp/gallery3/5.png",
            "http://oi44.tinypic.com/16hvtok.jpg",
            "http://www.google.com/intl/en_ALL/images/logo.png",
            "https://www.gstatic.com/webp/gallery3/1.png",
            "https://www.gstatic.com/webp/gallery3/2.png"]
        
        setUpUserInterface ()
        
    }
    
    // MARK: SetUp User Interface
    func setUpUserInterface() {
        
        tblView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.showsVerticalScrollIndicator = false
        tblView.backgroundColor = UIColor.clearColor()
        tblView.tableHeaderView?.userInteractionEnabled = true
        tblView.tableFooterView = UIView(frame: CGRectZero)
        self.view.addSubview(tblView)
        self.tblView.reloadData()
        
        
    }
    
    // MARK: ALL DELEGATE FUNCTIONS
    // MARK: TableView Delegate And DataSource Function
    
    let LABEL1_TAG = 1
    let IMAGE_TAG = 2
    let INDICATOR_TAG = 3
    
    let ROW_HEIGHT : CGFloat = 115.0
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return (imageArray.count)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ROW_HEIGHT
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CELL-IDENTIFIER"
        
        var label1 : UILabel
        var imageView : UIImageView
        var indicator : UIActivityIndicatorView
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell == nil {
            cell = UITableViewCell (style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            
            imageView = UIImageView (frame: CGRectMake(5, 8, 100, 100))
            imageView.tag = IMAGE_TAG
            cell?.addSubview(imageView)
            
            indicator = UIActivityIndicatorView (activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            indicator.frame = CGRectMake(0, 0, 25, 25)
            indicator.tag = INDICATOR_TAG
            indicator.color = UIColor.blueColor()
            indicator.hidesWhenStopped = true
            indicator.center = CGPointMake(imageView.frame.size.width / 2 , imageView.frame.size.height / 2 - 5)
            indicator.startAnimating()
            imageView.addSubview(indicator)
            
            label1 = UILabel (frame: CGRectMake (imageView.frame.size.width + 8, 3.0, tblView.frame.size.width - (imageView.frame.size.width + 16), ROW_HEIGHT))
            label1.tag = LABEL1_TAG
            label1.textColor = UIColor.purpleColor()
            label1.textAlignment = NSTextAlignment.Center
            label1.text = NSString (format: "IndexPath Section Is %d", indexPath.section) as String
            cell?.contentView.addSubview(label1)
            
        }
        
        label1 = cell?.contentView.viewWithTag(LABEL1_TAG) as! UILabel
        label1.text = NSString (format: "IndexPath Section Is %d", indexPath.section) as String
        
        imageView = cell?.viewWithTag(IMAGE_TAG) as! UIImageView
        imageView.image = UIImage (named: "D_Image")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imageView.tintColor = UIColor.purpleColor()
        
        (imageView.viewWithTag(INDICATOR_TAG) as! UIActivityIndicatorView).startAnimating()
        
        
        // ******** Data Task Request For Image Download, Without Cache ******** //
        
        //        SBManager.sharedInstance.performDataTaskWithDownlaodImageURL(imageArray [indexPath.section],
        //            imageSuccess: { (image) -> Void in
        //
        //            }) { (error) -> Void in
        //
        //
        //        }
        //
        // ******** Data Task Request For Image Download, With Cache - Default System Cache Time ******** //
        //        SBManager.sharedInstance.performDataTaskWithCacheAndDownlaodImageURL(imageArray [indexPath.section],
        //            imageSuccess: { (image) -> Void in
        //
        //            }) { (error) -> Void in
        //
        //
        //        }
        
        // ******** Data Task Request For Image Download, With Cache - Image Cache Time will be different for Each Request ******** //
        SBManager.sharedInstance.performDataTaskWithCacheAndDownlaodImageURL(imageArray [indexPath.section],
            cacheExpireTimeInMinutes:10,
            imageSuccess: { (image) -> Void in
                
                imageView.image = image
                (imageView.viewWithTag(self.INDICATOR_TAG) as! UIActivityIndicatorView).stopAnimating()
                
            }) { (error) -> Void in
                
                
        }
        
        return cell!
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
