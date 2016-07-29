//
//  SignInViewController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 27/06/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    var contentViewController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().clientID = "21692400266-02t1t9b098td61alhete3e31csu5o0a2.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
        
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "idSegueContent" {
            contentViewController = segue.destinationViewController as! UINavigationController
        }
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if error != nil {
            print(error)
        }
        else {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : InterestsViewController = storyboard.instantiateViewControllerWithIdentifier("InterestsViewController") as! InterestsViewController
            contentViewController = UINavigationController(rootViewController: vc)
            self.presentViewController(contentViewController, animated: true, completion: nil)
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        if error != nil {
            print(error)
        } else {
            
            contentViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

