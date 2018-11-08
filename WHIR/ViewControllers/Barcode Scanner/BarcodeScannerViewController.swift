//
//  BarcodeScannerViewController.swift
//  WHIR
//
//  Created by Michael Hulet on 11/1/18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeScannerViewController: UIViewController {

    @IBOutlet weak var viewport: CameraView! {
        didSet {
            viewport.videoSession = AVCaptureSession()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if case .notDetermined = AVCaptureDevice.authorizationStatus(for: viewport.mediaType) {
            AVCaptureDevice.requestAccess(for: viewport.mediaType) { (_) in
                self.layoutForCurrentVideoAccess()
            }
        } else {
            layoutForCurrentVideoAccess()
        }
    }

    private func layoutForCurrentVideoAccess() {
        switch AVCaptureDevice.authorizationStatus(for: viewport.mediaType) {
        case .authorized:
            viewport.isHidden = false
            viewport.videoSession?.startRunning()
        case .denied, .restricted:
            viewport.isHidden = true
        default:
            return
        }
    }
}
