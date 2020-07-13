//
//  BannerNotificationView.swift
//  WaterLogging
//
//  Created by Jacob Bullock on 7/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class BannerNotificationView: UIView {

    private let label = UILabel()
    private var isActive = false
    private var fadeOutAnimator: UIViewPropertyAnimator?
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        alpha = 0
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate(
            [label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
             label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
             label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)] )
    }
    
    func flashSuccess(message: String) {
        label.text = message
        backgroundColor = .green
        flash()
    }
    
    func flashError(message: String) {
        label.text = message
        backgroundColor = .red
        flash()
    }
    
    private func flash() {
        if !isActive {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: 0, options: [.curveEaseOut], animations: {
                self.alpha = 1.0
            })
            isActive = true
        }

        scheduleFadeOut(delay: 3)
    }
    
    private func scheduleFadeOut(delay: TimeInterval) {
        fadeOutAnimator?.stopAnimation(true)
        fadeOutAnimator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: delay, options: [.curveLinear], animations: {
          self.alpha = 0.0
        }) { position in
            self.isActive = false
        }
    }

}
