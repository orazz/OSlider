//
//  OSliderControlView.swift
//  OSlider
//
//  Created by Oraz Atakishiyev on 4/25/24.
//

import SwiftUI
import CoreMedia
import Combine

public struct OSliderView: UIViewRepresentable {
    @Binding var value: Float
    @Binding var bufferValue: Float
    @Binding var isAnimating: Bool
    @Binding var hideThumb: Bool
    @Binding var isTracking: Bool
    
    var range: ClosedRange<Float>
    var lineHeight: CGFloat
    var baseTrackColor: Color?
    var defaultProgressColor: Color?
    var bufferProgressColor: Color?
    var backAnimationFromColor: Color?
    var backAnimationToColor: Color?
    
    var onEditingChanged: (Bool) -> Void
    
    public init(value: Binding<Float>, range: ClosedRange<Float>, bufferValue: Binding<Float> = .constant(0), isAnimating: Binding<Bool> = .constant(false), hideThumb: Binding<Bool> = .constant(false), lineHeight: CGFloat = 5, baseTrackColor: Color? = nil, defaultProgressColor: Color? = nil, bufferProgressColor: Color? = nil, backAnimationFromColor: Color? = nil, backAnimationToColor: Color? = nil, isTracking: Binding<Bool>, onEditingChanged: @escaping (Bool) -> Void) {
        self._value = value
        self._bufferValue = bufferValue
        self._isAnimating = isAnimating
        self._hideThumb = hideThumb
        self._isTracking = isTracking
        self.range = range
        self.lineHeight = lineHeight
        self.baseTrackColor = baseTrackColor
        self.defaultProgressColor = defaultProgressColor
        self.bufferProgressColor = bufferProgressColor
        self.backAnimationFromColor = backAnimationFromColor
        self.backAnimationToColor = backAnimationToColor
        
        self.onEditingChanged = onEditingChanged
    }
    
    public func makeUIView(context: Context) -> OSlider {
        let slider = OSlider()
        slider.value = value
        slider.bufferValue = bufferValue
        slider.lineHeight = lineHeight
        slider.hideThumb = hideThumb
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        setProperty(&slider.baseTrackColor, ifPresent: baseTrackColor)
        setProperty(&slider.defaultProgressColor, ifPresent: defaultProgressColor)
        setProperty(&slider.bufferProgressColor, ifPresent: bufferProgressColor)
        setProperty(&slider.backAnimationFromColor, ifPresent: backAnimationFromColor)
        setProperty(&slider.backAnimationToColor, ifPresent: backAnimationToColor)
        
        slider.addTarget(context.coordinator,
                         action: #selector(Coordinator.valueChanged(_:)),
                         for: .valueChanged)
        DispatchQueue.main.async {
            isTracking = slider.isSliderTracking
        }
        return slider
    }
    
    public func updateUIView(_ uiView: OSlider, context: Context) {
        uiView.value = value
        uiView.bufferValue = bufferValue
        uiView.lineHeight = lineHeight
        uiView.hideThumb = hideThumb
        uiView.minimumValue = Float(range.lowerBound)
        uiView.maximumValue = Float(range.upperBound)
        if isAnimating {
            uiView.startAnimation()
        } else {
            uiView.stopAnimation()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(value: $value, onEditingChanged: onEditingChanged)
        return coordinator
    }
}

public class Coordinator: NSObject {
    var value: Binding<Float>
    var onEditingChanged: (Bool) -> Void
    var cancellableSubscriber = Set<AnyCancellable>()
    
    init(value: Binding<Float>, onEditingChanged: @escaping (Bool) -> Void) {
        self.value = value
        self.onEditingChanged = onEditingChanged
        super.init()
    }
    
    @objc func valueChanged(_ sender: OSlider) {
        value.wrappedValue = sender.value
        onEditingChanged(sender.isSliderTracking)
    }
}

@available(iOS 14.0, *)
#Preview {
    OSliderView(value: .constant(0.5), range: 0...1, bufferValue: .constant(0), isAnimating: .constant(true), isTracking: .constant(false), onEditingChanged: { _ in })
        .padding()
}

// Function to assign an optional UIColor to a property
@available(iOS 14.0, *)
func setProperty(_ property: inout UIColor, ifPresent color: Color?) {
    if let newColor = color {
        property = UIColor(newColor)
    }
}

