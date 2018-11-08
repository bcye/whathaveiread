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
            viewport.delegate = self
        }
    }

    @IBAction func cancelScanning(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if case .notDetermined = AVCaptureDevice.authorizationStatus(for: .video) {
            AVCaptureDevice.requestAccess(for: .video) { (_) in
                self.layoutForCurrentVideoAccess()
            }
        } else {
            layoutForCurrentVideoAccess()
        }
    }

    private func layoutForCurrentVideoAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            viewport.isHidden = false
            viewport.videoSession?.startRunning()
        case .denied, .restricted:
            viewport.isHidden = true
            viewport.videoSession?.stopRunning()
        default:
            return
        }
    }
}

extension BarcodeScannerViewController: CameraViewDelegate {
    func cameraView(_ cameraView: CameraView, didFailWithError error: CameraError) {
        switch error {
        case .accessDenied, .restricted:
            layoutForCurrentVideoAccess()
        case .unknown:
            break // TODO: Display error on default label
        }
    }
}
