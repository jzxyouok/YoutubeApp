//
//  ViewController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 26/01/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit
import Foundation
import Koloda
import pop
import GTMOAuth2
import SystemConfiguration
import ReachabilitySwift
import StatefulViewController
import NVActivityIndicatorView
import Flurry_iOS_SDK
import EasyTipView

//class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VideoModelDelegate {

class ViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate, VideoModelDelegate, StatefulViewController, EasyTipViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        GTMOAuth2ViewControllerTouch.removeAuthFromKeychain(forName: kKeychainItemName)
        let userDefaults = UserDefaults.standard
        userDefaults.set(nil, forKey: "InterestsArray")
        userDefaults.set(nil, forKey: "SkillsArray")
        userDefaults.set(nil, forKey: "KeywordsArray")
        userDefaults.set(nil, forKey: "SelectedVideos")
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nvc : UINavigationController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        self.present(nvc, animated: true, completion: nil)
    }
    
    fileprivate let kKeychainItemName = "YouTube Data API"
    var videos:[Video]=[Video]()
    var videoCache:[Video]=[Video]()
    var selectedVideos=[Video]()
    var selectedVideo:Video?
    var model:VideoModel = VideoModel()
    var searchWords: [String] = []
    var interestSelectionArray = [NSString]()
    var keywordsArray = [NSString]()
    var skillSelectionArray = [NSString]()
    var done: Int = 0
    //New variables
    var counter: Int = 0
    var value: Int = 0
    var numberOfCards: UInt = 3
    var data: Data? = Data()
    var reachability: Reachability?
    //let refreshControl = UIRefreshControl()
    var preferences = EasyTipView.Preferences()
    
    override func viewDidAppear(_ animated: Bool) {
        let parameters = ["InterestsArray" : self.interestSelectionArray, "SkillsArray" : self.skillSelectionArray, "KeywordsArray" : self.keywordsArray]
        Flurry.logEvent("Completed Interests, Skills and Keywords Selection", withParameters: parameters)
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "DiscovrNavBar.png")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
        navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName : UIColor.black]
        navigationController!.navigationBar.barTintColor = UIColor.black
        navigationController!.navigationBar.tintColor=UIColor.black
        navigationController!.navigationBar.isOpaque=true
        self.navigationController!.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.backgroundColor=UIColor.clear
        
        self.reachability = Reachability()
        
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "InterestsArray") as? [NSString] == nil || userDefaults.object(forKey: "SkillsArray") as? [NSString] == nil {
            /*
             userDefaults.setObject(self.interestSelectionArray, forKey: "InterestsArray")
             userDefaults.setObject(self.skillSelectionArray, forKey: "SkillsArray")
             */
        } else if userDefaults.object(forKey: "InterestsArray") as? [NSString] != nil && userDefaults.object(forKey: "SkillsArray") as? [NSString] != nil {
            self.interestSelectionArray=(userDefaults.object(forKey: "InterestsArray") as! [NSString])
            if userDefaults.object(forKey: "KeywordsArray") as? [NSString] != nil {
            self.keywordsArray = (userDefaults.object(forKey: "KeywordsArray") as! [NSString])
            }
            self.skillSelectionArray=userDefaults.object(forKey: "SkillsArray") as! [NSString]
        }
        
        print(interestSelectionArray)
        
        self.reachability!.whenReachable = { reachability in
            if reachability.isReachableViaWiFi {
                //DispatchQueue.main.async {
                    //                    let alertController = UIAlertController(title: "Alert", message: "Reachable via WiFi", preferredStyle: .Alert)
                    //                    
                    //                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    //                    alertController.addAction(defaultAction)
                    //                    
                    //                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    if self.videos.isEmpty {
                        self.setupInitialViewState()
                        self.refresh()
                    }
                //}
            } else {
                //DispatchQueue.main.async {
                    //                    let alertController = UIAlertController(title: "Alert", message: "Reachable via Cellular", preferredStyle: .Alert)
                    //                    
                    //                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    //                    alertController.addAction(defaultAction)
                    //                    
                    //                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    if self.videos.isEmpty {
                        self.setupInitialViewState()
                        self.refresh()
                    }
                //}
            }
        }
        self.reachability!.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Alert", message: "Not Reachable", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoDetailViewController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
        do {
            try self.reachability!.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func reachabilityChanged(_ note: Notification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
        }
    }
    
    public func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        if tipView.text == "If you liked this video you can tap me!" {
        EasyTipView.show(forView: self.dismissButton, withinSuperview: self.view, text: "Otherwise you can tap me! No hard feelings! ;)", preferences: self.preferences, delegate: self)
        } else if tipView.text == "You can swipe to save me for later, and tap me to watch the video!" {
            EasyTipView.show(forView: self.likeButton,
                             withinSuperview: self.view,
                             text: "If you liked this video you can tap me!",
                             preferences: self.preferences,
                             delegate: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Fire off request to get videos
        self.model.delegate = self
        
        loadingView = LoadingView(frame: self.view.frame)
        emptyView = EmptyView(frame: self.view.frame)
        errorView = ErrorView(frame: self.view.frame)
        //refreshControl.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        //self.view.addSubview(refreshControl)
        
        self.kolodaView.dataSource = self
        self.kolodaView.delegate = self
        
        
        self.preferences.drawing.font = UIFont(name: "Helvetica Neue", size: 17)!
        self.preferences.drawing.foregroundColor = UIColor.white
        //self.preferences.drawing.backgroundColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        self.preferences.drawing.backgroundColor = UIColor.init(red: 208/255, green: 2/255, blue: 27/255, alpha: 1)
        self.preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        
        var prefrences = EasyTipView.Preferences()
        prefrences.drawing.font = UIFont(name: "Helvetica Neue", size: 17)!
        prefrences.drawing.foregroundColor = UIColor.white
        prefrences.drawing.backgroundColor = UIColor.init(red: 208/255, green: 2/255, blue: 27/255, alpha: 1)
        //prefrences.drawing.backgroundColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        prefrences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        
        EasyTipView.show(forView: self.kolodaView,
                         withinSuperview: self.view,
                         text: "You can swipe to save me for later, and tap me to watch the video!",
                         preferences: prefrences,
                         delegate: self)
    }
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    
    @IBAction func undoButtonTapped() {
        if !UpgradeManager.sharedInstance.hasUpgraded() {
            
            let alertController = UIAlertController(title: "Upgrade",
                                                    message: "Please upgrade to be able to undo selections",
                                                    preferredStyle: .alert)
            
            let upgradeAction = UIAlertAction(title: "Upgrade",
                                              style: .default,
                                              handler: { (action) in
                                                self.performSegue(withIdentifier: "ShowUpgradeViewController", sender: nil)
            })
            
            let laterAction = UIAlertAction(title: "Later",
                                            style: .cancel,
                                            handler: nil)
            
            alertController.addAction(upgradeAction)
            alertController.addAction(laterAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
        kolodaView?.revertAction()
        cacheLoad()
        self.kolodaView.reloadData()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        videos.removeAll()
        
    }
    
    //MARK:- VideoModel Delegate Methods
    
    func hasContent() -> Bool {
        return self.videos.count>0
    }
    
    func handleErrorWhenContentAvailable(_ error: Error) {
        let alertController = UIAlertController(title: "Ooops", message: "Something went wrong.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func dataReady() {
        
        //Access the video objects that have been downloaded.
        self.counter=0
        //Tell the tableview to reload
        self.kolodaView.reloadData()
    }
    
    func refresh() {
        
        if (lastState == .Loading) { return }
        
        startLoading()
        
        if (reachability?.isReachable)! {
            
            self.model.generateKeywords(interestSelectionArray as [String]) { data in
                self.searchWords+=data
                self.model.getKeywordFeedVideos(self.keywordsArray as [String]) { data in
                    
                self.model.getSkillsFeedVideos(self.skillSelectionArray as [String], keywordArray: self.searchWords) { data in
                    self.model.getFeedVideos(self.interestSelectionArray as [String], keywordArray: self.searchWords) { data in
                        
                        self.videos = data as! [Video]
                        if self.videos.isEmpty {
                            self.endLoading(error: nil)
                            
                        } else if self.model.delegate != nil {
                            self.numberOfCards = UInt(self.videos.count)
                            self.kolodaNumberOfCards(self.kolodaView)
                            self.model.delegate!.dataReady()
                            self.endLoading()
                        }
                        print("endLoading -> loadingState: \(self.lastState.rawValue)")
                        //self.refreshControl.endRefreshing()
                    }
                }
            }
                self.done=1
            }
        }
    }
    
    func cacheLoad() {
        if kolodaView?.currentCardIndex == 0 && counter<self.videos.count && videoCache.count != 0 {
            counter=counter+1
            if !(Set(videoCache).isSubset(of: Set(videos))) {
                videos=videoCache+videos
            }
            self.numberOfCards = UInt(counter)
            self.kolodaNumberOfCards(self.kolodaView)
            self.value = self.videoCache.count - counter
        }
    }
    
    func koloda(kolodaShouldApplyAppearAnimation koloda: KolodaView) -> Bool {
        return self.kolodaView.currentCardIndex==0
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        if (self.done == 1 && videos.count > Int(self.kolodaView.countOfCards-1)) {
            
            let videoTitle = videos[Int(index)+self.value].snippet!.title
            
            let cell = Bundle.main.loadNibNamed("Thumbnail", owner: self, options: nil)?.first as? Thumbnail
            cell?.videoLabel.text = videoTitle
            
            let videoThumbnailUrlString = videos[Int(index)+self.value].snippet!.thumbnailUrlString
            
            //Create an NSURL object
            let videoThumbnailUrl = URL(string: videoThumbnailUrlString!)
            
            if videoThumbnailUrl != URL(string: "") {
                
                //Create an NSURLRequest object
                let request = URLRequest(url: videoThumbnailUrl!)
                
                //Create an NSURLSession
                let session = URLSession.shared
                
                //Create a datatask and pass in the request
                let dataTask = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        guard data != nil else {
                            return
                        }
                        
                        
                        //Create an image object from the data and assign it into the imageView
                        cell!.iv.image = UIImage(data: data!)
                        
                    })
                } as! (Data?, URLResponse?, Error?) -> Void)
                
                dataTask.resume()
                
            }
            
            return cell!
        } else {
            return UIView(frame: self.kolodaView.frame)
        }
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> UInt {
        return self.numberOfCards
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        let userDefaults = UserDefaults.standard
        self.data=userDefaults.data(forKey: "SelectedVideos")
        if self.data != nil {
            if (NSKeyedUnarchiver.unarchiveObject(with: self.data!) as? [Video]) != nil {
                VideoStatus.selectedVideos=(NSKeyedUnarchiver.unarchiveObject(with: self.data!) as? [Video])!
                self.selectedVideos=VideoStatus.selectedVideos
            }
        }
        if direction == SwipeResultDirection.Right {
            var videoIds: [String] = []
            for video in self.selectedVideos {
                videoIds.append(video.videoId!)
            }
            if !videoIds.contains(videos[Int(index)+self.value].videoId!) {
                self.selectedVideos.append(videos[Int(index)+self.value])
            }
        }
        VideoStatus.selectedVideos=self.selectedVideos
        print(VideoStatus.selectedVideos)
        
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        
        let overlay = Bundle.main.loadNibNamed("OverlayView",
                                                         owner: self, options: nil)?[0] as? ExampleOverlayView
        
        if (self.kolodaView.viewForCardAtIndex(self.kolodaView.currentCardIndex) != UIView(frame: self.kolodaView.frame) && self.kolodaView.delegate != nil && self.done==1 && self.kolodaView.countOfVisibleCards != 0 && self.kolodaView.visibleCards != []) {
            
            let image = (self.kolodaView.viewForCardAtIndex(self.kolodaView.currentCardIndex+self.value) as! Thumbnail).iv.image
            
            overlay?.overlayImageView.image = image
        }
        
        return overlay
        
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        if (videos.count<Int(self.numberOfCards)+1) {
            //Example: reloading
            self.done=0
            self.videoCache=self.videos
            self.model.videoArray = []
            if (reachability?.isReachable)! {
                self.getVideos()
            }
            self.kolodaView.resetCurrentCardIndex()
        } else {
            if (self.kolodaView.currentCardIndex + self.value == self.videoCache.count) {
                self.numberOfCards = UInt(self.videos.count-self.videoCache.count)
                self.kolodaNumberOfCards(self.kolodaView)
                self.value=self.videoCache.count
                self.counter=0
                self.kolodaView.resetCurrentCardIndex()
            } else {
                self.videoCache = Array(videos[self.videoCache.count..<self.videos.count])
                self.value=0
                self.done=0
                self.model.videoArray=[]
                if (reachability?.isReachable)! {
                    self.getVideos()
                }
                self.kolodaView.resetCurrentCardIndex()
            }
        }
    }
    
    func getVideos() {
        for _ in interestSelectionArray {
                //Notify the delegate that the data is ready
                    
            self.model.getSkillsFeedVideos(self.skillSelectionArray as [String], keywordArray: self.searchWords) { data in
                self.model.getFeedVideos(self.interestSelectionArray as [String], keywordArray: self.searchWords) { data in
                    
                    self.videos = data as! [Video]
                    
                    if self.model.delegate != nil {
                        self.numberOfCards = UInt(self.videos.count)
                        self.kolodaNumberOfCards(self.kolodaView)
                        self.model.delegate!.dataReady()
                    }
                    
                }
            }
            self.done=1
        }
    }
    
    
    func koloda(_ koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        self.selectedVideo = self.videos[Int(index)+self.value]
        self.performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    
    /*
     //MARK:- TableView Delegate Methods
     
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     //Get the width of the screen to calculate the height of the row
     return (self.view.frame.size.width / 320) * 180
     }
     
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return videos.count
     }
     
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell")!
     
     let videoTitle = videos[indexPath.row].videoTitle
     
     //Customise the cell to display the video title.
     //cell.textLabel?.text = videoTitle
     
     //Get the label for the cell.
     let label = cell.viewWithTag(2) as! UILabel
     
     label.text = videoTitle
     
     //Construct the video thumbnail URL.
     let videoThumbnailUrlString = videos[indexPath.row].videoThumbnailUrl
     
     //Create an NSURL object
     let videoThumbnailUrl = NSURL(string: videoThumbnailUrlString)
     
     if videoThumbnailUrl != "" {
     
     //Create an NSURLRequest object
     let request = NSURLRequest(URL: videoThumbnailUrl!)
     
     //Create an NSURLSession
     let session = NSURLSession.sharedSession()
     
     //Create a datatask and pass in the request
     let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
     
     dispatch_async(dispatch_get_main_queue(), { () -> Void in
     
     //Get a reference to the imageView element of the cell.
     let imageView = cell.viewWithTag(1) as! UIImageView
     
     //Create an image object from the data and assign it into the imageView
     imageView.image = UIImage(data: data!)
     
     })
     
     })
     
     dataTask.resume()
     
     }
     
     return cell
     }
     
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     //Take note of which video the user selected.
     self.selectedVideo=self.videos[indexPath.row]
     
     //Call the segue
     self.performSegueWithIdentifier("goToDetail", sender: self)
     }
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Get a reference for the destination view controller.
        
        if segue.identifier == "goToDetail" {
        
            let detailViewController = segue.destination as! VideoDetailViewController
            print(videos.count)
            //Set the selectedVideo property of the destination view controller.
            detailViewController.selectedVideo = self.selectedVideo
        
        }
    }
    
}

