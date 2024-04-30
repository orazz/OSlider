//
//  OSlider+Actions.swift
//  OSlider
//
//  Created by Oraz Atakishiyev on 4/25/24.
//

import UIKit

extension OSlider {
    
    @objc internal func actionPanGesture(sender: UIPanGestureRecognizer) {
        let state = sender.state
        if state == .began {
            isSliderTracking = true
        } else if state == .ended {
            isSliderTracking = false
        }
        let touchPoint = sender.location(in: self)
        let value = (maximumValue - minimumValue) * Float(touchPoint.x / frame.size.width)
        self.value = value
        updateTrackLayer(value: value)
        sendActions(for: .valueChanged)
    }
    
    /// move thumb immediately to tap position
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSliderTracking = true
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        let value = (maximumValue - minimumValue) * Float(touchPoint.x / frame.size.width)
        self.value = value
        updateTrackLayer(value: value)
        sendActions(for: .valueChanged)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSliderTracking = false
        sendActions(for: .valueChanged)
        super.touchesEnded(touches, with: event)
    }
    
    /// update track layer
    @objc internal func valueChanged(_ sender: UKSlider) {
        updateTrackLayer(value: sender.value)
    }

}
