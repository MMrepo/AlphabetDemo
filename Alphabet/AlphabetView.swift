//
//  AlphabetView.swift
//  Alphabet
//
//  Created by Mateusz Małek on 24.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import UIKit
import PocketSVG

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

public extension Double {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random double between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random double point number between 0 and n max
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}

public class AlpahetText:UIView {
    
    private var containerLayer = CALayer()
    private var containerLayerWidth:CGFloat = 0
    private let letters: [Character:UIBezierPath]
    private let alphabet = "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~§"
    public var stringToPrint: String = "" {
        didSet {
            if !stringToPrint.isEmpty {
                build(text: stringToPrint)
                self.containerLayerWidth = containerLayer.frame.width
            }
        }
    }
    
    public func randomizePosition() {
        guard let letters = containerLayer.sublayers as? [CAShapeLayer] else {
            return
        }
        
        for letter in letters {
            letter.position.y = CGFloat(Double.random(min: -5, max: 5))
        }
    }
    
    public var strokeEnd:CGFloat = 1 {
        didSet {
            guard let letters = containerLayer.sublayers as? [CAShapeLayer] else {
                return
            }
            for letter in letters {
                letter.strokeEnd = strokeEnd
                
            }
        }
    }
    
    public var shadowRadius:CGFloat = 0 {
        didSet {
            guard let letters = containerLayer.sublayers as? [CAShapeLayer] else {
                return
            }
            
            for letter in letters {
                letter.shadowRadius = shadowRadius
                letter.shadowColor = UIColor.darkGray.cgColor
                letter.shadowRadius = shadowRadius
                letter.shadowOffset = CGSize(width: 1, height: 2)
                letter.shadowOpacity = 1
            }
        }
    }
    
    private var scale:CGFloat = 1
    private let anyCharacter:Character = "§"
    private let maxGlyphHeight:CGFloat
    private let maxGlyphYOffset:CGFloat
    
    public var lineWidth:CGFloat = 1 {
        didSet {
            guard let letters = containerLayer.sublayers as? [CAShapeLayer] else {
                return
            }
            for letter in letters {
                letter.lineWidth = lineWidth
            }
        }
    }
    public var lettersSpace:CGFloat = 5
    public var textColor:UIColor = .black {
        didSet {
            guard let letters = containerLayer.sublayers as? [CAShapeLayer] else {
                return
            }
            for letter in letters {
                letter.strokeColor = textColor.cgColor
            }
        }
    }
    
    public init() {
        let bundle = Bundle(for: type(of: self))
        let urlLogo = bundle.url(forResource: "alphabet_sans_test_simple2_join", withExtension: "svg")!
        let glyphs = SVGBezierPath.pathsFromSVG(at: urlLogo)
        
        var maxGlyphHeight: CGFloat = 0
        var maxGlyphYOffset: CGFloat = 0
        var lettersGlyphs:[Character:UIBezierPath] = [:]
        for (index, glyph) in glyphs.enumerated() {
            let character:Character = alphabet[index]
            lettersGlyphs[character] = glyph
            maxGlyphHeight = maxGlyphHeight > glyph.bounds.height ? maxGlyphHeight : glyph.bounds.height
            maxGlyphYOffset = maxGlyphYOffset < glyph.bounds.origin.y ? maxGlyphYOffset : glyph.bounds.origin.y
        }
        
        for (character, glyph) in lettersGlyphs {
            let translation = CGSize(width: glyph.bounds.origin.x * -1, height: -1 * maxGlyphYOffset)
            glyph.apply(CGAffineTransform(translationX: translation.width,
                                          y: translation.height))
        }
        letters = lettersGlyphs
        self.maxGlyphHeight = maxGlyphHeight
        self.maxGlyphYOffset = maxGlyphYOffset
        super.init(frame: .zero)
        //        let frame = animations.first!
        
        
    }
    
    private func glyphPathFor(chatacter: Character, scaleFactor: CGFloat = 1) -> UIBezierPath {
        let letterGlyphPath:UIBezierPath
        if let path = self.letters[chatacter] {
            letterGlyphPath = path
        }
        else if chatacter == " " {
            letterGlyphPath = UIBezierPath()
        }
        else {
            letterGlyphPath = self.letters[anyCharacter]!
        }
        
        let copy = letterGlyphPath.copy() as! UIBezierPath
        copy.scale(factor: scaleFactor)
        
        return copy
    }
    
    func build(text: String) {
        //        if let
        //        let dimmension = self.bounds.width < self.bounds.height ? self.bounds.width : self.bounds.height
        print("scale: \(scale)")
        containerLayer.removeFromSuperlayer()
        containerLayer = CALayer()
        //        containerLayer.backgroundColor = UIColor.cyan.cgColor
        //        let scale:CGFloat = 2
        var letterOffset:CGFloat = 0
        for letter in text {
            
            let layer = CAShapeLayer()
            //            layer.backgroundColor = UIColor.white.cgColor
            
            let letterGlyphPath:UIBezierPath = glyphPathFor(chatacter: letter, scaleFactor: scale)
            layer.path = letterGlyphPath.cgPath
            layer.lineWidth = lineWidth * scale
            layer.strokeEnd = 1
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = textColor.cgColor
            layer.lineJoin = kCALineJoinRound
            layer.lineCap = kCALineCapRound
            layer.frame = CGRect(x:letterOffset, y: 0, width: letterGlyphPath.bounds.width + layer.lineWidth, height: maxGlyphHeight*scale)
            let letterWidth = layer.frame.size.width
            letterOffset += letterWidth + lettersSpace*scale + layer.lineWidth
            
            containerLayer.addSublayer(layer)
        }
        containerLayer.frame = CGRect(x: 0, y: 0, width: letterOffset, height: maxGlyphHeight*scale)
        
        self.layer.addSublayer(containerLayer)
        
    }
    
    public func startAnimation3(withDelay delay:TimeInterval = 0.3) {
        
        guard let letters = containerLayer.sublayers as? [CAShapeLayer] else {
            return
        }
        
        for layer in containerLayer.sublayers! {
            if let animationsKeys = layer.animationKeys(), animationsKeys.count > 0 {
                layer.removeAllAnimations()
            }
        }
        
        self.layoutIfNeeded()
        
        let animationContour = self.strokeEndAnimation
        let animationFill = self.fillAnimation
        let animationPosition = self.positionAnimation
        let animationColor = self.colorAnimation(from: .blue, to: .yellow)
        let animationLineWidth = self.lineWidthAnimation(from: 1.0, to: 5)
        let animationShadow = self.shadowAnimation()
        animationContour.duration = 0.5
        animationFill.duration = 0.5
        animationPosition.duration = 0.5
        animationColor.duration = 1
        animationLineWidth.duration = 0.5
        animationShadow.duration = 0.5
        let startTime = delay
        
        var beginTime = startTime
        for letter in letters {
            letter.strokeColor = textColor.cgColor
            letter.shadowColor = UIColor.blue.cgColor
            letter.shadowRadius = 2
            letter.shadowOffset = CGSize(width: 1, height: 2)
            
            //                animationContour.beginTime =  CACurrentMediaTime() + beginTime
            //                animationFill.beginTime =  CACurrentMediaTime() + beginTime
            //                animationPosition.beginTime =  CACurrentMediaTime() + beginTime
            animationShadow.beginTime = CACurrentMediaTime() + beginTime
            beginTime += animationShadow.duration
            //                letter.add(animationContour, forKey:  "animationContour")
            //                letter.add(animationFill, forKey: "animationFill")
            //                letter.add(animationPosition, forKey: "animationPosition")
            letter.add(animationShadow, forKey: "animationShadow")
        }
    }
    
    public func startAnimation2(withDelay delay:TimeInterval = 0.3) {
        
        guard let letters = containerLayer.sublayers as? [CAShapeLayer] else {
            return
        }
        
        for layer in containerLayer.sublayers! {
            if let animationsKeys = layer.animationKeys(), animationsKeys.count > 0 {
                layer.removeAllAnimations()
            }
        }
        
        self.layoutIfNeeded()
        
        let animationContour = self.strokeEndAnimation
        let animationFill = self.fillAnimation
        let animationPosition = self.positionAnimation
        let animationColor = self.colorAnimation(from: .blue, to: .yellow)
        let animationLineWidth = self.lineWidthAnimation(from: 1.0, to: 5)
        let animationShadow = self.shadowAnimation()
        animationContour.duration = 0.5
        animationFill.duration = 0.5
        animationPosition.duration = 0.5
        animationColor.duration = 1
        animationLineWidth.duration = 1
        animationShadow.duration = 1
        let startTime = delay
        
        var beginTime = startTime
        for letter in letters {
            letter.strokeColor = UIColor.clear.cgColor
            letter.shadowColor = UIColor.darkGray.cgColor
            letter.shadowRadius = 1
            letter.shadowOffset = CGSize(width: 0.25, height: 0.5)
            
            //                animationContour.beginTime =  CACurrentMediaTime() + beginTime
            //                animationFill.beginTime =  CACurrentMediaTime() + beginTime
            //                animationPosition.beginTime =  CACurrentMediaTime() + beginTime
            animationFill.beginTime = CACurrentMediaTime() + beginTime
            beginTime += animationFill.duration
            //                letter.add(animationContour, forKey:  "animationContour")
            //                letter.add(animationFill, forKey: "animationFill")
            //                letter.add(animationPosition, forKey: "animationPosition")
            letter.add(animationFill, forKey: "animationFill")
        }
    }
    
    public func startAnimation1(withDelay delay:TimeInterval = 0.3) {
        
        guard let letters = containerLayer.sublayers as? [CAShapeLayer] else {
            return
        }
        
        for layer in containerLayer.sublayers! {
            if let animationsKeys = layer.animationKeys(), animationsKeys.count > 0 {
                layer.removeAllAnimations()
            }
        }
        
        self.layoutIfNeeded()
        
        let animationContour = self.strokeEndAnimation
        let animationFill = self.fillAnimation
        let animationPosition = self.positionAnimation
        let animationColor = self.colorAnimation(from: .blue, to: .yellow)
        let animationLineWidth = self.lineWidthAnimation(from: 1.0, to: 5)
        let animationShadow = self.shadowAnimation()
        animationContour.duration = 0.5
        animationFill.duration = 0.5
        animationPosition.duration = 0.5
        animationColor.duration = 1
        animationLineWidth.duration = 0.5
        animationShadow.duration = 1
        let startTime = delay
        
        var beginTime = startTime
        for letter in letters {
            letter.strokeColor = textColor.cgColor

            //                animationContour.beginTime =  CACurrentMediaTime() + beginTime
            //                animationFill.beginTime =  CACurrentMediaTime() + beginTime
            //                animationPosition.beginTime =  CACurrentMediaTime() + beginTime
            animationLineWidth.beginTime = CACurrentMediaTime() + beginTime
            beginTime += animationLineWidth.duration
            //                letter.add(animationContour, forKey:  "animationContour")
            //                letter.add(animationFill, forKey: "animationFill")
            //                letter.add(animationPosition, forKey: "animationPosition")
            letter.add(animationLineWidth, forKey: "animationLineWidth")
        }
    }
    
    public func startAnimation4(withDelay delay:TimeInterval = 0.3) {
        
        guard let letters = containerLayer.sublayers as? [CAShapeLayer] else {
            return
        }
        
        for layer in containerLayer.sublayers! {
            if let animationsKeys = layer.animationKeys(), animationsKeys.count > 0 {
                layer.removeAllAnimations()
            }
        }
        
        self.layoutIfNeeded()
        
        let animationContour = self.strokeEndAnimation
        let animationFill = self.fillAnimation
        let animationPosition = self.positionAnimation
        let animationColor = self.colorAnimation(from: .blue, to: .yellow)
        let animationLineWidth = self.lineWidthAnimation(from: 1.0, to: 5)
        let animationShadow = self.shadowAnimation()
        animationContour.duration = 0.5
        animationFill.duration = 0.2
        animationPosition.duration = 0.5
        animationColor.duration = 1
        animationLineWidth.duration = 1
        animationShadow.duration = 1
        let startTime = delay
        
        var beginTime = startTime
        for letter in letters {
            letter.strokeColor = UIColor.clear.cgColor
            
            //                animationContour.beginTime =  CACurrentMediaTime() + beginTime
                            animationFill.beginTime =  CACurrentMediaTime() + beginTime
            //                animationPosition.beginTime =  CACurrentMediaTime() + beginTime
            animationContour.beginTime = CACurrentMediaTime() + beginTime
            beginTime += animationContour.duration
            //                letter.add(animationContour, forKey:  "animationContour")
            //                letter.add(animationFill, forKey: "animationFill")
            //                letter.add(animationPosition, forKey: "animationPosition")
            letter.add(animationContour, forKey: "animationContour")
            letter.add(animationFill, forKey: "animationFill")
        }
    }
    
    public func startAnimation5(withDelay delay:TimeInterval = 0.3) {
        
        guard let letters = containerLayer.sublayers as? [CAShapeLayer] else {
            return
        }
        
        for layer in containerLayer.sublayers! {
            if let animationsKeys = layer.animationKeys(), animationsKeys.count > 0 {
                layer.removeAllAnimations()
            }
        }
        
        self.layoutIfNeeded()
        
        let animationContour = self.strokeEndAnimation
        let animationFill = self.fillAnimation
        let animationPosition = self.positionAnimation
        let animationColor = self.colorAnimation(from: textColor, to: .red)
        let animationLineWidth = self.lineWidthAnimation(from: 1.0, to: 5)
        let animationShadow = self.shadowAnimation()
        animationContour.duration = 0.5
        animationFill.duration = 0.5
        animationPosition.duration = 0.5
        animationColor.duration = 1
        animationLineWidth.duration = 1
        animationShadow.duration = 1
        let startTime = delay
        
        var beginTime = startTime
        for letter in letters {
            letter.strokeColor = textColor.cgColor

            //                animationContour.beginTime =  CACurrentMediaTime() + beginTime
            //                animationFill.beginTime =  CACurrentMediaTime() + beginTime
            //                animationPosition.beginTime =  CACurrentMediaTime() + beginTime
            animationColor.beginTime = CACurrentMediaTime() + beginTime
            beginTime += animationColor.duration
            //                letter.add(animationContour, forKey:  "animationContour")
            //                letter.add(animationFill, forKey: "animationFill")
            //                letter.add(animationPosition, forKey: "animationPosition")
            letter.add(animationColor, forKey: "animationColor")
        }
    }
    
    public func startAnimation6(withDelay delay:TimeInterval = 0.3) {
        
        guard let letters = containerLayer.sublayers as? [CAShapeLayer] else {
            return
        }
        
        for layer in containerLayer.sublayers! {
            if let animationsKeys = layer.animationKeys(), animationsKeys.count > 0 {
                layer.removeAllAnimations()
            }
        }
        
        self.layoutIfNeeded()
        
        let animationContour = self.strokeEndAnimation
        let animationFill = self.fillAnimation
        let animationPosition = self.positionAnimation
        let animationColor = self.colorAnimation(from: .blue, to: .yellow)
        let animationLineWidth = self.lineWidthAnimation(from: 1.0, to: 5)
        let animationShadow = self.shadowAnimation()
        animationContour.duration = 0.5
        animationFill.duration = 0.2
        animationPosition.duration = 0.5
        animationColor.duration = 1
        animationLineWidth.duration = 1
        animationShadow.duration = 1
        let startTime = delay
        
        var beginTime = startTime
        for letter in letters {
            letter.strokeColor = UIColor.clear.cgColor

            //                animationContour.beginTime =  CACurrentMediaTime() + beginTime
            //                animationFill.beginTime =  CACurrentMediaTime() + beginTime
            //                animationPosition.beginTime =  CACurrentMediaTime() + beginTime
            animationPosition.beginTime = CACurrentMediaTime() + beginTime
            animationFill.beginTime = CACurrentMediaTime() + beginTime
            beginTime += animationPosition.duration
            //                letter.add(animationContour, forKey:  "animationContour")
                            letter.add(animationFill, forKey: "animationFill")
            //                letter.add(animationPosition, forKey: "animationPosition")
            letter.add(animationPosition, forKey: "animationPosition")
        }
    }
    //
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        self.scale = containerLayerWidth > 0 ? (self.bounds.width/containerLayerWidth) : 1
        self.scale = maxGlyphHeight > 0 ? (self.bounds.height/maxGlyphHeight) : 1
        
        self.build(text: stringToPrint)
    }
}

//MARK: - Default animations
private extension AlpahetText {
    var strokeEndAnimation: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration =  0.7
        animation.beginTime = 0
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        return animation
    }
    
    var fillAnimation: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeColor")
        animation.fromValue = UIColor.black.withAlphaComponent(0).cgColor
        animation.toValue = UIColor.black.withAlphaComponent(1).cgColor
        animation.duration = 0.5
        animation.beginTime = 0
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        return animation
    }
    
    var positionAnimation: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = -UIScreen.main.bounds.height
        animation.duration =  0.2
        animation.beginTime = 0
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        return animation
    }
    
    func colorAnimation(from: UIColor, to: UIColor) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeColor")
        animation.fromValue = from.cgColor
        animation.toValue = to.cgColor
        animation.duration =  0.5
        animation.beginTime = 0
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        return animation
    }
    
    func shadowAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration =  0.5
        animation.beginTime = 0
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        return animation
    }
    
    func lineWidthAnimation(from: CGFloat, to: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "lineWidth")
        animation.fromValue = from
        animation.toValue = to
        animation.duration =  0.5
        animation.beginTime = 0
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        return animation
    }
}

private extension UIBezierPath
{
    func scale(factor: CGFloat)
    {
        let scaleTransform = CGAffineTransform(scaleX: factor, y: factor)
        self.apply(scaleTransform)
    }
}
