# OSlider
    
<img src="https://github.com/orazz/OSlider/blob/main/Screens/1.gif" width="200">   <img src="https://github.com/orazz/OSlider/blob/main/Screens/2.jpeg" width="200">

OSlider is a versatile and customizable slider component for SwiftUI, allowing developers to easily implement sliders with rich features such as adjustable values, buffer progress, animations, thumb visibility control, and customizable aesthetics.
Features

    Value Adjustment: Set and get the slider value programmatically.
    Buffer Progress: Display secondary progress (e.g., buffering or preload progress).
    Thumb Visibility: Option to hide or show the slider thumb.
    Customizable Appearance: Change colors and line heights to match your UI design.

Installation

OSlider is available as a Swift Package. You can add it to your Xcode project by following these steps:

    Open Xcode and navigate to your project.
    Select File > Swift Packages > Add Package Dependency...
    Enter the package repository URL: https://github.com/orazz/OSlider.git
    Choose the version you want to use and click Next.

Usage

Here’s how you can use OSlider in your SwiftUI project:
Importing the Package

First, import OSlider in the SwiftUI view where you want to use it:

```swift
import OSlider
```

Using OSliderView

You can integrate the slider into your view like this:

```swift
struct ContentView: View {
    @State private var sliderValue: Float = 0.5
    @State private var bufferValue: Float = 0.7
    @State private var isAnimating: Bool = false
    @State private var hideThumb: Bool = false
    @State private var sliderHeight: CGFloat = 7

    var body: some View {
        OSliderView(
            value: $sliderValue,
            bufferValue: $bufferValue,
            isAnimating: $isAnimating,
            hideThumb: $hideThumb,
            lineHeight: sliderHeight,
            bufferProgressColor: Color.gray.opacity(0.3)
        )
    }
}
```

Parameters

    value: Bind a Float for the current slider value.
    bufferValue: Bind a Float for the buffer progress, useful for displaying loading or download states.
    isAnimating: Bind a Bool to control animation states.
    hideThumb: Bind a Bool to control the visibility of the slider thumb.
    lineHeight: Set the height of the slider's track.
    baseTrackColor: Customize the base track color (optional).
    defaultProgressColor: Set the color for the default progress of the slider (optional).
    bufferProgressColor: Set the color for the buffer progress (optional).
    backAnimationFromColor: Define the starting color for the background animation (optional).
    backAnimationToColor: Define the ending color for the background animation (optional).
    
License

OSlider is released under the MIT license. See LICENSE for details.
Contributions

Contributions are welcome! Please feel free to fork, modify, and make pull requests or to log issues and feature requests on the project's issues page.
