//
//  IphoneXView.swift
//  
//
//  Created on 4/17/18, 8:23 PM.
//


import UIKit

class IphoneXView: UIView
{
    
    // MARK: - Initialization
    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 375, height: 812))
        self.setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.setupLayers()
    }
    
    // MARK: - Setup Layers
    
    private func setupLayers()
    {
        // Colors
        //
        let backgroundColor = UIColor.black
        let fillColor = UIColor(red: 0.721569, green: 0.913725, blue: 0.52549, alpha: 1)
        let strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        // Paths
        //
        let pathPath = CGMutablePath()
        pathPath.move(to: CGPoint(x: 0.591, y: 60.528))
        pathPath.addLine(to: CGPoint(x: 47.037998, y: 16.653))
        pathPath.addCurve(to: CGPoint(x: 42.549, y: 2.643), control1: CGPoint(x: 41.051998, y: 11.434), control2: CGPoint(x: 39.555, y: 6.764))
        pathPath.addCurve(to: CGPoint(x: 61.827, y: 4.736), control1: CGPoint(x: 45.542, y: -1.478), control2: CGPoint(x: 51.967999, y: -0.78))
        pathPath.addCurve(to: CGPoint(x: 85.960999, y: 27.683001), control1: CGPoint(x: 78.587997, y: 17.358999), control2: CGPoint(x: 86.633003, y: 25.007999))
        pathPath.addCurve(to: CGPoint(x: 75.904999, y: 41.219002), control1: CGPoint(x: 85.5, y: 31.208), control2: CGPoint(x: 85.671997, y: 36.157001))
        pathPath.addCurve(to: CGPoint(x: 34.683998, y: 49.018002), control1: CGPoint(x: 64.847, y: 46.949001), control2: CGPoint(x: 36.903, y: 51.494999))
        pathPath.addLine(to: CGPoint(x: 69.718002, y: 31.222))
        pathPath.addCurve(to: CGPoint(x: 63.602001, y: 26.135), control1: CGPoint(x: 69.406998, y: 29.391001), control2: CGPoint(x: 67.367996, y: 27.695))
        pathPath.addCurve(to: CGPoint(x: 40.143002, y: 41.219002), control1: CGPoint(x: 51.013, y: 34.499001), control2: CGPoint(x: 43.193001, y: 39.527))
        pathPath.addCurve(to: CGPoint(x: 34.683998, y: 44.279999), control1: CGPoint(x: 38.389999, y: 42.192001), control2: CGPoint(x: 35.296001, y: 44.181999))
        pathPath.addCurve(to: CGPoint(x: 7.078, y: 58.879002), control1: CGPoint(x: 16.280001, y: 54.013), control2: CGPoint(x: 7.078, y: 58.879002))
        pathPath.addCurve(to: CGPoint(x: 1.555, y: 60.992001), control1: CGPoint(x: 5.072, y: 60.243), control2: CGPoint(x: 3.231, y: 60.948002))
        pathPath.addCurve(to: CGPoint(x: 0.591, y: 60.528), control1: CGPoint(x: -0.121, y: 61.036999), control2: CGPoint(x: -0.442, y: 60.882))
        pathPath.closeSubpath()
        pathPath.move(to: CGPoint(x: 0.591, y: 60.528))
        
        let ovalPath = CGMutablePath()
        ovalPath.move(to: CGPoint(x: 19.5, y: 11))
        ovalPath.addCurve(to: CGPoint(x: 39, y: 5.5), control1: CGPoint(x: 30.27, y: 11), control2: CGPoint(x: 39, y: 8.538))
        ovalPath.addCurve(to: CGPoint(x: 19.5, y: 0), control1: CGPoint(x: 39, y: 2.462), control2: CGPoint(x: 30.27, y: 0))
        ovalPath.addCurve(to: CGPoint(x: 0, y: 5.5), control1: CGPoint(x: 8.73, y: 0), control2: CGPoint(x: 0, y: 2.462))
        ovalPath.addCurve(to: CGPoint(x: 19.5, y: 11), control1: CGPoint(x: 0, y: 8.538), control2: CGPoint(x: 8.73, y: 11))
        ovalPath.closeSubpath()
        ovalPath.move(to: CGPoint(x: 19.5, y: 11))
        
        let ovalPath1 = CGMutablePath()
        ovalPath1.move(to: CGPoint(x: 12.5, y: 23))
        ovalPath1.addCurve(to: CGPoint(x: 25, y: 11.5), control1: CGPoint(x: 19.403999, y: 23), control2: CGPoint(x: 25, y: 17.851))
        ovalPath1.addCurve(to: CGPoint(x: 12.5, y: 0), control1: CGPoint(x: 25, y: 5.149), control2: CGPoint(x: 19.403999, y: 0))
        ovalPath1.addCurve(to: CGPoint(x: 0, y: 11.5), control1: CGPoint(x: 5.596, y: 0), control2: CGPoint(x: 0, y: 5.149))
        ovalPath1.addCurve(to: CGPoint(x: 12.5, y: 23), control1: CGPoint(x: 0, y: 17.851), control2: CGPoint(x: 5.596, y: 23))
        ovalPath1.closeSubpath()
        ovalPath1.move(to: CGPoint(x: 12.5, y: 23))
        
        let pathPath1 = CGMutablePath()
        pathPath1.move(to: CGPoint(x: 1.81, y: 38))
        pathPath1.addCurve(to: CGPoint(x: 4.113, y: 8.481), control1: CGPoint(x: -1.216, y: 23.437), control2: CGPoint(x: -0.448, y: 13.598))
        pathPath1.addCurve(to: CGPoint(x: 32.695999, y: 2.764), control1: CGPoint(x: 10.955, y: 0.806), control2: CGPoint(x: 19.400999, y: -2.953))
        pathPath1.addCurve(to: CGPoint(x: 45.991001, y: 20.155001), control1: CGPoint(x: 45.991001, y: 8.481), control2: CGPoint(x: 46.067001, y: 19.77))
        pathPath1.addCurve(to: CGPoint(x: 45.191002, y: 21.972), control1: CGPoint(x: 45.956001, y: 20.326), control2: CGPoint(x: 45.941002, y: 21.341))
        pathPath1.addCurve(to: CGPoint(x: 42.153999, y: 23.164), control1: CGPoint(x: 44.256001, y: 22.76), control2: CGPoint(x: 42.521999, y: 23.171))
        pathPath1.addCurve(to: CGPoint(x: 29.533001, y: 18.205), control1: CGPoint(x: 41.490002, y: 23.152), control2: CGPoint(x: 34.451, y: 24.465))
        pathPath1.addCurve(to: CGPoint(x: 17.874001, y: 11.945), control1: CGPoint(x: 26.254, y: 14.032), control2: CGPoint(x: 22.367001, y: 11.945))
        pathPath1.addCurve(to: CGPoint(x: 6.643, y: 24.891001), control1: CGPoint(x: 13.036, y: 13.653), control2: CGPoint(x: 9.293, y: 17.968))
        pathPath1.addCurve(to: CGPoint(x: 1.81, y: 38), control1: CGPoint(x: 3.993, y: 31.813), control2: CGPoint(x: 2.382, y: 36.182999))
        pathPath1.closeSubpath()
        pathPath1.move(to: CGPoint(x: 1.81, y: 38))
        
        let pathPath2 = CGMutablePath()
        pathPath2.move(to: CGPoint(x: 7.195, y: 4.542))
        pathPath2.addCurve(to: CGPoint(x: 9.891, y: 5.926), control1: CGPoint(x: 8.553, y: 5.116), control2: CGPoint(x: 9.452, y: 5.578))
        pathPath2.addCurve(to: CGPoint(x: 14.406, y: 12.84), control1: CGPoint(x: 12.631, y: 8.098), control2: CGPoint(x: 13.777, y: 10.515))
        pathPath2.addCurve(to: CGPoint(x: 25.846001, y: 21.037001), control1: CGPoint(x: 15.575, y: 17.164), control2: CGPoint(x: 20.990999, y: 23.577))
        pathPath2.addCurve(to: CGPoint(x: 44.129002, y: 0.002), control1: CGPoint(x: 30.702, y: 18.496), control2: CGPoint(x: 46.837002, y: 1.861))
        pathPath2.addCurve(to: CGPoint(x: 45.844002, y: 0.002), control1: CGPoint(x: 45.066002, y: 0.005), control2: CGPoint(x: 45.637001, y: 0.005))
        pathPath2.addCurve(to: CGPoint(x: 40.287998, y: 19.954), control1: CGPoint(x: 46.155998, y: -0.002), control2: CGPoint(x: 46.537998, y: 12.369))
        pathPath2.addCurve(to: CGPoint(x: 31.247, y: 28.872), control1: CGPoint(x: 37.618, y: 23.194), control2: CGPoint(x: 34.757999, y: 26.481001))
        pathPath2.addCurve(to: CGPoint(x: 17.566999, y: 32.646), control1: CGPoint(x: 26.538, y: 32.080002), control2: CGPoint(x: 21.098, y: 33.785999))
        pathPath2.addCurve(to: CGPoint(x: 0.297, y: 16.493), control1: CGPoint(x: 11.403, y: 30.657), control2: CGPoint(x: 1.491, y: 24.968))
        pathPath2.addCurve(to: CGPoint(x: 2.716, y: 5.671), control1: CGPoint(x: -0.897, y: 8.019), control2: CGPoint(x: 1.836, y: 6.081))
        pathPath2.addCurve(to: CGPoint(x: 5.333, y: 4.542), control1: CGPoint(x: 3.14, y: 5.474), control2: CGPoint(x: 3.962, y: 4.847))
        pathPath2.addCurve(to: CGPoint(x: 7.195, y: 4.542), control1: CGPoint(x: 5.683, y: 4.464), control2: CGPoint(x: 6.304, y: 4.464))
        pathPath2.closeSubpath()
        pathPath2.move(to: CGPoint(x: 7.195, y: 4.542))
        
        // iPhone X
        //
        let iPhoneXLayer = CALayer()
        iPhoneXLayer.name = "iPhone X"
        iPhoneXLayer.bounds = CGRect(x: 0, y: 0, width: 375, height: 812)
        iPhoneXLayer.position = CGPoint(x: 0, y: 0)
        iPhoneXLayer.anchorPoint = CGPoint(x: 0, y: 0)
        iPhoneXLayer.contentsGravity = kCAGravityCenter
        iPhoneXLayer.contentsScale = 2
        iPhoneXLayer.masksToBounds = true
        iPhoneXLayer.backgroundColor = backgroundColor.cgColor
        
        // iPhone X Sublayers
        //
        
        // Runner
        //
        let runnerLayer = CALayer()
        runnerLayer.name = "Runner"
        runnerLayer.bounds = CGRect(x: 0, y: 0, width: 145, height: 100)
        runnerLayer.position = CGPoint(x: 187.5, y: 406)
        runnerLayer.contentsGravity = kCAGravityCenter
        runnerLayer.contentsScale = 2
        
        // Runner Animations
        //
        
        // transform.scale.xy
        //
        let transformScaleXyAnimation = CABasicAnimation()
        transformScaleXyAnimation.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.000001
        transformScaleXyAnimation.duration = 1.5
        transformScaleXyAnimation.fillMode = kCAFillModeForwards
        transformScaleXyAnimation.isRemovedOnCompletion = false
        transformScaleXyAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transformScaleXyAnimation.keyPath = "transform.scale.xy"
        transformScaleXyAnimation.toValue = 0.5
        transformScaleXyAnimation.fromValue = 1
        
        runnerLayer.add(transformScaleXyAnimation, forKey: "transformScaleXyAnimation")
        
        // transform.scale.xy
        //
        let transformScaleXyAnimation1 = CASpringAnimation()
        transformScaleXyAnimation1.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.500001
        transformScaleXyAnimation1.duration = 0.5
        transformScaleXyAnimation1.speed = 1.5
        transformScaleXyAnimation1.fillMode = kCAFillModeForwards
        transformScaleXyAnimation1.isRemovedOnCompletion = false
        transformScaleXyAnimation1.keyPath = "transform.scale.xy"
        transformScaleXyAnimation1.toValue = 2.56
        transformScaleXyAnimation1.fromValue = 0.5
        transformScaleXyAnimation1.stiffness = 200
        transformScaleXyAnimation1.damping = 10
        transformScaleXyAnimation1.mass = 0.7
        transformScaleXyAnimation1.initialVelocity = 4
        
        runnerLayer.add(transformScaleXyAnimation1, forKey: "transformScaleXyAnimation1")
        
        // opacity
        //
        let opacityAnimation = CABasicAnimation()
        opacityAnimation.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.500001
        opacityAnimation.duration = 0.441427
        opacityAnimation.fillMode = kCAFillModeForwards
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        opacityAnimation.keyPath = "opacity"
        opacityAnimation.toValue = 0
        opacityAnimation.fromValue = 1
        
        runnerLayer.add(opacityAnimation, forKey: "opacityAnimation")
        
        // Runner Sublayers
        //
        
        // Path
        //
        let pathLayer = CAShapeLayer()
        pathLayer.name = "Path"
        pathLayer.bounds = CGRect(x: 0, y: 0, width: 86, height: 61)
        pathLayer.position = CGPoint(x: 0, y: 39)
        pathLayer.anchorPoint = CGPoint(x: 0, y: 0)
        pathLayer.contentsGravity = kCAGravityCenter
        pathLayer.contentsScale = 2
        pathLayer.path = pathPath
        pathLayer.fillColor = fillColor.cgColor
        pathLayer.strokeColor = strokeColor.cgColor
        pathLayer.fillRule = kCAFillRuleEvenOdd
        pathLayer.lineWidth = 0
        
        runnerLayer.addSublayer(pathLayer)
        
        // Oval
        //
        let ovalLayer = CAShapeLayer()
        ovalLayer.name = "Oval"
        ovalLayer.bounds = CGRect(x: 0, y: 0, width: 39, height: 11)
        ovalLayer.position = CGPoint(x: 85.5, y: 37.5)
        ovalLayer.contentsGravity = kCAGravityCenter
        ovalLayer.contentsScale = 2
        ovalLayer.transform = CATransform3D( m11: 0.755842, m12: -0.654754, m13: 0, m14: 0,
                                             m21: 0.654754, m22: 0.755842, m23: 0, m24: 0,
                                             m31: 0, m32: 0, m33: 1, m34: 0,
                                             m41: 0, m42: 0, m43: 0, m44: 1 )
        ovalLayer.path = ovalPath
        ovalLayer.fillColor = fillColor.cgColor
        ovalLayer.strokeColor = strokeColor.cgColor
        ovalLayer.fillRule = kCAFillRuleEvenOdd
        ovalLayer.lineWidth = 0
        
        runnerLayer.addSublayer(ovalLayer)
        
        // Oval 2
        //
        let ovalLayer1 = CAShapeLayer()
        ovalLayer1.name = "Oval 2"
        ovalLayer1.bounds = CGRect(x: 0, y: 0, width: 25, height: 23)
        ovalLayer1.position = CGPoint(x: 98, y: 6)
        ovalLayer1.anchorPoint = CGPoint(x: 0, y: 0)
        ovalLayer1.contentsGravity = kCAGravityCenter
        ovalLayer1.contentsScale = 2
        ovalLayer1.path = ovalPath1
        ovalLayer1.fillColor = fillColor.cgColor
        ovalLayer1.strokeColor = strokeColor.cgColor
        ovalLayer1.fillRule = kCAFillRuleEvenOdd
        ovalLayer1.lineWidth = 0
        
        runnerLayer.addSublayer(ovalLayer1)
        
        // Path 2
        //
        let pathLayer1 = CAShapeLayer()
        pathLayer1.name = "Path 2"
        pathLayer1.bounds = CGRect(x: 0, y: 0, width: 46, height: 38)
        pathLayer1.position = CGPoint(x: 46, y: 0)
        pathLayer1.anchorPoint = CGPoint(x: 0, y: 0)
        pathLayer1.contentsGravity = kCAGravityCenter
        pathLayer1.contentsScale = 2
        pathLayer1.path = pathPath1
        pathLayer1.fillColor = fillColor.cgColor
        pathLayer1.strokeColor = strokeColor.cgColor
        pathLayer1.fillRule = kCAFillRuleEvenOdd
        pathLayer1.lineWidth = 0
        
        runnerLayer.addSublayer(pathLayer1)
        
        // Path 3
        //
        let pathLayer2 = CAShapeLayer()
        pathLayer2.name = "Path 3"
        pathLayer2.bounds = CGRect(x: 0, y: 0, width: 45.988875, height: 32.998019)
        pathLayer2.position = CGPoint(x: 99, y: 28.001981)
        pathLayer2.anchorPoint = CGPoint(x: 0, y: 0)
        pathLayer2.contentsGravity = kCAGravityCenter
        pathLayer2.contentsScale = 2
        pathLayer2.path = pathPath2
        pathLayer2.fillColor = fillColor.cgColor
        pathLayer2.strokeColor = strokeColor.cgColor
        pathLayer2.fillRule = kCAFillRuleEvenOdd
        pathLayer2.lineWidth = 0
        
        runnerLayer.addSublayer(pathLayer2)
        
        iPhoneXLayer.addSublayer(runnerLayer)
        
        self.layer.addSublayer(iPhoneXLayer)
        
    }
    
    // MARK: - Responder
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let location = touches.first?.location(in: self.superview),
            let hitLayer = self.layer.presentation()?.hitTest(location) else { return }
        
        print("Layer \(hitLayer.name ?? String(describing: hitLayer)) was tapped.")
    }
}
