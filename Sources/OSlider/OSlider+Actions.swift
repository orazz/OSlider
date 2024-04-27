//
//  OSlider+Actions.swift
//  OSlider
//
//  Created by Oraz Atakishiyev on 4/25/24.
//

import UIKit

extension OSlider {
    
    @objc internal func actionPanGesture(sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self)
        let value = (maximumValue - minimumValue) * Float(touchPoint.x / frame.size.width)
        self.value = value
        sendActions(for: .valueChanged)
        updateTrackLayer(value: value)
    }
    
    /// move thumb immediately to tap position
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        let value = (maximumValue - minimumValue) * Float(touchPoint.x / frame.size.width)
        self.value = value
        sendActions(for: .valueChanged)
        updateTrackLayer(value: value)
    }
    
    /// update track layer
    @objc internal func valueChanged(_ sender: UKSlider) {
        updateTrackLayer(value: value)
    }
}
