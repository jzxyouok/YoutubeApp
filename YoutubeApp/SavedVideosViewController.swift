//
//  SavedVideosViewController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 06/08/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit
import Alamofire

class SavedVideosViewController: UITableViewController {
    
    var videos: [Video] = []
    var finished = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    @IBAction func syncButtonPressed(sender: UIBarButtonItem) {
        
        //The request below is to get an OAuthAccesss token for uploading videos to a personal watch later playlist.
        
        /*
        
        Alamofire.request(.GET, "https://accounts.google.com/o/oauth2/auth", parameters: ["client_id": "192877572614-k4ljl168palm9oq5skbgonsagf17t20h.apps.googleusercontent.com", "redirect_uri": "http://localhost/oauth2callback", "scope": "https://www.googleapis.com/auth/youtube.upload", "response_type": "code"], encoding: ParameterEncoding.URL, headers: nil).responseJSON{ (response) -> Void in
            print(response)
            token=String(response)
        }
        */
        let headers = ["Authorization": "Bearer \(VideoStatus.authToken)"]
        upload(
            .POST,
            "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet",
            headers: headers,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data:"{'snippet':{'playlistId' : 'WL', 'resourceId': {'videoId' : 'a7SouU3ECpU', 'kind': 'youtube#video'}, 'position' : 0}}".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"snippet", mimeType: "application/json")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { (response: Response<AnyObject, NSError>) in
                        print(response)
                        
                    }
                case .Failure(_):
                    print("Failed")
                }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.objectForKey("SelectedVideos") as? NSData != nil {
            let data=(userDefaults.objectForKey("SelectedVideos") as? NSData)!
            VideoStatus.selectedVideos=NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Video]
            self.videos=VideoStatus.selectedVideos
            
        }
        print(self.finished)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.finished=0
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return VideoStatus.selectedVideos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.numberOfLines=0
        cell.textLabel?.minimumScaleFactor = 0.7
        cell.textLabel?.lineBreakMode = .ByWordWrapping
        cell.textLabel?.text=(VideoStatus.selectedVideos[indexPath.row]).snippet!.title
        
        UIGraphicsBeginImageContext(CGSizeMake(80, 80))
        let imageRect = CGRectMake(10, 10, 80, 80)
        var newImage = UIImage()
        newImage.drawInRect(imageRect)
        let videoThumbnailUrlString = (VideoStatus.selectedVideos[indexPath.row]).snippet!.thumbnailUrlString
        
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
                    
                    //Create an image object from the data and assign it into the imageView
                    newImage = UIImage(data: data!)!
                    cell.imageView!.image=newImage.imageWithRenderingMode(.AlwaysOriginal)
                    if indexPath.row == self.tableView.visibleCells.endIndex-1 && self.finished==0{
                        self.finished=1
                        self.tableView.reloadData()
                    }
                })
            })
            
            dataTask.resume()
            
        }
        UIGraphicsEndImageContext()
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            VideoStatus.selectedVideos.removeAtIndex(indexPath.row)
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let data = NSKeyedArchiver.archivedDataWithRootObject(VideoStatus.selectedVideos)
            userDefaults.setObject(data, forKey: "SelectedVideos")
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
