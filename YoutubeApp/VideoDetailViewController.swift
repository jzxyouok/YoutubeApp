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
    /*
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    */
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let vid=self.selectedVideo {
            
            self.titleLabel.text=vid.snippet!.title
            self.descriptionLabel.text=vid.snippet!.descriptionn
            
            
            let width=self.view.frame.size.width
            let height = width/320*180
            
            //Adjust the height of the webview constraint.
            self.webViewHeightConstraint.constant=height
            
            self.reachability = try Reachability()
            
            if (reachability?.isReachable)! {
                var videoEmbedString = "<html><head><style type=\"text/css\">body {background-color: transparent;color: white;}</style></head><body style=\"margin:0\"><iframe frameBorder=\"0\" height=\""
                videoEmbedString += String(describing: height) + "\" width=\"" + String(describing: width)
                videoEmbedString += "\" src=\"http://www.youtube.com/embed/" + vid.videoId! + "?showinfo=0&modestbranding=1&frameborder=0&rel=0\"></iframe></body></html>"
                
                self.webView.loadHTMLString(videoEmbedString, baseURL: nil)
            }
            
        }
        
        func viewWillAppear(_ animated: Bool) {
            
            self.reachability!.whenReachable = { reachability in
                if reachability.isReachableViaWiFi {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Alert", message: "Reachable via WiFi", preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Alert", message: "Reachable via Cellular", preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
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
            
        }
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(VideoDetailViewController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
        do {
            try self.reachability!.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
         */
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
