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

            let output = AVCaptureMetadataOutput()
            viewport.videoSession?.addOutput(output)
            output.setMetadataObjectsDelegate(self,
                                              queue: DispatchQueue(
                                                label: "dirkhulverscheidt.WHIR.scanningQueue",
                                                qos: .userInteractive,
                                                attributes: .concurrent,
                                                autoreleaseFrequency: .workItem,
                                                target: DispatchQueue.global()))
            output.metadataObjectTypes = [.ean13]
        }
    }

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!

    @IBAction func cancelScanning(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func openSettings() {
        guard let settings = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settings, options: [:], completionHandler: nil)
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
        var errorLabelText: String?
        var shouldHideSettingsButton = false
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            viewport.isHidden = false
            viewport.videoSession?.startRunning()
        case .restricted:
            // TODO: Localize these messages
            errorLabelText = "Camera access has been restricted on this device by a parent or MDM administrator"
            shouldHideSettingsButton = true
            fallthrough
        case .denied:
            errorLabelText = errorLabelText ?? "You must grant WHIR camera access to scan barcodes"
            errorLabel.text = errorLabelText
            settingsButton.isHidden = shouldHideSettingsButton
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

extension BarcodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for object in metadataObjects {
            print(object)
        }
    }
}
