//
//  CameraView.swift
//  WHIR
//
//  Created by Michael Hulet on 11/2/18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraViewDelegate: class {
    func cameraView(_ cameraView: CameraView, didFailWithError error: CameraError)
}

enum CameraError: Error {
    case restricted
    case accessDenied
    case unknown(underlyingError: Error?)

    var localizedDescription: String {
        switch self {
        case .restricted:
            return "Camera access has been restricted on this device by a parent or MDM administrator"
        case .accessDenied:
            return "You have denied WHIR access to your device's camera, but you must enable it to use this feature"
        case .unknown:
            return "WHIR cannot access the camera for an unknown reason"
        }
    }
}

class CameraView: UIView {

    weak var delegate: CameraViewDelegate?

    let mediaType = AVMediaType.video

    private typealias RenderingLayerClass = AVCaptureVideoPreviewLayer
    override class var layerClass: AnyClass {
        return RenderingLayerClass.self
    }

    var videoSession: AVCaptureSession? {
        get {
            return (layer as? RenderingLayerClass)?.session
        }
        set {
            (layer as? RenderingLayerClass)?.session = newValue

            if let session = newValue, let camera = AVCaptureDevice.default(for: mediaType) {
                do {
                    let input = try AVCaptureDeviceInput(device: camera)

                    session.beginConfiguration()
                    for oldInput in session.inputs {
                        session.removeInput(oldInput)
                    }
                    session.addInput(input)

                    session.commitConfiguration()
                } catch let error as NSError where error.code == -11852 {
                    delegate?.cameraView(self, didFailWithError: .accessDenied)
                } catch {
                    delegate?.cameraView(self, didFailWithError: .unknown(underlyingError: error))
                }
            } else if case .restricted = AVCaptureDevice.authorizationStatus(for: mediaType), newValue != nil {
                delegate?.cameraView(self, didFailWithError: .restricted)
            } else if newValue != nil {
                delegate?.cameraView(self, didFailWithError: .unknown(underlyingError: nil))
            }
        }
    }

    init(videoSession: AVCaptureSession, frame: CGRect = .zero) {
        super.init(frame: frame)
        (layer as? RenderingLayerClass)?.session = videoSession
        instantiate()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        videoSession = aDecoder.decodeObject(forKey: "videoSession") as? AVCaptureSession
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        instantiate()
    }

    private func instantiate() {
        guard let renderingLayer = layer as? RenderingLayerClass else {
            return
        }
        renderingLayer.videoGravity = .resizeAspect
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let connection = (layer as? RenderingLayerClass)?.connection else {
            return
        }

        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .unknown:
            connection.videoOrientation = .portrait
        case .portraitUpsideDown:
            connection.videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            connection.videoOrientation = .landscapeLeft
        case .landscapeRight:
            connection.videoOrientation = .landscapeRight
        }
    }
}
