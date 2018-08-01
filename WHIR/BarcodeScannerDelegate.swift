//
//  BarcodeScannerDelegate.swift
//  WHIR
//
//  Created by Bruce Röttgers on 01.08.18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import Foundation
import BarcodeScanner


class BarcodeScannerDelegate: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        // FIXME: pass code to Google Books, etc.
        print(code)
        print(type)
        controller.reset()
        controller.dismiss(animated: true, completion: nil)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    init() {
        print("i was intialized")
    }
}
