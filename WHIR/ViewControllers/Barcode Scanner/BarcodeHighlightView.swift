//
//  OutlineView.swift
//  WHIR
//
//  Created by Michael Hulet on 11/9/18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import UIKit

class BarcodeHighlightView: UIView {

    private typealias LayerType = CAShapeLayer

    override class var layerClass: AnyClass {
        return LayerType.self
    }

    var color: UIColor {
        get {
            guard let stroke = (layer as? LayerType)?.strokeColor else {
                return .clear
            }
            return UIColor(cgColor: stroke)
        }
        set {
            guard let renderingBuffer = layer as? LayerType else {
                return
            }
            renderingBuffer.strokeColor = newValue.cgColor
            renderingBuffer.fillColor = newValue.cgColor
        }
    }

    var corners: [CGPoint]? {
        didSet {
            guard let points = corners, let firstPoint = points.first else {
                return
            }

            let path = UIBezierPath()
            path.move(to: firstPoint)

            for point in points[1...] {
                path.addLine(to: point)
            }
            path.addLine(to: firstPoint)

            (layer as? LayerType)?.path = path.cgPath
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let renderingLayer = layer as? LayerType else {
            return
        }

        renderingLayer.fillColor = UIColor.red.cgColor
        renderingLayer.lineWidth = 1
    }
}
