//
//  OSlider.swift
//  OSlider
//
//  Created by Oraz Atakishiyev on 4/25/24.
//

import UIKit

public typealias UKSlider = UISlider

public class OSlider: UKSlider {
    
    // MARK: - Public properties
    
    // Overrides the 'value' property to update the track layer whenever the value changes
    override public var value: Float {
        didSet {
            updateTrackLayer(value: value)
        }
    }
    
    // Line height
    public var lineHeight: CGFloat = 5 {
        didSet {
            configure()
        }
    }
    
    // Buffer value for the slider, updates the buffer layer on change
    public var bufferValue: Float = 0 {
        didSet {
            updateBufferLayer(value: value)
        }
    }
    
    // Hide thumb
    public var hideThumb: Bool = false {
        didSet {
            thumbView.isHidden = hideThumb ? true : false
            createThumbImageView()
        }
    }

    // Color of the base track, updates the slider's color configuration when changed
    public var baseTrackColor: UIColor = UIColor(red: 0.21, green: 0.21, blue: 0.21, alpha: 1.00) {
        didSet {
            updateColors()
        }
    }
    
    // Default color of the progress on the track, triggers a color update on change
    public var defaultProgressColor: UIColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00) {
        didSet {
            updateColors()
        }
    }
    
    // Color of the buffer progress on the track, updates the slider's color configuration when changed
    public var bufferProgressColor: UIColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1.00) {
        didSet {
            updateColors()
        }
    }
    
    // Colors for the back animation from and to states
    public var backAnimationFromColor: UIColor = UIColor(red: 0.34, green: 0.38, blue: 0.44, alpha: 1.00)
    public var backAnimationToColor: UIColor = UIColor(red: 0.81, green: 0.84, blue: 0.88, alpha: 1.00)
    
    // MARK: - Private properties
    
    // Configuration for background color animation
    private enum Config {
        static let backgroundColorAnimationKey = #keyPath(CALayer.backgroundColor)
    }
    
    // Private properties for various visual components of the slider
    private var thumbImage = UIImage()
    private let baseLayer = CALayer()
    private let trackLayer = CALayer()
    private let bufferLayer = CALayer()
    
    // Design constants for the slider's appearance
    private var thumbScale: CGFloat = 2
    
    private var thumbSize: CGFloat {
       return lineHeight * thumbScale
    }
    
    private var cornerRadius: CGFloat {
        return lineHeight / 3
    }
    
    // Original frame values to maintain layout consistency
    private var originalThumbFrame: CGRect = .zero
    private var originalSliderFrame: CGRect = .zero
    
    // Gesture recognizer for handling tap interactions
    private var tapGesture: UITapGestureRecognizer!
    
    // Lazy initializer for the thumb view, sets up visual properties
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.clipsToBounds = true
        thumb.backgroundColor = defaultProgressColor
        thumb.layer.borderWidth = 0.4
        thumb.layer.borderColor = defaultProgressColor.cgColor
        return thumb
    }()
    
    // Computed property to calculate the frame of the thumb based on the slider's value
    private var thumbFrame: CGRect {
        return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
    }
    
    // Animation for the background color transition
    private var backgroundColorAnimation = {
        let backgroundAnimation = CABasicAnimation(keyPath: Config.backgroundColorAnimationKey)
        backgroundAnimation.duration = 0.4
        backgroundAnimation.repeatCount = Float.infinity
        backgroundAnimation.autoreverses = true
        backgroundAnimation.isRemovedOnCompletion = false
        backgroundAnimation.fillMode = .forwards
        return backgroundAnimation
    }()
    
    // Initializes with a frame and sets up interactions
    override public init(frame: CGRect) {
        super.init(frame: frame)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(OSlider.actionPanGesture(sender:)))
        addGestureRecognizer(panGesture)
        addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }
    
    // Ensures this class is not used from Interface Builder
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Draws the slider, initializing the visual configuration
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        configure()
    }
    
    // Updates subviews during layout changes
    public override func layoutSubviews() {
        super.layoutSubviews()
        thumbView.frame = CGRect(x: thumbFrame.origin.x, y: thumbFrame.origin.y, width: thumbFrame.size.width, height: thumbFrame.size.height)
    }
    
    // Starts an animation, typically used for loading or buffering indication
    public func startAnimation() {
        updateProgressAnimation(isAnimating: true)
        trackLayer.isHidden = true
        bufferLayer.isHidden = true
        thumbView.alpha = 0
        createThumbImageView()
    }
    
    // Stops the animation and shows the slider components
    public func stopAnimation() {
        updateProgressAnimation(isAnimating: false)
        trackLayer.isHidden = false
        bufferLayer.isHidden = false
        thumbView.alpha = 1
        createThumbImageView()
    }
    
    // Sets up the slider's initial state and components
    private func configure() {
        clear()
        createBaseLayer()
        configureTrackLayer()
        createThumbImageView()
        
        configureBufferLayer()
        updateColors()
        updateTrackLayer(value: value)
        updateBufferLayer(value: value)
    }
    
    // Resets the slider's visual elements to clear
    private func clear() {
        tintColor = .clear
        maximumTrackTintColor = .clear
        backgroundColor = .clear
        thumbTintColor = .clear
    }
    
    // Creates a custom thumb image based on a specified radius
    private func thumbImage(radius: CGFloat) -> UIImage {
        thumbView.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        return thumbView.snapshot
    }
    
    // Customizes the track rectangle to fit the slider's design
    public override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: lineHeight))
        if originalSliderFrame == .zero {
            originalSliderFrame = customBounds
        }
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    // Customizes the thumb rectangle, expanding it for a larger interactive area
    override open func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let rect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        return rect.insetBy(dx: -20, dy: -20)
    }
    
    //Increase touch area for thumb
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let increasedBounds = bounds.insetBy(dx: -thumbSize, dy: -thumbSize)
        let containsPoint = increasedBounds.contains(point)
        return containsPoint
    }
}

extension OSlider {
    
    // Updates the track layer's frame based on the current thumb position
    internal func updateTrackLayer(value: Float) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let thumbRect = thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
        trackLayer.frame = .init(x: originalSliderFrame.origin.x, y: originalSliderFrame.origin.y, width: thumbRect.midX, height: lineHeight)
        CATransaction.commit()
    }
    
    // Updates the buffer layer's frame based on the buffer value's thumb position
    internal func updateBufferLayer(value: Float) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let thumbRect = thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: bufferValue)
        bufferLayer.frame = .init(x: originalSliderFrame.origin.x, y: originalSliderFrame.origin.y, width: thumbRect.midX, height: lineHeight)
        CATransaction.commit()
    }
    
    // Applies updated colors to all relevant layers of the slider
    private func updateColors() {
        baseLayer.backgroundColor = baseTrackColor.cgColor
        trackLayer.backgroundColor = defaultProgressColor.cgColor
        bufferLayer.backgroundColor = bufferProgressColor.cgColor
    }
    
    // Creates the base layer for the slider, setting initial properties
    private func createBaseLayer() {
        baseLayer.masksToBounds = true
        baseLayer.frame = .init(x: originalSliderFrame.origin.x, y: originalSliderFrame.origin.y, width: frame.width-12, height: lineHeight)
        baseLayer.cornerRadius = cornerRadius
        layer.insertSublayer(baseLayer, at: 0)
    }
    
    // Configures the track layer for initial display
    private func configureTrackLayer() {
        trackLayer.frame = .init(x: originalSliderFrame.origin.x, y: originalSliderFrame.origin.y, width: 0, height: lineHeight)
        trackLayer.cornerRadius = cornerRadius
        layer.insertSublayer(trackLayer, at: 1)
    }
    
    // Configures the buffer layer for initial display
    private func configureBufferLayer() {
        bufferLayer.frame = .init(x: originalSliderFrame.origin.x, y: originalSliderFrame.origin.y, width: frame.width, height: lineHeight)
        bufferLayer.cornerRadius = cornerRadius
        layer.insertSublayer(bufferLayer, at: 1)
    }
    
    // Creates the thumb image and assigns it to different states of the slider
    private func createThumbImageView() {
        thumbImage = thumbImage(radius: thumbSize)
        setThumbImage(thumbImage, for: .normal)
        setThumbImage(thumbImage, for: .highlighted)
    }
    
    // Updates the progress animation based on whether it's active
    private func updateProgressAnimation(isAnimating: Bool) {
        if isAnimating {
            CATransaction.begin()
                CATransaction.setDisableActions(true)
            backgroundColorAnimation.fromValue = backAnimationFromColor.cgColor
            backgroundColorAnimation.toValue = backAnimationToColor.cgColor
            baseLayer.add(backgroundColorAnimation, forKey: Config.backgroundColorAnimationKey)
            CATransaction.commit()
        } else {
            baseLayer.removeAnimation(forKey: Config.backgroundColorAnimationKey)
        }
    }
}
