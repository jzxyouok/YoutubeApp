//
//  UpgradeManager.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 10/11/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import Foundation
import StoreKit

class UpgradeManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let sharedInstance = UpgradeManager()
    let productIdentifier = "pranav.kasetti.YoutubeApp.premiumupgrade"
    typealias SuccessHandler = (_ succeeded: Bool) -> (Void)
    var upgradeCompletionHandler: SuccessHandler?
    var restoreCompletionHandler: SuccessHandler?
    var priceCompletionHandler: ((_ price: Float) -> Void)?
    var premiumProduct: SKProduct?
    let userDefaultsKey = "HasUpgradedUserDefaultsKey"
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func hasUpgraded() -> Bool {
        return UserDefaults.standard.bool(forKey: userDefaultsKey)
    }
    
    func upgrade(_ success: @escaping SuccessHandler) {
        upgradeCompletionHandler = success
        
        if let product = premiumProduct {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func restorePurchases(_ success: @escaping SuccessHandler) {
        restoreCompletionHandler = success
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func priceForUpgrade(_ success: @escaping (_ price: Float) -> Void) {
        success(0.0)
        priceCompletionHandler = success
        
        let identifiers: Set<String> = [productIdentifier]
        let request = SKProductsRequest(productIdentifiers: identifiers)
        request.delegate = self
        request.start()
    }
    
    // MARK: SKPaymentTransactionObserver
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                UserDefaults.standard.set(true, forKey: userDefaultsKey)
                upgradeCompletionHandler?(true)
            case .restored:
                UserDefaults.standard.set(true, forKey: userDefaultsKey)
                restoreCompletionHandler?(true)
            case .failed:
                upgradeCompletionHandler?(false)
            default:
                return
            }
            
            SKPaymentQueue.default().finishTransaction(transaction)
        }
    }
    
    // MARK: SKProductsRequestDelegate
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        premiumProduct = response.products.first
        
        if let price = premiumProduct?.price {
            priceCompletionHandler?(Float(price))
        }
    }
}

