//
//  VideoDetailViewController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 10/02/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import ReachabilitySwift


extension Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}



class VideoDetailViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    var selectedVideo:Video?
    var reachability: Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let vid=self.selectedVideo {
            
            self.titleLabel.text=vid.snippet!.title
            self.descriptionLabel.text=vid.snippet!.descriptionn
            
            
            let width=self.view.frame.size.width
            let height = width/320*180
            
            //Adjust the height of the webview constraint.
            self.webViewHeightConstraint.constant=height
            
            if Reachability.isConnectedToNetwork() {
                var videoEmbedString = "<html><head><style type=\"text/css\">body {background-color: transparent;color: white;}</style></head><body style=\"margin:0\"><iframe frameBorder=\"0\" height=\""
                videoEmbedString += String(height) + "\" width=\"" + String(width)
                videoEmbedString += "\" src=\"http://www.youtube.com/embed/" + vid.videoId! + "?showinfo=0&modestbranding=1&frameborder=0&rel=0\"></iframe></body></html>"
                
                self.webView.loadHTMLString(videoEmbedString, baseURL: nil)
            }
            
            do {
                self.reachability = try Reachability.reachabilityForInternetConnection()
            } catch {
                print("Unable to create Reachability")
                return
            }
            
        }
        
        func viewWillAppear(animated: Bool) {
            
            self.reachability!.whenReachable = { reachability in
                if reachability.isReachableViaWiFi() {
                    dispatch_async(dispatch_get_main_queue()) {
                        let alertController = UIAlertController(title: "Alert", message: "Reachable via WiFi", preferredStyle: .Alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        let alertController = UIAlertController(title: "Alert", message: "Reachable via Cellular", preferredStyle: .Alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
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
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoDetailViewController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
        do {
            try self.reachability!.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
        }
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
