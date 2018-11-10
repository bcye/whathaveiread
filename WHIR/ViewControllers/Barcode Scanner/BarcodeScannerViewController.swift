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
        guard case .authorized = AVCaptureDevice.authorizationStatus(for: .video), !isScanning else {
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

        guard encodedDigits[0] == 9, encodedDigits[1] == 7, encodedDigits[2] == 8 || encodedDigits[2] == 9 else { // ISBNs are prefixed with 978 or 979
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

        let range = encodedDigits[0..<encodedDigits.count - 1]
        for (index, digit) in range.enumerated() {
            let factor = index % 2 == 0 ? 1 : 3
            total += digit * factor
        }

        let modulus = total % 10
        return modulus == 0 ? checkDigit == 0 : 10 - modulus == checkDigit // If this succeeds, it's valid. If not, it's invalid
    }

    private func layoutForCurrentVideoAccess() {
        var errorLabelText: String?
        var shouldHideSettingsButton = false
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            viewport.isHidden = false
            viewport.videoSession?.startRunning()
        case .restricted:
            errorLabelText = NSLocalizedString("errorCameraAccessRestricted", value: "Camera access has been restricted on this device by a parent or MDM administrator", comment: "Camera restricted")
            shouldHideSettingsButton = true
            fallthrough
        case .denied:
            errorLabelText = errorLabelText ?? NSLocalizedString("errorCameraAccessDenied", value: "You must grant WHIR camera access to scan barcodes", comment: "Camera denied")
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
            errorLabel.text = error.localizedDescription
            settingsButton.isHidden = true
        }
    }
}

extension BarcodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        DispatchQueue.main.async {
            for subview in self.view.subviews where subview is BarcodeHighlightView {
                subview.removeFromSuperview()
            }
        }

        for object in metadataObjects {
            guard let isbnObject = object as? AVMetadataMachineReadableCodeObject, let isbn = isbnObject.stringValue else {
                continue
            }

            let isValidCode = BarcodeScannerViewController.isValid(isbn: isbn)

            DispatchQueue.main.async {
                if
                    let videoLayer = self.viewport.layer as? AVCaptureVideoPreviewLayer,
                    let transformed = videoLayer.transformedMetadataObject(for: object) as? AVMetadataMachineReadableCodeObject {
                    let outline = BarcodeHighlightView(frame: transformed.bounds)
                    outline.corners = transformed.corners.map({ (point: CGPoint) -> CGPoint in
                        return self.view.convert(point, to: outline)
                    })
                    outline.color = isValidCode ? .green : .red
                    self.view.addSubview(outline)
                }
            }

            guard isValidCode else {
                return
            }

            guard !shouldStopDeliveringISBNCodes else {
                shouldStopDeliveringISBNCodes = false
                return
            }
            delegate?.scanner(self, didCaptureISBN: isbn)
        }
    }
}
