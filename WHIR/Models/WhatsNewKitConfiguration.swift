//
//  WhatsNewKitConfiguration.swift
//  WHIR
//
//  Created by Bruce Roettgers on 15.02.19.
//  Copyright © 2019 Dirk Hulverscheidt. All rights reserved.
//

import Foundation
import WhatsNewKit
import UIKit

class WhatsNewKitConfiguration {
    static let defaults = UserDefaults.standard
    
    static let whatsNew = WhatsNew(
        title: "New Features 🎉",
        items: [
            WhatsNew.Item(
                title: "Open Source",
                subtitle: "WHIR is now an actively maintained open source app. Contributions are very welcome!",
                image: UIImage(named: "github-logo")),
            WhatsNew.Item(title: "Updated View", subtitle: "We now display more information, like the book cover or description right inside the table view!", image: UIImage(named: "list"))
        ])
    
    static var config = WhatsNewViewController.Configuration(WhatsNewViewController.Theme.default)
    
    static func configure() {
        config.itemsView.layout = .centered
        config.itemsView.contentMode = .center
        config.apply(animation: .fade)
        
        let detailButton = WhatsNewViewController.DetailButton(
            title: "Read more",
            action: .website(url: "https://github.com/bcye/whathaveiread")
        )
        config.detailButton = detailButton
    }
    
    static let whatsNewController = WhatsNewViewController(whatsNew: whatsNew)
    
    static func presentFeatures(with vc: UIViewController) {
        if !defaults.bool(forKey: "versionPresented") {
            configure()
            vc.present(self.whatsNewController, animated: true, completion: nil)
            defaults.set(true, forKey: "versionPresented")
        }
    }
    
}
