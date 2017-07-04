//
//  VerticalSlider.swift
//  StreamFGL
//
//  Created by Roman Furman on 7/4/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import UIKit

@IBDesignable open class VerticalSlider: UIView {

    open let slider = UISlider()

    // required for IBDesignable class to properly render
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }

    // required for IBDesignable class to properly render
    required override public init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    fileprivate func initialize() {
        updateSlider()
        addSubview(slider)
    }

    fileprivate func updateSlider() {
        if !ascending {
            slider.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * -0.5)
        } else {
            slider.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 0.5).scaledBy(x: 1, y: -1)
        }

        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
        slider.value = value
        slider.thumbTintColor = thumbTintColor
        slider.minimumTrackTintColor = minimumTrackTintColor
        slider.maximumTrackTintColor = maximumTrackTintColor
        slider.isContinuous = isContinuous
    }

    @IBInspectable open var ascending: Bool = false {
        didSet {
            updateSlider()
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        slider.bounds.size.width = bounds.height
        slider.center.x = bounds.midX
        slider.center.y = bounds.midY
    }

    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: slider.intrinsicContentSize.height, height: slider.intrinsicContentSize.width)
        }
    }

    @IBInspectable open var minimumValue: Float = -1 {
        didSet {
            updateSlider()
        }
    }

    @IBInspectable open var maximumValue: Float = 1 {
        didSet {
            updateSlider()
        }
    }

    @IBInspectable open var value: Float {
        get {
            return slider.value
        }
        set {
            slider.setValue(newValue, animated: true)
        }
    }

    @IBInspectable open var thumbTintColor: UIColor? {
        didSet {
            updateSlider()
        }
    }

    @IBInspectable open var minimumTrackTintColor: UIColor? {
        didSet {
            updateSlider()
        }
    }

    @IBInspectable open var maximumTrackTintColor: UIColor? {
        didSet {
            updateSlider()
        }
    }

    @IBInspectable open var isContinuous: Bool = true {
        didSet {
            updateSlider()
        }
    }
}
