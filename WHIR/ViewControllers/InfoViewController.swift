//
//  InfoViewController.swift
//  WHIR
//
//  Created by Bruce Röttgers on 04.04.18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var infoTextView: UITextView!
    @IBAction func okDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        infoTextView.text = NSLocalizedString("attributionText", comment: "Handcrafted by © 2018 Bruce Röttgers\n\nLogo by Zlatko Najdenovski on Flaticon. Licensed under the Flaticon Basic License (https://www.flaticon.com/authors/zlatko-najdenovski).\n Barcode icon made by Pixel perfect on Flaticon (https://www.flaticon.com/free-icon/barcode_726558). \nUsing CocoaPod KMPlaceholderTextView by MoZhouqi (https://github.com/MoZhouqi/KMPlaceholderTextView). Licensed under the MIT license.\n\nThanks for reading and using this App ❤.\n\nFeel free to contact me on my support email (can be found on the App Store page), if you find bugs or just to say hello. (br.apps@icloud.com)")
    }
}
