//
//  IphoneXView.swift
//  Exported from Kite Compositor for Mac 1.9.1
//
//  Created on 4/17/18, 7:14 PM.
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
        pathPath.move(to: CGPoint(x: 0.591132, y: 60.527916))
        pathPath.addLine(to: CGPoint(x: 47.038345, y: 16.652954))
        pathPath.addCurve(to: CGPoint(x: 42.548527, y: 2.643147), control1: CGPoint(x: 41.051922, y: 11.433856), control2: CGPoint(x: 39.555317, y: 6.76392))
        pathPath.addCurve(to: CGPoint(x: 61.827251, y: 4.735849), control1: CGPoint(x: 45.54174, y: -1.477627), control2: CGPoint(x: 51.967979, y: -0.78006))
        pathPath.addCurve(to: CGPoint(x: 85.961212, y: 27.682713), control1: CGPoint(x: 78.587967, y: 17.358755), control2: CGPoint(x: 86.632622, y: 25.00771))
        pathPath.addCurve(to: CGPoint(x: 75.905052, y: 41.218899), control1: CGPoint(x: 85.499916, y: 31.207716), control2: CGPoint(x: 85.672462, y: 36.157234))
        pathPath.addCurve(to: CGPoint(x: 34.683521, y: 49.017906), control1: CGPoint(x: 64.847229, y: 46.949287), control2: CGPoint(x: 36.903252, y: 51.495312))
        pathPath.addLine(to: CGPoint(x: 69.718117, y: 31.221598))
        pathPath.addCurve(to: CGPoint(x: 63.601948, y: 26.134645), control1: CGPoint(x: 69.406906, y: 29.390921), control2: CGPoint(x: 67.368187, y: 27.695269))
        pathPath.addCurve(to: CGPoint(x: 40.143417, y: 41.218899), control1: CGPoint(x: 51.012657, y: 34.498886), control2: CGPoint(x: 43.193146, y: 39.526974))
        pathPath.addCurve(to: CGPoint(x: 34.683521, y: 44.280476), control1: CGPoint(x: 38.389885, y: 42.191723), control2: CGPoint(x: 35.296349, y: 44.181915))
        pathPath.addCurve(to: CGPoint(x: 7.077745, y: 58.878742), control1: CGPoint(x: 16.279671, y: 54.012653), control2: CGPoint(x: 7.077745, y: 58.878742))
        pathPath.addCurve(to: CGPoint(x: 1.554957, y: 60.992439), control1: CGPoint(x: 5.071686, y: 60.243), control2: CGPoint(x: 3.230757, y: 60.947567))
        pathPath.addCurve(to: CGPoint(x: 0.591132, y: 60.527916), control1: CGPoint(x: -0.120842, y: 61.037312), control2: CGPoint(x: -0.442117, y: 60.882469))
        pathPath.closeSubpath()
        pathPath.move(to: CGPoint(x: 0.591132, y: 60.527916))
        
        let ovalPath = CGMutablePath()
        ovalPath.move(to: CGPoint(x: 19.5, y: 11))
        ovalPath.addCurve(to: CGPoint(x: 39, y: 5.5), control1: CGPoint(x: 30.269552, y: 11), control2: CGPoint(x: 39, y: 8.537566))
        ovalPath.addCurve(to: CGPoint(x: 19.5, y: 0), control1: CGPoint(x: 39, y: 2.462434), control2: CGPoint(x: 30.269552, y: 0))
        ovalPath.addCurve(to: CGPoint(x: 0, y: 5.5), control1: CGPoint(x: 8.730448, y: 0), control2: CGPoint(x: 0, y: 2.462434))
        ovalPath.addCurve(to: CGPoint(x: 19.5, y: 11), control1: CGPoint(x: 0, y: 8.537566), control2: CGPoint(x: 8.730448, y: 11))
        ovalPath.closeSubpath()
        ovalPath.move(to: CGPoint(x: 19.5, y: 11))
        
        let ovalPath1 = CGMutablePath()
        ovalPath1.move(to: CGPoint(x: 12.5, y: 23))
        ovalPath1.addCurve(to: CGPoint(x: 25, y: 11.5), control1: CGPoint(x: 19.403559, y: 23), control2: CGPoint(x: 25, y: 17.851274))
        ovalPath1.addCurve(to: CGPoint(x: 12.5, y: 0), control1: CGPoint(x: 25, y: 5.148726), control2: CGPoint(x: 19.403559, y: 0))
        ovalPath1.addCurve(to: CGPoint(x: 0, y: 11.5), control1: CGPoint(x: 5.596441, y: 0), control2: CGPoint(x: 0, y: 5.148726))
        ovalPath1.addCurve(to: CGPoint(x: 12.5, y: 23), control1: CGPoint(x: 0, y: 17.851274), control2: CGPoint(x: 5.596441, y: 23))
        ovalPath1.closeSubpath()
        ovalPath1.move(to: CGPoint(x: 12.5, y: 23))
        
        let pathPath1 = CGMutablePath()
        pathPath1.move(to: CGPoint(x: 1.810478, y: 38))
        pathPath1.addCurve(to: CGPoint(x: 4.113055, y: 8.481183), control1: CGPoint(x: -1.215737, y: 23.437437), control2: CGPoint(x: -0.448212, y: 13.597831))
        pathPath1.addCurve(to: CGPoint(x: 32.695965, y: 2.764267), control1: CGPoint(x: 10.954955, y: 0.806211), control2: CGPoint(x: 19.401352, y: -2.952648))
        pathPath1.addCurve(to: CGPoint(x: 45.990578, y: 20.154545), control1: CGPoint(x: 45.990578, y: 8.481183), control2: CGPoint(x: 46.067257, y: 19.769701))
        pathPath1.addCurve(to: CGPoint(x: 45.190777, y: 21.972469), control1: CGPoint(x: 45.95644, y: 20.325867), control2: CGPoint(x: 45.940838, y: 21.340832))
        pathPath1.addCurve(to: CGPoint(x: 42.153675, y: 23.164286), control1: CGPoint(x: 44.255959, y: 22.759697), control2: CGPoint(x: 42.521721, y: 23.171282))
        pathPath1.addCurve(to: CGPoint(x: 29.532545, y: 18.205114), control1: CGPoint(x: 41.490318, y: 23.15168), control2: CGPoint(x: 34.450928, y: 24.464792))
        pathPath1.addCurve(to: CGPoint(x: 17.873535, y: 11.945437), control1: CGPoint(x: 26.253622, y: 14.031996), control2: CGPoint(x: 22.367285, y: 11.945437))
        pathPath1.addCurve(to: CGPoint(x: 6.642778, y: 24.890774), control1: CGPoint(x: 13.036413, y: 13.653346), control2: CGPoint(x: 9.292828, y: 17.968458))
        pathPath1.addCurve(to: CGPoint(x: 1.810478, y: 38), control1: CGPoint(x: 3.99273, y: 31.813089), control2: CGPoint(x: 2.381963, y: 36.182831))
        pathPath1.closeSubpath()
        pathPath1.move(to: CGPoint(x: 1.810478, y: 38))
        
        let pathPath2 = CGMutablePath()
        pathPath2.move(to: CGPoint(x: 7.194646, y: 4.541625))
        pathPath2.addCurve(to: CGPoint(x: 9.890882, y: 5.92593), control1: CGPoint(x: 8.553073, y: 5.116388), control2: CGPoint(x: 9.451818, y: 5.577823))
        pathPath2.addCurve(to: CGPoint(x: 14.405637, y: 12.839663), control1: CGPoint(x: 12.63053, y: 8.098024), control2: CGPoint(x: 13.777154, y: 10.51525))
        pathPath2.addCurve(to: CGPoint(x: 25.846066, y: 21.036514), control1: CGPoint(x: 15.574986, y: 17.164446), control2: CGPoint(x: 20.990501, y: 23.577374))
        pathPath2.addCurve(to: CGPoint(x: 44.128681, y: 0.001982), control1: CGPoint(x: 30.701632, y: 18.495653), control2: CGPoint(x: 46.8368, y: 1.861468))
        pathPath2.addCurve(to: CGPoint(x: 45.843548, y: 0.001982), control1: CGPoint(x: 45.065536, y: 0.004596), control2: CGPoint(x: 45.637157, y: 0.004596))
        pathPath2.addCurve(to: CGPoint(x: 40.287682, y: 19.953674), control1: CGPoint(x: 46.156452, y: -0.001982), control2: CGPoint(x: 46.538029, y: 12.368549))
        pathPath2.addCurve(to: CGPoint(x: 31.247147, y: 28.872286), control1: CGPoint(x: 37.617943, y: 23.193544), control2: CGPoint(x: 34.758053, y: 26.48069))
        pathPath2.addCurve(to: CGPoint(x: 17.566809, y: 32.646145), control1: CGPoint(x: 26.538382, y: 32.079853), control2: CGPoint(x: 21.097843, y: 33.785534))
        pathPath2.addCurve(to: CGPoint(x: 0.297083, y: 16.493471), control1: CGPoint(x: 11.402997, y: 30.657219), control2: CGPoint(x: 1.491158, y: 24.968143))
        pathPath2.addCurve(to: CGPoint(x: 2.715775, y: 5.671114), control1: CGPoint(x: -0.896992, y: 8.018798), control2: CGPoint(x: 1.835854, y: 6.081121))
        pathPath2.addCurve(to: CGPoint(x: 5.332663, y: 4.541625), control1: CGPoint(x: 3.139678, y: 5.473593), control2: CGPoint(x: 3.962196, y: 4.846882))
        pathPath2.addCurve(to: CGPoint(x: 7.194646, y: 4.541625), control1: CGPoint(x: 5.683358, y: 4.463511), control2: CGPoint(x: 6.304018, y: 4.463511))
        pathPath2.closeSubpath()
        pathPath2.move(to: CGPoint(x: 7.194646, y: 4.541625))
        
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
        runnerLayer.position = CGPoint(x: 187.5, y: 411)
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
        transformScaleXyAnimation1.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.49321
        transformScaleXyAnimation1.duration = 0.5
        transformScaleXyAnimation1.fillMode = kCAFillModeForwards
        transformScaleXyAnimation1.isRemovedOnCompletion = false
        transformScaleXyAnimation1.keyPath = "transform.scale.xy"
        transformScaleXyAnimation1.toValue = 2.3
        transformScaleXyAnimation1.fromValue = 0.5
        transformScaleXyAnimation1.stiffness = 200
        transformScaleXyAnimation1.damping = 10
        transformScaleXyAnimation1.mass = 0.7
        transformScaleXyAnimation1.initialVelocity = 4
        
        runnerLayer.add(transformScaleXyAnimation1, forKey: "transformScaleXyAnimation1")
        
        // opacity
        //
        let opacityAnimation = CABasicAnimation()
        opacityAnimation.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.49321
        opacityAnimation.duration = 0.773457
        opacityAnimation.fillMode = kCAFillModeForwards
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
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
        ovalLayer.transform = CATransform3D( m11: 0.809497, m12: -0.587124, m13: 0, m14: 0,
                                             m21: 0.587124, m22: 0.809497, m23: 0, m24: 0,
                                             m31: 0, m32: 0, m33: 1, m34: 0,
                                             m41: 0, m42: 0, m43: 0, m44: 1 )
        ovalLayer.sublayerTransform = CATransform3D( m11: 1, m12: 0, m13: 0, m14: 0,
                                                     m21: -0, m22: 1, m23: 0, m24: 0,
                                                     m31: -0, m32: -0, m33: 1, m34: 0,
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
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
//    {
//        guard let location = touches.first?.location(in: self.superview),
//            let hitLayer = self.layer.presentation()?.hitTest(location) else { return }
//        
//        print("Layer \(hitLayer.name ?? String(describing: hitLayer)) was tapped.")
//    }
}
