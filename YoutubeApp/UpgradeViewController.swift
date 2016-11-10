//
//  UpgradeViewController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 10/11/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit

class UpgradeViewController: UIViewController {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        UpgradeManager.sharedInstance.priceForUpgrade { (price) in
            self.priceLabel.text = "£\(price)"
            self.upgradeButton.isEnabled = true
            self.restoreButton.isEnabled = true
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func upgradeButtonTapped(_ sender: AnyObject) {
        UpgradeManager.sharedInstance.upgrade { (succeeded) -> (Void) in
            if succeeded {
                let alertController = UIAlertController(title: "Upgraded!", message: "Thanks for upgrading. You can now access all premium features.", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "Done", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                
                alertController.addAction(doneAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func restorePurchasesButtonTapped(_ sender: AnyObject) {
        UpgradeManager.sharedInstance.restorePurchases { (succeeded) -> (Void) in
            if succeeded {
                let alertController = UIAlertController(title: "Restored!", message: "Your purchases have been restored. You can now access all premium features.", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "Done", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                
                alertController.addAction(doneAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
