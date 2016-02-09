

import UIKit
import SBSwiftyNetWorking

class SBJsonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var responseArray  = [String]()
    var filterResponseArray = [String]()
    
    var tblView : UITableView!
    var searchController : UISearchController?
    
    var isFilterText  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "SBJSON RESPONSE";
        self.view.backgroundColor = UIColor.whiteColor()
        
        setUpUserInterface ()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let urlString : NSString = "http://api.geonames.org/citiesJSON?north=44.1&south=-9.9&east=-22.4&west=55.2&lang=de&username=demo"
        ////    NSString *urlString1 = [NSString stringWithFormat:@"http://ec2-54-69-71-147.us-west-2.compute.amazonaws.com:8181/m2mservices/v2/parkInfo?parkName=GRBA"];
        
        
        // ******** Each and every time, it will fetch to server ******** //
        
        //        SBManager.sharedInstance.performDataTaskWithExecuteGetURL(urlString,
        //            success: { (dictionary) -> Void in
        //
        //                print(dictionary)
        //
        //            }) { (error) -> Void in
        //
        //                print(error?.localizedDescription)
        //
        //        }
        
        // ******** After five minutes only (Based on "configCacheTimeInMinutes:5" Or "defaultCacheTimeConfig") next call will go to server. Eventhough Network available or Not available ******** //
        
        //        SBManager.sharedInstance.performDataTaskWithCacheAndExecuteGetURL(urlString,
        //            success: { (dictionary) -> Void in
        //
        //                print(dictionary)
        //
        //            }) { (error) -> Void in
        //
        //                print(error?.localizedDescription)
        //
        //        }
        
        // ******** After ten minutes (Based on "cacheExpireTimeInMinutes" value) only next call will go to server. Eventhough Network available or Not available ******** \\
        
        SBManager.sharedInstance.performDataTaskWithCacheAndExecuteGetURL(urlString,
            cacheExpireTimeInMinutes: 10,
            success: { (dictionary) -> Void in
                
                self.updateResponseData(dictionary)
                
            }) { (error) -> Void in
                self.showErrorMessage((error?.localizedDescription)!)
                
        }
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
        
        searchController = UISearchController (searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.delegate = self;
        self.definesPresentationContext = true
        searchController!.searchBar.sizeToFit()
        tblView.tableHeaderView = searchController!.searchBar
        self.tblView.reloadData()
        
        if #available(iOS 9.0, *) {
            searchController?.loadViewIfNeeded()
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    // MARK: Update Response Data
    func updateResponseData (responseData : NSDictionary?) {
        if responseData?.valueForKey("serverResponse")?.valueForKey("geonames") != nil {
            
            responseArray = responseData?.valueForKey("serverResponse")?.valueForKey("geonames")?.valueForKey("toponymName") as! Array
            
        }
        else {
            responseArray = ["USA", "Bahamas", "Brazil", "Canada", "Republic of China", "Cuba", "Egypt", "Fiji", "France", "Germany", "Iceland", "India", "Indonesia", "Jamaica", "Kenya", "Madagascar", "Mexico", "Nepal", "Oman", "Pakistan", "Poland", "Singapore", "Somalia", "Switzerland", "Turkey", "UAE", "Vatican City"]
            
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tblView.reloadData()
        }
    }
    
    // MARK: Show Error Message
    func showErrorMessage (errorMessage : NSString) {
        
        let alertViewController : UIAlertController = UIAlertController (title: "Error",
            message: errorMessage as String,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let okButton : UIAlertAction = UIAlertAction (title: "Ok",
            style: UIAlertActionStyle.Default) { (action) -> Void in
                NSLog("Ok Button")
                
        }
        
        alertViewController.addAction(okButton)
        self.presentViewController(alertViewController,
            animated: true,
            completion: nil)
        
    }
    
    
    // MARK: ALL DELEGATE FUNCTIONS
    // MARK: TableView Delegate And DataSource Function
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if isFilterText {
            return (filterResponseArray.count)
            
        } else {
            return (responseArray.count)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CELL-IDENTIFIER"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell == nil {
            cell = UITableViewCell (style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        if isFilterText {
            cell!.textLabel!.text =  filterResponseArray[indexPath.section]
            
        } else {
            
            cell!.textLabel!.text =  responseArray[indexPath.section]
        }
        
        return cell!
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tblView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    // MARK: SearchBar Delegate Function
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            isFilterText = false
        } else {
            isFilterText = true
            filterTableViewForEnterText(searchText)
            
        }
        
        tblView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        isFilterText = false
        tblView.reloadData()
        
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResultsForSearchController(self.searchController!)
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //        print("updateSearchResultsForSearchController")
        //        self.filterTableViewForEnterText(self.searchController!.searchBar.text!)
        //        tblView.reloadData()
        
    }
    
    func filterTableViewForEnterText(searchText: String) {
        
        self.filterResponseArray = self.responseArray.filter({( strCountry : String) -> Bool in
            let stringForSearch = strCountry.rangeOfString(searchText)
            return (stringForSearch != nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
