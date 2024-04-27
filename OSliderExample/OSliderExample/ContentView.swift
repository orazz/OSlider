//
//  ContentView.swift
//  OSliderExample
//
//  Created by atakishiyev on 4/26/24.
//

import SwiftUI
import OSlider

struct ContentView: View {
    
    @State var sliderValue: Float = 0
    @State var bufferValue: Float = 0.2
    @State var hideThumb: Bool = true
    @State var isAnimating: Bool = false
    var sliderHeight: Float = 5
    
    // Timer to simulate playback and buffer updates
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Toggle("Animate", isOn: $isAnimating)
            Toggle("show/hide thumb", isOn: $hideThumb)
            OSliderView(value: $sliderValue, bufferValue: $bufferValue, isAnimating: $isAnimating, hideThumb: $hideThumb, lineHeight: CGFloat(sliderHeight+15), bufferProgressColor: Color.gray.opacity(0.3))
            OSliderView(value: $sliderValue, bufferValue: $bufferValue, isAnimating: $isAnimating, hideThumb: $hideThumb, lineHeight: CGFloat(sliderHeight+10), bufferProgressColor: Color.gray.opacity(0.3))
            OSliderView(value: $sliderValue, bufferValue: $bufferValue, isAnimating: $isAnimating, hideThumb: $hideThumb, lineHeight: CGFloat(sliderHeight+5), bufferProgressColor: Color.gray.opacity(0.3))
            OSliderView(value: $sliderValue, bufferValue: $bufferValue, isAnimating: $isAnimating, hideThumb: $hideThumb, lineHeight: CGFloat(sliderHeight), bufferProgressColor: Color.gray.opacity(0.3))
            HStack {
                Text("\(sliderValue, specifier: "%.2f")")
                    .font(.system(size: 12).monospacedDigit())
                Spacer()
                Text("\(bufferValue, specifier: "%.2f")")
                    .font(.system(size: 12).monospacedDigit())
            }
        }
        .padding()
        .onReceive(timer) { _ in
            // Simulate playback progress
            if sliderValue < 1 {
                sliderValue += 0.01
            }
            
            // Simulate buffer progress
            if bufferValue < 1 && sliderValue + 0.05 < bufferValue {
                bufferValue += 0.01
            }
        }
    }
}

#Preview {
    ContentView()
}
