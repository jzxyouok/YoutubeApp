//
//  SavedVideosViewController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 06/08/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//
//test

import UIKit
import Alamofire
import GTMOAuth2
import GoogleAPIClientForREST

class SavedVideosViewController: UITableViewController, VideoModelDelegate {
    
    var videos: [Video] = []
    var finished = 0
    let model = VideoModel()
    var selectedVideo = Video()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        self.model.delegate=self
        
        navigationController!.navigationBar.barTintColor = UIColor.black
        navigationController!.navigationBar.tintColor=UIColor.white
        navigationController!.navigationBar.titleTextAttributes=[NSForegroundColorAttributeName : UIColor.white]
        navigationController!.navigationBar.isOpaque=true
        self.navigationController!.navigationBar.barStyle = .black
    }
    
    func dataReady() {
        self.tableView.reloadData()
    }
    
    @IBAction func syncButtonPressed(_ sender: UIBarButtonItem) {
        
        //The request below is for uploading videos to a personal watch later playlist.
        if let authorizer = self.model.service.authorizer,
            let canAuth = authorizer.canAuthorize , canAuth {
            let alert = UIAlertController(title: "Sync Saved Videos to YouTube", message: "Click Sync to add your saved videos with your YouTube Watch Later Playlist", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Sync", style: .default, handler: { (action: UIAlertAction) in
                self.model.addVideosToPlaylist(self.videos)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Sync Saved Videos to YouTube", message: "Please sign in to Google first in settings", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "SelectedVideos") as? Data != nil {
            let data=(userDefaults.object(forKey: "SelectedVideos") as? Data)!
            VideoStatus.selectedVideos=NSKeyedUnarchiver.unarchiveObject(with: data) as! [Video]
            self.videos=VideoStatus.selectedVideos
        }
        print(self.model.service.authorizer?.canAuthorize)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.finished=0
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return VideoStatus.selectedVideos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.numberOfLines=0
        cell.textLabel?.minimumScaleFactor = 0.7
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text=(VideoStatus.selectedVideos[(indexPath as NSIndexPath).row]).snippet!.title
        
        UIGraphicsBeginImageContext(CGSize(width: 80, height: 80))
        let imageRect = CGRect(x: 10, y: 10, width: 80, height: 80)
        var newImage = UIImage()
        newImage.draw(in: imageRect)
        let videoThumbnailUrlString = (VideoStatus.selectedVideos[(indexPath as NSIndexPath).row]).snippet!.thumbnailUrlString
        
        //Create an NSURL object
        let videoThumbnailUrl = URL(string: videoThumbnailUrlString!)
        if videoThumbnailUrl != nil {
            
            //Create an NSURLRequest object
            let request = URLRequest(url: videoThumbnailUrl!)
            
            //Create an NSURLSession
            let session = URLSession.shared
            
            //Create a datatask and pass in the request
            let dataTask = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                guard data != nil else {
                    return
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    //Create an image object from the data and assign it into the imageView
                    newImage = UIImage(data: data!)!
                    cell.imageView!.image=newImage.withRenderingMode(.alwaysOriginal)
                    if (indexPath as NSIndexPath).row == self.tableView.visibleCells.endIndex-1 && self.finished==0{
                        self.finished=1
                        self.tableView.reloadData()
                    }
                })
                
            } as! (Data?, URLResponse?, Error?) -> Void)
            
            dataTask.resume()
            
        }
        UIGraphicsEndImageContext()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedVideo=videos[(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: "goToDetail2", sender: self)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            VideoStatus.selectedVideos.remove(at: (indexPath as NSIndexPath).row)
            self.videos=VideoStatus.selectedVideos
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Get a reference for the destination view controller.
        if segue.identifier == "goToDetail2" {
            let detailViewController = segue.destination as! VideoDetailViewController
            
            //Set the selectedVideo property of the destination view controller.
            detailViewController.selectedVideo = self.selectedVideo
        } else if segue.identifier == "goToSettings" {
            let settingsViewController = segue.destination as! SettingsViewController
            settingsViewController.model.service = self.model.service
        }
    }
    
}
