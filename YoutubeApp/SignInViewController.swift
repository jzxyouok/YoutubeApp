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
    
    var checked: Int = 0
    
    @IBOutlet weak var googleSignInButton: UIButton!
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        self.navigationController!.pushViewController(createAuthController(), animated: true)
    }
    
    @IBAction func signInGuestPressed(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "InterestsArray") as? [NSString] == nil || userDefaults.object(forKey: "SkillsArray") as? [NSString] == nil {
            let vc : InterestsViewController = storyboard.instantiateViewController(withIdentifier: "InterestsViewController") as! InterestsViewController
            vc.model.service=self.service
            contentViewController = UINavigationController(rootViewController: vc)
            self.present(contentViewController, animated: true, completion: nil)
        } else if userDefaults.object(forKey: "InterestsArray") as? [NSString] != nil && userDefaults.object(forKey: "SkillsArray") as? [NSString] != nil {
            let tbc: UITabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            (((tbc.viewControllers![1] as! UINavigationController).viewControllers[0]) as! SavedVideosViewController).model.service=self.service
            self.present(tbc, animated: true, completion: nil)
        }
    }
    // Change Bundle Identifier for this client ID in Google Developer Console.
    fileprivate let kKeychainItemName = "YouTube Data API"
    fileprivate let kClientID = "192877572614-k4ljl168palm9oq5skbgonsagf17t20h.apps.googleusercontent.com"
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    fileprivate let scopes = [kGTLRAuthScopeYouTubeUpload, kGTLRAuthScopeYouTube]
    
    let service = GTLRYouTubeService()
    
    var contentViewController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychain(
            forName: kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
            service.shouldFetchNextPages = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let userDefaults = UserDefaults.standard
        if let authorizer = service.authorizer,
            let canAuth = authorizer.canAuthorize , canAuth {
            if userDefaults.object(forKey: "InterestsArray") as? [NSString] == nil || userDefaults.object(forKey: "SkillsArray") as? [NSString] == nil {
                let vc : InterestsViewController = storyboard.instantiateViewController(withIdentifier: "InterestsViewController") as! InterestsViewController
                vc.model.service=self.service
                contentViewController = UINavigationController(rootViewController: vc)
                self.present(contentViewController, animated: true, completion: nil)
            } else if userDefaults.object(forKey: "InterestsArray") as? [NSString] != nil && userDefaults.object(forKey: "SkillsArray") as? [String] != nil {
                let tbc: UITabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                (((tbc.viewControllers![1] as! UINavigationController).viewControllers[0]) as! SavedVideosViewController).model.service=self.service
                self.present(tbc, animated: true, completion: nil)
            }
        } else if userDefaults.object(forKey: "InterestsArray") as? [NSString] != nil && userDefaults.object(forKey: "SkillsArray") as? [String] != nil && checked==0 {
            let tbc: UITabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            (((tbc.viewControllers![1] as! UINavigationController).viewControllers[0]) as! SavedVideosViewController).model.service=self.service
            self.present(tbc, animated: true, completion: nil)
        } else if userDefaults.object(forKey: "InterestsArray") as? [NSString] != nil && userDefaults.object(forKey: "SkillsArray") as? [String] != nil && checked==1 {
            self.signInButtonPressed(self.googleSignInButton)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "idSegueContent" {
            contentViewController = segue.destination as! UINavigationController
        }
    }
    
    // Creates the auth controller for authorizing access to Gmail API
    fileprivate func createAuthController() -> GTMOAuth2ViewControllerTouch {
        let scopeString = scopes.joined(separator: " ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: #selector(SignInViewController.viewController(_:finishedWithAuth:error:))
        )
        
    }
    
    // Handle completion of the authorization process, and update the Gmail API
    // with the new credentials.
    func viewController(_ vc : UIViewController,
                        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        
        if let error = error {
            service.authorizer = nil
            showAlert("Authentication Error", message: error.localizedDescription)
            return
        }
        
        service.authorizer = authResult
        dismiss(animated: true, completion: nil)
    }
    
    // Helper for showing an alert
    func showAlert(_ title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
