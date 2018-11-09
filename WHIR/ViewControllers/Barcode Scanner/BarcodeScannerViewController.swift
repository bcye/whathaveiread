//
//  BarcodeScannerViewController.swift
//  WHIR
//
//  Created by Michael Hulet on 11/1/18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import UIKit
import AVFoundation

protocol ISBNScannerDelegate: class {
    func scanner(_ scanner: BarcodeScannerViewController, didCaptureISBN isbn: String)
}

class BarcodeScannerViewController: UIViewController {

    @IBOutlet weak var viewport: CameraView! {
        didSet {
            startScanning()
        }
    }

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!

    private(set) var isScanning = false
    private var shouldStopDeliveringISBNCodes = false

    @IBAction func cancelScanning(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func openSettings() {
        guard let settings = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settings, options: [:], completionHandler: nil)
    }

    weak var delegate: ISBNScannerDelegate?

    func startScanning() {
        guard !isScanning else {
            return
        }
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

        setTorch(to: .on)

        isScanning = true
    }

    func stopScanning() {
        guard isScanning else {
            return
        }

        DispatchQueue.main.async {
            self.viewport.videoSession?.stopRunning()
            self.setTorch(to: .off)
            self.isScanning = false
        }
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

    static func isValid(isbn barcodeEncodedValue: String) -> Bool {
        // ISBN checking algorithms found here: https://en.wikipedia.org/wiki/International_Standard_Book_Number#Check_digits

        let encodedDigits = Array(barcodeEncodedValue).compactMap { (digit: Character) -> Int? in
            return Int(String(digit))
        }

        guard encodedDigits.count == 13, let checkDigit = encodedDigits.last else { // An ISBN barcode is 13 digits long
            return false
        }

        // ISBN-10

        let possibleISBN10 = encodedDigits[3..<encodedDigits.count - 1]

        guard possibleISBN10.count == 9 else { // If it's not 9, something went wrong, and it isn't a valid ISBN
            return false
        }

        var total = 0
        var weight = 10

        for digit in possibleISBN10 {
            total += digit * weight
            weight -= 1
        }

        guard (total + checkDigit) % 11 != 0 else { // If this succeeds, it's a valid ISBN-10
            return true
        }

        // If not, we'll check if it's an ISBN-13

        total = 0

        for (index, digit) in encodedDigits[0..<encodedDigits.count - 1].enumerated() {
            total += digit * (index % 2 == 0 ? 1 : 3)
        }

        let modulus = total % 10

        return modulus == checkDigit // If this succeeds, it's valid. If not, it's invalid
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

    private func setTorch(to mode: AVCaptureDevice.TorchMode) {
        guard
            let camera = viewport.camera,
            camera.hasTorch,
            camera.isTorchModeSupported(mode) else {
                return
        }

        DispatchQueue.main.async {
            do {
                try camera.lockForConfiguration()
                if case .on = mode {
                    try camera.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
                } else {
                    camera.torchMode = .off
                }
                camera.unlockForConfiguration()
            } catch {}
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
            guard let isbnObject = object as? AVMetadataMachineReadableCodeObject, let isbn = isbnObject.stringValue, BarcodeScannerViewController.isValid(isbn: isbn) else {
                print("Recognized barcode, but was invalid")
                continue
            }
            guard !shouldStopDeliveringISBNCodes else {
                shouldStopDeliveringISBNCodes = false
                return
            }
            delegate?.scanner(self, didCaptureISBN: isbn)
        }
    }
}
