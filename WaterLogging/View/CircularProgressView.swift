//
//  CircularProgressView.swift
//  WaterLogging
//
//  Created by Jacob Bullock on 7/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {
    
    let progressBarLayer = CAShapeLayer()
    var currentProgress: Double = 0
    var progressColor: CGColor = UIColor.blue.cgColor {
        didSet {
            progressBarLayer.strokeColor = progressColor
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.2, delay: 0, options: [.curveLinear], animations: {
                self.progressBarLayer.strokeColor = self.progressColor
            })
        }
    }
    
    func removeAllSublayers() {
        layer.sublayers?.forEach { layer in
            layer.removeFromSuperlayer()
        }
    }

    override func layoutSubviews() {
        let radius = frame.size.width / 2
        
        guard radius > 0 else { return }
        
        removeAllSublayers()
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius),
                                        radius: radius,
                                        startAngle: -0.5 * CGFloat.pi,
                                        endAngle: 1.5 * CGFloat.pi,
                                        clockwise: true)
        
        let track = CAShapeLayer()
        track.path = circularPath.cgPath
        track.strokeColor = UIColor.lightGray.cgColor
        track.lineWidth = 20
        track.fillColor = UIColor.clear.cgColor
        track.lineCap = CAShapeLayerLineCap.round
        layer.addSublayer(track)
        
        progressBarLayer.path = circularPath.cgPath
        progressBarLayer.strokeColor = self.progressColor
        progressBarLayer.lineWidth = 20
        progressBarLayer.fillColor = UIColor.clear.cgColor
        progressBarLayer.lineCap = CAShapeLayerLineCap.round
        progressBarLayer.strokeEnd = 0
        
        layer.addSublayer(progressBarLayer)
    }
    
    func animate(to progress: Double) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = currentProgress
        animation.toValue = progress
        animation.duration = 1.5
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        progressBarLayer.add(animation, forKey: "progress")
        
        currentProgress = min(max(progress, 0), 1)
    }
}
