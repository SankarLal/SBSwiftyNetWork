

import UIKit
import AVFoundation
import MediaPlayer
import AssetsLibrary
import AVFoundation.AVAsset


class SBDetailsViewController: UIViewController {
    
    var webView : UIWebView!
    var audioPlayer : AVAudioPlayer!
    var moviePlayer : MPMoviePlayerController!
    
    var filePathURL : NSURL?
    
    //        var player : AVPlayer? = nil
    //        var playerLayer : AVPlayerLayer? = nil
    //        var asset : AVAsset? = nil
    //        var playerItem: AVPlayerItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "SB DOWNLOAD TASK";
        self.view.backgroundColor = UIColor.whiteColor()
        
        
    }
    
    func showSBDetailFileType (fileType : SBDownloadFileType, filePath : NSString) {
        
        switch (fileType) {
            
        case .SBDownloadFileTypeVideo:
            
            self.filePathURL = NSURL (string: filePath as String)!
            performSelector("playVideoFromPath", withObject: nil, afterDelay: 1.0)
            
            //            playVideoFromPath(NSURL (string: filePath as String)!)
            
        case .SBDownloadFileTypeAudio:
            
            playAudioFromPath(NSURL (string: filePath as String)!)
            
        case .SBDownloadFileTypePDF:
            
            showPDFInWebView(NSURL (string: filePath as String)!)
            
        default:
            print("")
        }
        
    }
    
    //    override func viewDidAppear(animated: Bool) {
    //        super.viewDidAppear(animated)
    //
    //        performSelector("playVideoFromPath", withObject: nil, afterDelay: 5.0)
    //    }
    
    // MARK: Play Video
    func playVideoFromPath () {
        
        moviePlayer = MPMoviePlayerController (contentURL: self.filePathURL)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "moviePlayBackDidFinish:",
            name: MPMoviePlayerWillExitFullscreenNotification,
            object: moviePlayer)
        
        moviePlayer.view.frame = self.view.bounds
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        moviePlayer.shouldAutoplay = true
        self.view.addSubview(moviePlayer.view)
        moviePlayer.setFullscreen(true, animated: true)
        moviePlayer.scalingMode = .AspectFill
        moviePlayer.play()
        
        
        
    }
    
    func moviePlayBackDidFinish (notification : NSNotification) {
        
        let player : MPMoviePlayerController = notification.object as! MPMoviePlayerController
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: MPMoviePlayerWillExitFullscreenNotification,
            object: player)
        
        moviePlayer.stop()
        moviePlayer.view.removeFromSuperview()
        
        //        let dictionary : NSDictionary = notification.userInfo!
        //        let reason : Int = dictionary.valueForKey(MPMoviePlayerPlaybackDidFinishReasonUserInfoKey) as! Int
        //        if (reason == 1) {
        //            // Error
        //        }
        
    }
    
    // MARK: Play Audio
    func playAudioFromPath (url : NSURL) {
        
        audioPlayer = try? AVAudioPlayer (contentsOfURL: url)
        audioPlayer.prepareToPlay()
        
        if audioPlayer.playing {
            audioPlayer.currentTime = 0.0
        }
        audioPlayer.play()
        
    }
    
    // MARK: Load PDF File
    func showPDFInWebView (url : NSURL) {
        
        webView = UIWebView (frame: self.view.bounds)
        webView.opaque = false
        webView.backgroundColor = UIColor.clearColor()
        webView.scalesPageToFit = true
        self.view.addSubview(webView)
        
        let requestObj : NSURLRequest = NSURLRequest (URL: url)
        webView.userInteractionEnabled = true
        webView.loadRequest(requestObj)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if moviePlayer != nil {
            moviePlayer.stop()
            moviePlayer.view.removeFromSuperview()
            moviePlayer = nil
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
