//
//  OAuthController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 15/08/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

//test

import OAuthSwift

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

class OAuthController: OAuthViewController {
    // oauth swift object (retain)
    var oauthswift: OAuthSwift?
    
    var currentParameters = [String: String]()
    let formData = Semaphore<FormViewControllerData>()
    
    lazy var internalWebViewController: WebViewController = {
        let controller = WebViewController()
        #if os(OSX)
            controller.view = NSView(frame: NSRect(x:0, y:0, width: 450, height: 500)) // needed if no nib or not loaded from storyboard
        #elseif os(iOS)
            controller.view = UIView(frame: UIScreen.mainScreen().bounds) // needed if no nib or not loaded from storyboard
        #endif
        controller.delegate = self
        controller.viewDidLoad()
        return controller
    }()
    
}

extension OAuthController: OAuthWebViewControllerDelegate {
    #if os(iOS) || os(tvOS)
    
    func oauthWebViewControllerDidPresent() {
        
    }
    func oauthWebViewControllerDidDismiss() {
        
    }
    #endif
    
    func oauthWebViewControllerWillAppear() {
        
    }
    func oauthWebViewControllerDidAppear() {
        
    }
    func oauthWebViewControllerWillDisappear() {
        
    }
    func oauthWebViewControllerDidDisappear() {
        // Ensure all listeners are removed if presented web view close
        oauthswift?.cancel()
    }
}

extension OAuthController {
    
    // MARK: - do authentification
    func doAuthService(service: String) {
        
        // Check parameters
        guard var parameters = services[service] else {
            showAlertView("Miss configuration", message: "\(service) not configured")
            return
        }
        self.currentParameters = parameters
        
        // Ask to user by showing form from storyboards
        self.formData.data = nil
        Queue.Main.async { [unowned self] in
            self.performSegueWithIdentifier(Storyboards.Main.FormSegue, sender: self)
            // see prepare for segue
        }
        // Wait for result
        guard let data = formData.waitData() else {
            // Cancel
            return
        }
        
        parameters["consumerKey"] = data.key
        parameters["consumerSecret"] = data.secret
        
        if Services.parametersEmpty(parameters) { // no value to set
            let message = "\(service) seems to have not weel configured. \nPlease fill consumer key and secret into configuration file \(self.confPath)"
            print(message)
            Queue.Main.async { [unowned self] in
                self.showAlertView("Key and secret must not be empty", message: message)
            }
        }
        
        parameters["name"] = service
        
        switch service {
        case "Linkedin":
            doOAuthLinkedin(parameters)
        case "Linkedin2":
            doOAuthLinkedin2(parameters)
        case "GoogleDrive":
            doOAuthGoogle(parameters)
        default:
            print("\(service) not implemented")
        }
    }
    
    // MARK: Linkedin
    func doOAuthLinkedin(serviceParameters: [String:String]){
        let oauthswift = OAuth1Swift(
            consumerKey:    serviceParameters["consumerKey"]!,
            consumerSecret: serviceParameters["consumerSecret"]!,
            requestTokenUrl: "https://api.linkedin.com/uas/oauth/requestToken",
            authorizeUrl:    "https://api.linkedin.com/uas/oauth/authenticate",
            accessTokenUrl:  "https://api.linkedin.com/uas/oauth/accessToken"
        )
        
        self.oauthswift = oauthswift
        oauthswift.authorize_url_handler = get_url_handler()
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/linkedin")!, success: {
            credential, response, parameters in
            self.showTokenAlert(serviceParameters["name"], credential: credential)
            self.testLinkedin(oauthswift)
            }, failure: { error in
                print(error.localizedDescription)
        })
    }
    func testLinkedin(oauthswift: OAuth1Swift) {
        oauthswift.client.get("https://api.linkedin.com/v1/people/~", parameters: [:],
                              success: {
                                data, response in
                                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                                print(dataString)
            }, failure: { error in
                print(error)
        })
    }
    
    func doOAuthLinkedin2(serviceParameters: [String:String]){
        let oauthswift = OAuth2Swift(
            consumerKey:    serviceParameters["consumerKey"]!,
            consumerSecret: serviceParameters["consumerSecret"]!,
            authorizeUrl:   "https://www.linkedin.com/uas/oauth2/authorization",
            accessTokenUrl: "https://www.linkedin.com/uas/oauth2/accessToken",
            responseType:   "code"
        )
        self.oauthswift = oauthswift
        oauthswift.authorize_url_handler = get_url_handler()
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorizeWithCallbackURL( NSURL(string: "http://oauthswift.herokuapp.com/callback/linkedin2")!, scope: "r_fullprofile", state: state, success: {
            credential, response, parameters in
            self.showTokenAlert(serviceParameters["name"], credential: credential)
            self.testLinkedin2(oauthswift)
            
            }, failure: { error in
                print(error.localizedDescription)
        })
    }
    func testLinkedin2(oauthswift: OAuth2Swift) {
        oauthswift.client.get("https://api.linkedin.com/v1/people/~?format=json", parameters: [:],
                              success: {
                                data, response in
                                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                                print(dataString)
            }, failure: { error in
                print(error)
        })
    }
    
    
    
    //THIS IS WHAT I WANT.
    // MARK: Google
    func doOAuthGoogle(serviceParameters: [String:String]){
        let oauthswift = OAuth2Swift(
            consumerKey:    serviceParameters["consumerKey"]!,
            consumerSecret: serviceParameters["consumerSecret"]!,
            authorizeUrl:   "https://accounts.google.com/o/oauth2/auth",
            accessTokenUrl: "https://accounts.google.com/o/oauth2/token",
            responseType:   "code"
        )
        // For googgle the redirect_uri should match your this syntax: your.bundle.id:/oauth2Callback
        self.oauthswift = oauthswift
        oauthswift.authorize_url_handler = get_url_handler()
        // in plist define a url schem with: your.bundle.id:
        oauthswift.authorizeWithCallbackURL( NSURL(string: "http://www.google.co.uk")!, scope: "https://www.googleapis.com/auth/youtube.upload", state: "", success: {
            credential, response, parameters in
            self.showTokenAlert(serviceParameters["name"], credential: credential)
            let parameters =  Dictionary<String, AnyObject>()
            // Multi-part upload
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
            }, failure: { error in
                print("ERROR: \(error.localizedDescription)")
        })
    }
}

let services = Services()
let DocumentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
let FileManager: NSFileManager = NSFileManager.defaultManager()

extension OAuthController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load config from files
        initConf()
        
        // init now web view handler
        internalWebViewController.webView
        
        #if os(iOS)
            self.navigationItem.title = "OAuth"
            let tableView: UITableView = UITableView(frame: self.view.bounds, style: .Plain)
            tableView.delegate = self
            tableView.dataSource = self
            self.view.addSubview(tableView)
        #endif
    }
    
    // MARK: utility methods
    
    var confPath: String {
        let appPath = "\(DocumentDirectory)/.oauth/"
        if !FileManager.fileExistsAtPath(appPath) {
            do {
                try FileManager.createDirectoryAtPath(appPath, withIntermediateDirectories: false, attributes: nil)
            }catch {
                print("Failed to create \(appPath)")
            }
        }
        return "\(appPath)Services.plist"
    }
    
    func initConf() {
        initConfOld()
        print("Load configuration from \n\(self.confPath)")
        
        // Load config from model file
        if let path = NSBundle.mainBundle().pathForResource("Services", ofType: "plist") {
            services.loadFromFile(path)
            
            if !FileManager.fileExistsAtPath(confPath) {
                do {
                    try FileManager.copyItemAtPath(path, toPath: confPath)
                }catch {
                    print("Failed to copy empty conf to\(confPath)")
                }
            }
        }
        services.loadFromFile(confPath)
    }
    
    func initConfOld() { // TODO Must be removed later
        services["Twitter"] = Twitter
        services["Salesforce"] = Salesforce
        services["Flickr"] = Flickr
        services["Github"] = Github
        services["Instagram"] = Instagram
        services["Foursquare"] = Foursquare
        services["Fitbit"] = Fitbit
        services["Withings"] = Withings
        services["Linkedin"] = Linkedin
        services["Linkedin2"] = Linkedin2
        services["Dropbox"] = Dropbox
        services["Dribbble"] = Dribbble
        services["BitBucket"] = BitBucket
        services["GoogleDrive"] = GoogleDrive
        services["Smugmug "] =  Smugmug
        services["Intuit"] = Intuit
        services["Zaim"] = Zaim
        services["Tumblr"] = Tumblr
        services["Slack"] = Slack
        services["Uber"] = Uber
    }
    
    func snapshot() -> NSData {
        #if os(iOS)
            UIGraphicsBeginImageContext(self.view.frame.size)
            self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let fullScreenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            UIImageWriteToSavedPhotosAlbum(fullScreenshot, nil, nil, nil)
            return  UIImageJPEGRepresentation(fullScreenshot, 0.5)!
        #elseif os(OSX)
            let rep: NSBitmapImageRep = self.view.bitmapImageRepForCachingDisplayInRect(self.view.bounds)!
            self.view.cacheDisplayInRect(self.view.bounds, toBitmapImageRep:rep)
            return rep.TIFFRepresentation!
        #endif
    }
    
    func showAlertView(title: String, message: String) {
        #if os(iOS)
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        #elseif os(OSX)
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = message
            alert.addButtonWithTitle("Close")
            alert.runModal()
        #endif
    }
    
    func showTokenAlert(name: String?, credential: OAuthSwiftCredential) {
        var message = "oauth_token:\(credential.oauth_token)"
        if !credential.oauth_token_secret.isEmpty {
            message += "\n\noauth_toke_secret:\(credential.oauth_token_secret)"
        }
        self.showAlertView(name ?? "Service", message: message)
        
        if let service = name {
            services.updateService(service, dico: ["authentified":"1"])
            // TODO refresh graphic
        }
    }
    
    // MARK: handler
    
    func get_url_handler() -> OAuthSwiftURLHandlerType {
        guard let type = self.formData.data?.handlerType else {
            return OAuthSwiftOpenURLExternally.sharedInstance
        }
        switch type {
        case .External :
            return OAuthSwiftOpenURLExternally.sharedInstance
        case .Internal:
            let url_handler = internalWebViewController
            self.addChildViewController(url_handler) // allow WebViewController to use this ViewController as parent to be presented
            return url_handler
        case .Safari:
            #if os(iOS)
                if #available(iOS 9.0, *) {
                    let handler = SafariURLHandler(viewController: self, oauthSwift: self.oauthswift!)
                    handler.presentCompletion = {
                        print("Safari presented")
                    }
                    handler.dismissCompletion = {
                        print("Safari dismissed")
                    }
                    return handler
                }
            #endif
            return OAuthSwiftOpenURLExternally.sharedInstance
        }
        
        #if os(OSX)
            // a better way is
            // - to make this ViewController implement OAuthSwiftURLHandlerType and assigned in oauthswift object
            /* return self */
            // - have an instance of WebViewController here (I) or a segue name to launch (S)
            // - in handle(url)
            //    (I) : affect url to WebViewController, and  self.presentViewControllerAsModalWindow(self.webViewController)
            //    (S) : affect url to a temp variable (ex: urlForWebView), then perform segue
            /* performSegueWithIdentifier("oauthwebview", sender:nil) */
            //         then override prepareForSegue() to affect url to destination controller WebViewController
            
        #endif
    }
    //(I)
    //let webViewController: WebViewController = internalWebViewController
    //(S)
    //var urlForWebView:?NSURL = nil
    
    
    override func prepareForSegue(segue: OAuthStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboards.Main.FormSegue {
            #if os(OSX)
                let controller = segue.destinationController as? FormViewController
            #else
                let controller = segue.destinationViewController as? FormViewController
            #endif
            // Fill the controller
            if let controller = controller {
                controller.delegate = self
            }
        }
        
        super.prepareForSegue(segue, sender: sender)
    }
    
    // Little class to dispatch async (could use framework like Eki or swift 3 DispatchQueue)
    enum Queue {
        case Main, Background
        
        var queue: dispatch_queue_t {
            switch self {
            case .Main:
                return dispatch_get_main_queue()
            case .Background:
                return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
            }
        }
        func async(block: () -> Void) {
            dispatch_async(self.queue) {
                block()
            }
        }
    }
    
}

// MARK: - Table

#if os(iOS)
    extension OAuthController: UITableViewDelegate, UITableViewDataSource {
        // MARK: UITableViewDataSource
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return services.keys.count
        }
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
            let service = services.keys[indexPath.row]
            cell.textLabel?.text = service
            
            if let parameters = services[service] where Services.parametersEmpty(parameters) {
                cell.textLabel?.textColor = UIColor.redColor()
            }
            if let parameters = services[service], authentified = parameters["authentified"] where authentified == "1" {
                cell.textLabel?.textColor = UIColor.greenColor()
            }
            return cell
        }
        
        // MARK: UITableViewDelegate
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
            let service: String = services.keys[indexPath.row]
            
            Queue.Background.async {
                self.doAuthService(service)
            }
            tableView.deselectRowAtIndexPath(indexPath, animated:true)
        }
    }
#elseif os(OSX)
    
#endif

struct FormViewControllerData {
    var key: String
    var secret: String
    var handlerType: URLHandlerType
}

extension OAuthController: FormViewControllerDelegate {
    
    var key: String? { return self.currentParameters["consumerKey"] }
    var secret: String? {return self.currentParameters["consumerSecret"] }
    
    func didValidate(key: String?, secret: String?, handlerType: URLHandlerType) {
        self.dismissForm()
        
        self.formData.publish(FormViewControllerData(key: key ?? "", secret: secret ?? "", handlerType: handlerType))
    }
    
    func didCancel() {
        self.dismissForm()
        
        self.formData.cancel()
    }
    
    func dismissForm() {
        #if os(iOS)
            /*self.dismissViewControllerAnimated(true) { // without animation controller
             print("form dismissed")
             }*/
            self.navigationController?.popViewControllerAnimated(true)
        #endif
    }
}

// Little utility class to wait on data
class Semaphore<T> {
    let segueSemaphore = dispatch_semaphore_create(0)
    var data: T?
    
    func waitData(timeout: dispatch_time_t = DISPATCH_TIME_FOREVER) -> T? {
        dispatch_semaphore_wait(segueSemaphore, timeout) // wait user
        return data
    }
    
    func publish(data: T) {
        self.data = data
        dispatch_semaphore_signal(segueSemaphore)
    }
    
    func cancel() {
        dispatch_semaphore_signal(segueSemaphore)
    }
}


