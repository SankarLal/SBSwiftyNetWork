

import UIKit
import SBSwiftyNetWorking

enum SBDownloadFileType: NSInteger {
    
    case SBDownloadFileTypeImage = 0
    case SBDownloadFileTypeVideo = 1
    case SBDownloadFileTypeAudio = 2
    case SBDownloadFileTypePDF = 3
    case SBDownloadFileTypeNone = 4
    
}

protocol SBDetailDelegate {
    
    func selectedFileType (fileType : SBDownloadFileType, filePath : NSString)
    
}

class SBTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let HEADER_COLOR : UIColor = UIColor (red: 56.0/255, green: 185.0/255, blue: 158.0/255, alpha: 1)
    
    var fileArray : NSMutableArray?
    var tblView : UITableView!
    var sBDownloadFileType : SBDownloadFileType
    var delegate:SBDetailDelegate?
    
    override init(frame: CGRect) {
        
        fileArray = NSMutableArray ()
        
        sBDownloadFileType = SBDownloadFileType.SBDownloadFileTypeNone
        
        super.init(frame: frame)
        
        setUpUserInterface()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: SetUp User Interface
    func setUpUserInterface () {
        
        tblView = UITableView(frame: self.bounds, style: UITableViewStyle.Plain)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.showsVerticalScrollIndicator = false
        tblView.backgroundColor = UIColor.clearColor()
        tblView.tableHeaderView?.userInteractionEnabled = true
        tblView.tableFooterView = UIView(frame: CGRectZero)
        self.addSubview(tblView)
        
    }
    
    func setFileArrayValue (fileArrayValue : NSArray, sbDownloadFileType : SBDownloadFileType) {
        
        fileArray?.removeAllObjects()
        fileArray?.addObjectsFromArray(fileArrayValue as [AnyObject])
        sBDownloadFileType = sbDownloadFileType
        tblView.reloadData()
    }
    
    
    let LABEL1_TAG                          = 1
    let IMAGE_TAG                           = 2
    let INDICATOR_TAG                       = 3
    let PROGRESS_VIEW_D_TAG                 = 4
    let PAUSE_RESUME_FILE_TAG               = 5
    let DELETE_FILE_TAG                     = 6
    
    let ROW_HEIGHT : CGFloat = 115.0
    
    // MARK: TableView Delegate And DataSource Function
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (fileArray?.count)!
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
        var progressView : UIProgressView
        var pauseResumeFileButton : UIButton
        var deleteFileButton : UIButton
        
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
            
            label1 = UILabel (frame: CGRectMake (imageView.frame.size.width + 8, 3.0, tblView.frame.size.width - (imageView.frame.size.width + 16 + 40), ROW_HEIGHT))
            label1.tag = LABEL1_TAG
            label1.textColor = HEADER_COLOR
            label1.textAlignment = NSTextAlignment.Center
            label1.text = NSString (format: "INDEX %d", indexPath.section) as String
            cell?.contentView.addSubview(label1)
            
            progressView = UIProgressView (progressViewStyle: UIProgressViewStyle.Default)
            progressView.setProgress(0, animated: true)
            progressView.tag = PROGRESS_VIEW_D_TAG
            cell?.contentView.addSubview(progressView)
            
            pauseResumeFileButton = UIButton (type: UIButtonType.Custom)
            pauseResumeFileButton.tag = PAUSE_RESUME_FILE_TAG
            pauseResumeFileButton.addTarget(self, action: "performPauseResumeFileButton:", forControlEvents: UIControlEvents.TouchUpInside)
            cell?.contentView.addSubview(pauseResumeFileButton)
            
            deleteFileButton = UIButton (type: UIButtonType.Custom)
            deleteFileButton.tag = DELETE_FILE_TAG
            deleteFileButton.addTarget(self, action: "performDeleteFileButton:", forControlEvents: UIControlEvents.TouchUpInside)
            cell?.contentView.addSubview(deleteFileButton)
            
        }
        
        label1 = cell?.contentView.viewWithTag(LABEL1_TAG) as! UILabel
        label1.text = NSString (format: "INDEX %d", indexPath.section) as String
        
        imageView = cell?.viewWithTag(IMAGE_TAG) as! UIImageView
        imageView.image = tableViewCellImageType(sBDownloadFileType).imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imageView.tintColor = HEADER_COLOR
        
        (imageView.viewWithTag(INDICATOR_TAG) as! UIActivityIndicatorView).startAnimating()
        
        (cell?.contentView.viewWithTag(PROGRESS_VIEW_D_TAG) as! UIProgressView).frame = CGRectMake(2, ROW_HEIGHT , tblView.frame.size.width - 4, 20)
        (cell?.contentView.viewWithTag(PROGRESS_VIEW_D_TAG) as! UIProgressView).hidden = false
        (cell?.contentView.viewWithTag(PROGRESS_VIEW_D_TAG) as! UIProgressView).progress = 0.0
        
        (cell?.contentView.viewWithTag(PAUSE_RESUME_FILE_TAG) as! UIButton).setImage(UIImage (named: "Pause"), forState: .Normal)
        (cell?.contentView.viewWithTag(PAUSE_RESUME_FILE_TAG) as! UIButton).setImage(UIImage (named: "Resume"), forState: .Selected)
        (cell?.contentView.viewWithTag(PAUSE_RESUME_FILE_TAG) as! UIButton).frame = CGRectMake(tblView.frame.size.width - 45, 62 , 38, 38)
        
        (cell?.contentView.viewWithTag(DELETE_FILE_TAG) as! UIButton).setImage(UIImage (named: "Close"), forState: .Normal)
        (cell?.contentView.viewWithTag(DELETE_FILE_TAG) as! UIButton).frame = CGRectMake(tblView.frame.size.width - 45, 12 , 38, 38)
        
        (cell?.contentView.viewWithTag(PAUSE_RESUME_FILE_TAG) as! UIButton).hidden = false
        (cell?.contentView.viewWithTag(DELETE_FILE_TAG) as! UIButton).hidden = false
        
        
        // Download Task Request For Files Download, Without Cache
        //        SBManager.sharedInstance.performDownloadTaskWithDownlaodFileURL(fileArray! [indexPath.section] as! NSString,
        //            downloadTaskData: { (data) -> Void in
        //
        //            }, failure: { (error) -> Void in
        //
        //            }) { (progressValue) -> Void in
        //
        //        }
        
        // Download Task Request For Files Download, With Cache - Default System Cache Time
        //        SBManager.sharedInstance.performDownloadTaskWithCacheAndDownlaodFileURL(fileArray! [indexPath.section] as! NSString,
        //            downloadTaskData: { (data) -> Void in
        //
        //            }, failure: { (error) -> Void in
        //
        //            }) { (progressValue) -> Void in
        //
        //        }
        
        // Download Task Request For Files Download, With Cache - File Cache Time will be different for Each Request
        SBManager.sharedInstance.performDownloadTaskWithCacheAndDownlaodFileURL(fileArray! [indexPath.section] as! NSString,
            cacheExpireTimeInMinutes: 10,
            downloadTaskData: { (data) -> Void in
                
                (cell?.contentView.viewWithTag(self.PROGRESS_VIEW_D_TAG) as! UIProgressView).hidden = true
                (imageView.viewWithTag(self.INDICATOR_TAG) as! UIActivityIndicatorView).stopAnimating()
                (cell?.contentView.viewWithTag(self.PAUSE_RESUME_FILE_TAG) as! UIButton).hidden = true
                (cell?.contentView.viewWithTag(self.DELETE_FILE_TAG) as! UIButton).hidden = true
                
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                switch (self.sBDownloadFileType) {
                    
                case .SBDownloadFileTypeImage :
                    
                    cell?.accessoryType = UITableViewCellAccessoryType.None
                    
                    let image : UIImage? = UIImage (data: data!)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        (cell?.viewWithTag(self.IMAGE_TAG) as! UIImageView).image = image
                    })
                    
                case .SBDownloadFileTypeVideo :
                    
                    self.addFilesInDocumentDirectory(data!,
                        fileName: NSString (format: "Video%ld.mp4",indexPath.section),
                        fileType: "VIDEOS")
                    
                    
                case .SBDownloadFileTypeAudio :
                    
                    self.addFilesInDocumentDirectory(data!,
                        fileName: NSString (format: "Audio%ld.mp3",indexPath.section),
                        fileType: "AUDIOS")
                    
                case .SBDownloadFileTypePDF :
                    
                    self.addFilesInDocumentDirectory(data!,
                        fileName: NSString (format: "PDF%ld.PDF",indexPath.section),
                        fileType: "PDFS")
                    
                    
                default:
                    print("")
                    
                    
                }
                
                
                
            }, failure: { (error) -> Void in
                
            }) { (progressValue) -> Void in
                
                (cell?.contentView.viewWithTag(self.PROGRESS_VIEW_D_TAG) as! UIProgressView).progress = progressValue!
                
        }
        
        
        return cell!
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var fileType : NSString = ""
        var fileName : NSString = ""
        
        switch (sBDownloadFileType) {
            
        case .SBDownloadFileTypeVideo :
            
            fileType = "VIDEOS";
            fileName = NSString (format: "/Video%ld.mp4",indexPath.section)
            
        case .SBDownloadFileTypeAudio :
            
            fileType = "AUDIOS";
            fileName = NSString (format: "/Audio%ld.mp3",indexPath.section)
            
        case .SBDownloadFileTypePDF :
            
            fileType = "PDFS";
            fileName = NSString (format: "/PDF%ld.PDF",indexPath.section)
            
        default :
            print("")
            
        }
        
        let filePath : NSString = createDocumentDirectoryPath(fileType).stringByAppendingString(fileName as String)
        
        //        if ((delegate?.selectedFileType) != nil) {
        //            delegate?.selectedFileType(sBDownloadFileType, filePath: filePath)
        //        }
        delegate?.selectedFileType(sBDownloadFileType, filePath: filePath)
        
    }
    
    
    // MARK: Perform Pause OR Resume File Button
    func performPauseResumeFileButton (sender: UIButton) {
        
        if (sender.selected == false) {
            sender.selected = true;
        } else {
            sender.selected = false;
        }
        let indexPathSection : NSInteger = getIndexPath(sender)
        SBManager.sharedInstance.pauseResumeRequestedURL(fileArray! [indexPathSection] as! NSString)
        
    }
    
    // MARK: Perform Delete File Button
    func performDeleteFileButton (sender: UIButton) {
        
        let indexPathSection : NSInteger = getIndexPath(sender)
        SBManager.sharedInstance.cancelDownloadingRequestedURL(fileArray! [indexPathSection] as! NSString)
        
        if fileArray!.count > 0 {
            fileArray?.removeObjectAtIndex(indexPathSection)
        }
        tblView.reloadData()
        
    }
    
    func getIndexPath (sender : UIButton) -> NSInteger {
        
        let pointInSuperview : CGPoint = (sender.superview?.convertPoint(sender.center, toView: tblView))!
        let tempPath : NSIndexPath = tblView.indexPathForRowAtPoint(pointInSuperview)!
        return tempPath.section
        
    }
    
    // MARK: Sotring / Retriving Files In Document Directory
    func addFilesInDocumentDirectory (responseData : NSData, fileName : NSString, fileType : NSString) -> Bool {
        
        let filePath : NSString = createDocumentDirectoryPath(fileType).stringByAppendingPathComponent(fileName as String)
        
        if responseData.writeToFile(filePath as String, atomically: true) {
            return true
        } else {
            return false
        }
    }
    
    func createDocumentDirectoryPath (fileType : NSString) -> NSString {
        
        let paths : NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory : NSString = paths.objectAtIndex(0) as! NSString
        let dataPath : NSString = documentsDirectory.stringByAppendingPathComponent(NSString (format: "/%@",fileType) as String)
        
        if !NSFileManager.defaultManager().fileExistsAtPath(dataPath as String) {
            try! NSFileManager.defaultManager().createDirectoryAtPath(dataPath as String, withIntermediateDirectories: false, attributes: nil)
        }
        return dataPath
    }
    
    func tableViewCellImageType (fileType : SBDownloadFileType) -> UIImage {
        
        switch (fileType) {
            
        case .SBDownloadFileTypeImage :
            return UIImage (named: "D_Image")!
            
        case .SBDownloadFileTypeVideo :
            return UIImage (named: "D_Video")!
            
        case .SBDownloadFileTypeAudio :
            return UIImage (named: "D_Audio")!
            
        case .SBDownloadFileTypePDF :
            return UIImage (named: "D_PDF")!
            
        default :
            print("")
            
        }
        return UIImage (named: "D_PDF")!
    }
}
