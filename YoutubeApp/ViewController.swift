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

//class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VideoModelDelegate {

class ViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate, VideoModelDelegate {

    
    @IBOutlet weak var kolodaView: KolodaView!
    
    var videos:[Video]=[Video]()
    var videoCache:[Video]=[Video]()
    var selectedVideo:Video?
    let model:VideoModel = VideoModel()
    var searchWords: [String] = []
    var interestSelectionArray = [String]()
    var done: Int = 0
    //New variables
    var counter: Int = 0
    var value: Int = 0
    var numberOfCards: UInt = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //Fire off request to get videos
        self.model.delegate = self
        var searchWords: [String] = []
        
        for interest in interestSelectionArray {
            self.model.generateKeywords(interest) { data in
                for word in data {
                    searchWords.append(word.valueForKeyPath("word") as! String)
                }
                self.searchWords=searchWords
            
                self.model.getFeedVideos(self.interestSelectionArray, keywordArray: searchWords) { data in
                    if let items = data!["items"] as? NSArray {
                        
                        var arrayOfVideos = [Video]()
                        
                        for video in items {
                            //Create Video objects off of the JSON response.
                            let videoObj = Video()
                            videoObj.videoId=video.valueForKeyPath("id.videoId") as! String
                            videoObj.videoTitle=video.valueForKeyPath("snippet.title") as! String
                            videoObj.videoDescription=video.valueForKeyPath("snippet.description") as! String
                            videoObj.videoThumbnailUrl=video.valueForKeyPath("snippet.thumbnails.default.url") as! String
                            
                            arrayOfVideos.append(videoObj)
                            
                        }
                        
                        
                        self.model.videoArray = arrayOfVideos
                        //Notify the delegate that the data is ready
                        if self.model.delegate != nil {
                            self.model.delegate!.dataReady()
                        }
                    }
                }
                self.done=1
            }
            
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
        self.videos = self.model.videoArray
        self.counter=0
        //Tell the tableview to reload
        self.kolodaView.reloadData()
    }
    
    func cacheLoad() {
        if kolodaView?.currentCardNumber == 0 && counter<3 && videoCache != [] {
            counter=counter+1
            if !(Set(videoCache).isSubsetOf(Set(videos))) {
                videos=videoCache+videos
            }
            self.value = 3 - counter
        }
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        if (self.done == 1 && videos.count > 2) {
            
        let videoTitle = videos[Int(index)+self.value].videoTitle
            
        let cell = NSBundle.mainBundle().loadNibNamed("Thumbnail", owner: self, options: nil).first as? Thumbnail
        cell?.videoLabel.text = videoTitle
        
        let videoThumbnailUrlString = videos[Int(index)+self.value].videoThumbnailUrl
            
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
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        
        return NSBundle.mainBundle().loadNibNamed("OverlayView",
                                                  owner: self, options: nil)[0] as? OverlayView
        
    }
    
    func koloda(kolodaDidRunOutOfCards koloda: KolodaView) {
        if (videos.count<4) {
        //Example: reloading
            self.done=0
            var searchWords: [String] = self.searchWords
            self.videoCache=self.videos
            self.model.videoArray = []
            self.getVideos()
        self.kolodaView.resetCurrentCardNumber()
        } else {
            if (self.kolodaView.currentCardNumber == 3) {
                self.numberOfCards = 6
                self.value=0
            } else {
                self.numberOfCards=3
                self.videoCache = Array(videos[3..<6])
                var searchWords: [String] = self.searchWords
                self.value=0
                self.done=0
                self.model.videoArray=[]
                self.getVideos()
                self.kolodaView.resetCurrentCardNumber()
            }
    
        }
    }
    
    func koloda(koloda: KolodaView, didShowCardAtIndex index: UInt) {
        
//        if (self.done == 1 && videos.count > 2 && counter != 0 && index==0) {
//            videos=videoCache
//            if self.model.delegate != nil {
//                kolodaView.counter = self.value
//                self.model.delegate!.dataReady()
//            }
//            
//        }
    }
    func getVideos() {
        for interest in interestSelectionArray {
            self.model.getFeedVideos(self.interestSelectionArray, keywordArray: searchWords) { data in
                if let items = data!["items"] as? NSArray {
                
                    var arrayOfVideos = [Video]()
                    
                    for video in items {
                    //Create Video objects off of the JSON response.
                        let videoObj = Video()
                        videoObj.videoId=video.valueForKeyPath("id.videoId") as! String
                        videoObj.videoTitle=video.valueForKeyPath("snippet.title") as! String
                        videoObj.videoDescription=video.valueForKeyPath("snippet.description") as! String
                        videoObj.videoThumbnailUrl=video.valueForKeyPath("snippet.thumbnails.default.url") as! String
                        
                        arrayOfVideos.append(videoObj)
                    
                    }
                    
                    
                    self.model.videoArray += arrayOfVideos
                    //Notify the delegate that the data is ready
                    if self.model.delegate != nil {
                        self.model.delegate!.dataReady()
                    }
                }
            
            }
            self.done=1
        }
    }

    func koloda(koloda: KolodaView, didSwipedCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        //Example: loading more cards
        if index>=2 {
            numberOfCards = 3
            kolodaView.reloadData()
        }
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        
        self.selectedVideo = self.videos[Int(index)]
        self.performSegueWithIdentifier("goToDetail", sender: self)
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return false
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

