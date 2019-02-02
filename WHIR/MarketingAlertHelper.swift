//
//  UserDefaultsManager.swift
//  WHIR
//
//  Created by Bruce Röttgers on 29.05.18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

struct MarketingAlertHelper {

    // Instance of UserDefaults
    // UserDefaults stores data as long as the app is installed
    let defaults = UserDefaults.standard

    // When called tries to display rating and donation prompt
    // should be called at every action -- like new entry -- and will upper an count
    // to assure the app doesn't prompt to much.
    // viewController: the viewController it's called from
    // countMax: after how many actions it should prompt, optional
    func tryToDisplayPrompts(with viewController: UIViewController, showAt countMax: Int = 3) {
        //the current count
        let current = defaults.integer(forKey: "PromptCount")
        // User can say he doesn't want the prompts to be shown again
        let shouldNotShow = defaults.bool(forKey: "NotShowAgain")

        // first of all, upper the counter by one
        defaults.set(current + 1, forKey: "PromptCount")

        // Check if it should show prompts...
        if current == countMax {
            if !shouldNotShow {

                // Success, show prompts...

                // --> Show Review Alert (if Apple approves)
                SKStoreReviewController.requestReview()

                // --> Show Donation Alert
                // implement later
                /*
                let alert = UIAlertController(title: "Donate", message: "Hey, you seem to be enjoying this app! I'd be glad if you'd like to donate and support the development. This is voluntary and will add no new features to this app. If you want you can donate at anytime in the info screen.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Donate $1 or equivalent", style: .default) { action in
                    
                    IAPHelper().donate(alertIn: viewController)
                    
                    // dismiss alert
                    alert.dismiss(animated: true, completion: nil)
                    
                })
                viewController.present(alert, animated: true, completion: nil)
                // dismiss alert
                alert.addAction(UIAlertAction(title: "No", style: .cancel) { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                })
            */
            }

            // Reset the counter back to 0 and start therefore its loop from the beginning
            defaults.set(0, forKey: "PromptCount")
        }
    }
    
}
