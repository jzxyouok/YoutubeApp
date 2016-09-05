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

//class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VideoModelDelegate {

class ViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate, VideoModelDelegate, StatefulViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    @IBAction func signOutButtonPressed(sender: UIBarButtonItem) {
        GTMOAuth2ViewControllerTouch.removeAuthFromKeychainForName(kKeychainItemName)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(nil, forKey: "InterestsArray")
        userDefaults.setObject(nil, forKey: "SkillsArray")
        userDefaults.setObject(nil, forKey: "SelectedVideos")
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : SignInViewController = storyboard.instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    private let kKeychainItemName = "YouTube Data API"
    var videos:[Video]=[Video]()
    var videoCache:[Video]=[Video]()
    var selectedVideos=[Video]()
    var selectedVideo:Video?
    var model:VideoModel = VideoModel()
    var searchWords: [String] = []
    var interestSelectionArray = [String]()
    var skillSelectionArray = [String]()
    var done: Int = 0
    //New variables
    var counter: Int = 0
    var value: Int = 0
    var numberOfCards: UInt = 3
    var data: NSData = NSData()
    var reachability: Reachability?
    
    override func viewDidAppear(animated: Bool) {
        do {
            self.reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.reachability!.whenReachable = { reachability in
            if reachability.isReachableViaWiFi() {
                dispatch_async(dispatch_get_main_queue()) {
                    let alertController = UIAlertController(title: "Alert", message: "Reachable via WiFi", preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    if self.videos.isEmpty {
                        setupInitialViewState()
                    }
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    let alertController = UIAlertController(title: "Alert", message: "Reachable via Cellular", preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    if self.videos.isEmpty {
                        setupInitialViewState()
                    }
                }
            }
        }
        self.reachability!.whenUnreachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                let alertController = UIAlertController(title: "Alert", message: "Not Reachable", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoDetailViewController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
        do {
            try self.reachability!.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Fire off request to get videos
        self.model.delegate = self
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.objectForKey("InterestsArray") as? [String] == nil || userDefaults.objectForKey("SkillsArray") as? [String] == nil {
            userDefaults.setObject(self.interestSelectionArray, forKey: "InterestsArray")
            userDefaults.setObject(self.skillSelectionArray, forKey: "SkillsArray")
        } else if userDefaults.objectForKey("InterestsArray") as? [String] != nil && userDefaults.objectForKey("SkillsArray") as? [String] != nil{
            self.interestSelectionArray=userDefaults.objectForKey("InterestsArray") as! [String]
            self.skillSelectionArray=userDefaults.objectForKey("SkillsArray") as! [String]
        }
        print(interestSelectionArray)
        
        loadingView = LoadingViewController()
        emptyView = EmptyViewController()
        
        
        if Reachability.isConnectedToNetwork() {
            
            self.model.generateKeywords(interestSelectionArray) { data in
                self.searchWords+=data
                self.model.getFeedVideos(self.interestSelectionArray, keywordArray: self.searchWords) { data in
                    //Notify the delegate that the data is ready
                    
                    self.model.getSkillsFeedVideos(self.skillSelectionArray, keywordArray: self.searchWords) { data in
                        
                        self.videos = data as! [Video]
                        
                        if self.model.delegate != nil {
                            self.numberOfCards = UInt(self.videos.count)
                            self.koloda(kolodaNumberOfCards: self.kolodaView)
                            self.model.delegate!.dataReady()
                        }
                        
                    }
                }
                self.done=1
            }
        } else {
            self.presentViewController(LoadingViewController(), animated: true, completion: nil)
        }
        
        self.kolodaView.dataSource = self
        self.kolodaView.delegate = self
    }
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
        cacheLoad()
        self.kolodaView.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- VideoModel Delegate Methods
    
    func dataReady() {
        
        //Access the video objects that have been downloaded.
        self.counter=0
        //Tell the tableview to reload
        self.kolodaView.reloadData()
    }
    
    func cacheLoad() {
        if kolodaView?.currentCardNumber == 0 && counter<self.videos.count && videoCache.count != 0 {
            counter=counter+1
            if !(Set(videoCache).isSubsetOf(Set(videos))) {
                videos=videoCache+videos
            }
            self.numberOfCards = UInt(counter)
            self.koloda(kolodaNumberOfCards: self.kolodaView)
            self.value = self.videoCache.count - counter
        }
    }
    
    func koloda(kolodaShouldApplyAppearAnimation koloda: KolodaView) -> Bool {
        return self.kolodaView.currentCardNumber==0
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        if (self.done == 1 && videos.count > Int(self.kolodaView.countOfCards-1)) {
            
            let videoTitle = videos[Int(index)+self.value].snippet!.title
            
            let cell = NSBundle.mainBundle().loadNibNamed("Thumbnail", owner: self, options: nil).first as? Thumbnail
            cell?.videoLabel.text = videoTitle
            
            let videoThumbnailUrlString = videos[Int(index)+self.value].snippet!.thumbnailUrlString
            
            //Create an NSURL object
            let videoThumbnailUrl = NSURL(string: videoThumbnailUrlString!)
            
            if videoThumbnailUrl != "" {
                
                //Create an NSURLRequest object
                let request = NSURLRequest(URL: videoThumbnailUrl!)
                
                //Create an NSURLSession
                let session = NSURLSession.sharedSession()
                
                //Create a datatask and pass in the request
                let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        guard data != nil else {
                            return
                        }
                        
                        
                        //Create an image object from the data and assign it into the imageView
                        cell!.iv.image = UIImage(data: data!)
                        
                    })
                })
                
                dataTask.resume()
                
            }
            
            return cell!
        } else {
            return UIView(frame: self.kolodaView.frame)
        }
    }
    
    func koloda(kolodaNumberOfCards koloda:KolodaView) -> UInt {
        return self.numberOfCards
    }
    
    func koloda(koloda: KolodaView, didSwipedCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.objectForKey("SelectedVideos") as? NSData != nil {
            self.data=(userDefaults.objectForKey("SelectedVideos") as? NSData)!
            VideoStatus.selectedVideos=NSKeyedUnarchiver.unarchiveObjectWithData(self.data) as! [Video]
            self.selectedVideos=VideoStatus.selectedVideos
        }
        if direction == .Right {
            if !self.selectedVideos.contains(videos[Int(index)+self.value]) {
                self.selectedVideos.append(videos[Int(index)+self.value])
            }
        }
        VideoStatus.selectedVideos=self.selectedVideos
        print(VideoStatus.selectedVideos)
        
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        
        let overlay = NSBundle.mainBundle().loadNibNamed("OverlayView",
                                                         owner: self, options: nil)[0] as? ExampleOverlayView
        
        if (self.kolodaView.viewForCardAtIndex(self.kolodaView.currentCardNumber) != UIView(frame: self.kolodaView.frame) && self.kolodaView.delegate != nil && self.done==1 && self.kolodaView.countOfVisibleCards != 0 && self.kolodaView.visibleCards != []) {
            
            let image = (self.kolodaView.viewForCardAtIndex(self.kolodaView.currentCardNumber) as! Thumbnail).iv.image
            
            overlay?.overlayImageView.image = image
        }
        
        return overlay
        
    }
    
    func koloda(kolodaShouldTransparentizeNextCard koloda: KolodaView) -> Bool {
        return false
    }
    
    func koloda(kolodaDidRunOutOfCards koloda: KolodaView) {
        if (videos.count<Int(self.numberOfCards)+1) {
            //Example: reloading
            self.done=0
            self.videoCache=self.videos
            self.model.videoArray = []
            if Reachability.isConnectedToNetwork() {
                self.getVideos()
            } else {
                self.presentViewController(LoadingViewController(), animated: true, completion: nil)
            }
            self.kolodaView.resetCurrentCardNumber()
        } else {
            if (self.kolodaView.currentCardNumber + self.value == self.videoCache.count) {
                self.numberOfCards = UInt(self.videos.count-self.videoCache.count)
                self.koloda(kolodaNumberOfCards: self.kolodaView)
                self.value=self.videoCache.count
                self.counter=0
                self.kolodaView.resetCurrentCardNumber()
            } else {
                self.videoCache = Array(videos[self.videoCache.count..<self.videos.count])
                self.value=0
                self.done=0
                self.model.videoArray=[]
                if Reachability.isConnectedToNetwork() {
                    self.getVideos()
                } else {
                    self.presentViewController(LoadingViewController(), animated: true, completion: nil)
                }
                self.kolodaView.resetCurrentCardNumber()
            }
        }
    }
    
    func getVideos() {
        for _ in interestSelectionArray {
            self.model.getFeedVideos(self.interestSelectionArray, keywordArray: self.searchWords) { data in
                //Notify the delegate that the data is ready
                
                self.model.getSkillsFeedVideos(self.skillSelectionArray, keywordArray: self.searchWords) { data in
                    
                    self.videos = data as! [Video]
                    
                    if self.model.delegate != nil {
                        self.numberOfCards = UInt(self.videos.count)
                        self.koloda(kolodaNumberOfCards: self.kolodaView)
                        self.model.delegate!.dataReady()
                    }
                    
                }
            }
            self.done=1
        }
    }
    
    
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        self.selectedVideo = self.videos[Int(index)+self.value]
        self.performSegueWithIdentifier("goToDetail", sender: self)
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Get a reference for the destination view controller.
        let detailViewController = segue.destinationViewController as! VideoDetailViewController
        
        //Set the selectedVideo property of the destination view controller.
        detailViewController.selectedVideo = self.selectedVideo
        
    }
    
}

