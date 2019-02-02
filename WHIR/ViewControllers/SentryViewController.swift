//
//  SentryViewController.swift
//  WHIR
//
//  Created by Bruce Roettgers on 02.02.19.
//  Copyright © 2019 Dirk Hulverscheidt. All rights reserved.
//

import UIKit
import Sentry

class SentryViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func enableSentry(_ sender: Any) {
        // save preference
        defaults.set(true, forKey: "sentryEnabled")
        
        // enable sentry
        do {
            Client.shared = try Client(dsn: "https://0a96c698b97d45f4a2bca61da92725c6@sentry.io/1375024")
            try Client.shared?.startCrashHandler()
        } catch let error {
            print("\(error)")
        }
        
        // don't show this again
        defaults.set(true, forKey: "sentryAsked")
        
        //dismiss
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func disableSentry(_ sender: Any) {
        // save preference
        defaults.set(false, forKey: "sentryEnabled")

        // don't show this prompt again
        defaults.set(true, forKey: "sentryAsked")
        
        // dismiss
        self.dismiss(animated: true, completion: nil)
    }
}
