//
//  OSliderControlView.swift
//  OSlider
//
//  Created by Oraz Atakishiyev on 4/25/24.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 14.0, *)
public struct OSliderView: UIViewRepresentable {
    @Binding var value: Float
    @Binding var bufferValue: Float
    @Binding var isAnimating: Bool
    @Binding var hideThumb: Bool
    
    var lineHeight: CGFloat
    var baseTrackColor: Color?
    var defaultProgressColor: Color?
    var bufferProgressColor: Color?
    var backAnimationFromColor: Color?
    var backAnimationToColor: Color?
    
    public init(value: Binding<Float>, bufferValue: Binding<Float> = .constant(0), isAnimating: Binding<Bool> = .constant(false), hideThumb: Binding<Bool> = .constant(false), lineHeight: CGFloat = 5, baseTrackColor: Color? = nil, defaultProgressColor: Color? = nil, bufferProgressColor: Color? = nil, backAnimationFromColor: Color? = nil, backAnimationToColor: Color? = nil) {
        self._value = value
        self._bufferValue = bufferValue
        self._isAnimating = isAnimating
        self._hideThumb = hideThumb
        self.lineHeight = lineHeight
        self.baseTrackColor = baseTrackColor
        self.defaultProgressColor = defaultProgressColor
        self.bufferProgressColor = bufferProgressColor
        self.backAnimationFromColor = backAnimationFromColor
        self.backAnimationToColor = backAnimationToColor
    }
    
    public func makeUIView(context: Context) -> OSlider {
        let slider = OSlider()
        slider.value = value
        slider.bufferValue = bufferValue
        slider.lineHeight = lineHeight
        slider.hideThumb = hideThumb
        setProperty(&slider.baseTrackColor, ifPresent: baseTrackColor)
        setProperty(&slider.defaultProgressColor, ifPresent: defaultProgressColor)
        setProperty(&slider.bufferProgressColor, ifPresent: bufferProgressColor)
        setProperty(&slider.backAnimationFromColor, ifPresent: backAnimationFromColor)
        setProperty(&slider.backAnimationToColor, ifPresent: backAnimationToColor)
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged),
            for: .valueChanged
        )
        return slider
    }
    
    public func updateUIView(_ uiView: OSlider, context: Context) {
        uiView.value = value
        uiView.bufferValue = bufferValue
        uiView.lineHeight = lineHeight
        uiView.hideThumb = hideThumb
        if isAnimating {
            uiView.startAnimation()
        } else {
            uiView.stopAnimation()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject {
        var parent: OSliderView
        
        init(_ parent: OSliderView) {
            self.parent = parent
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            self.parent.value = sender.value
        }
    }
}

@available(iOS 14.0, *)
#Preview {
    OSliderView(value: .constant(0.5), bufferValue: .constant(0), isAnimating: .constant(true))
        .padding()
}

// Function to assign an optional UIColor to a property
@available(iOS 14.0, *)
func setProperty(_ property: inout UIColor, ifPresent color: Color?) {
    if let newColor = color {
        property = UIColor(newColor)
    }
}

#endif
