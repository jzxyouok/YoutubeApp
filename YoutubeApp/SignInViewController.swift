//
//  SignInViewController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 27/06/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//
//test

import UIKit
import GoogleAPIClientForREST
import GTMOAuth2

class SignInViewController: UIViewController {
    
    
    @IBAction func signInButtonPressed(sender: UIButton) {
        presentViewController(
            createAuthController(),
            animated: true,
            completion: nil
        )
    }
    
    // Change Bundle Identifier for this client ID in Google Developer Console.
    private let kKeychainItemName = "YouTube Data API"
    private let kClientID = "192877572614-k4ljl168palm9oq5skbgonsagf17t20h.apps.googleusercontent.com"
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeYouTubeUpload, kGTLRAuthScopeYouTube]
    
    let service = GTLRYouTubeService()
    
    var contentViewController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
            service.shouldFetchNextPages = false
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if userDefaults.objectForKey("InterestsArray") as? [String] == nil || userDefaults.objectForKey("SkillsArray") as? [String] == nil {
                let vc : InterestsViewController = storyboard.instantiateViewControllerWithIdentifier("InterestsViewController") as! InterestsViewController
                vc.model.service=self.service
                contentViewController = UINavigationController(rootViewController: vc)
                self.presentViewController(contentViewController, animated: true, completion: nil)
            } else if userDefaults.objectForKey("InterestsArray") as? [String] != nil && userDefaults.objectForKey("SkillsArray") as? [String] != nil {
                let tbc: UITabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
                (((tbc.viewControllers![1] as! UINavigationController).viewControllers[0]) as! SavedVideosViewController).model.service=self.service
                self.presentViewController(tbc, animated: true, completion: nil)
            }
        } else {
            
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "idSegueContent" {
            contentViewController = segue.destinationViewController as! UINavigationController
        }
    }
    
    // Creates the auth controller for authorizing access to Gmail API
    private func createAuthController() -> GTMOAuth2ViewControllerTouch {
        let scopeString = scopes.joinWithSeparator(" ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: "viewController:finishedWithAuth:error:"
        )
        
    }
    
    // Handle completion of the authorization process, and update the Gmail API
    // with the new credentials.
    func viewController(vc : UIViewController,
                        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        
        if let error = error {
            service.authorizer = nil
            showAlert("Authentication Error", message: error.localizedDescription)
            return
        }
        
        service.authorizer = authResult
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.Default,
            handler: nil
        )
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}