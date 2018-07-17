//
//  ViewController.swift
//  EasySign
//
//  Created by Mykola Zaretskyy on 7/16/18.
//  Copyright © 2018 Mykola Zaretskyy. All rights reserved.
//

import UIKit

class CreateSignViewController: UIViewController {
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var pointView: UIView!
    @IBOutlet weak var pointViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var pointViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var brushWidthSlider: UISlider! {
        didSet {
            brushWidthSlider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        }
    }
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 255.0
    var green: CGFloat = 250.0
    var blue: CGFloat = 34.0
    var opacity: CGFloat = 1.0
    var currentBrushWidth: CGFloat = 5
    var brushColor: UIColor?
    var swiped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brushColor = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        adjustPointView(currentBrushWidth)
        brushWidthSlider.value = Float(currentBrushWidth)
    }
    
    private func adjustPointView(_ diameter: CGFloat) {
        pointView.backgroundColor = brushColor!
        pointViewWidthConstraint.constant = diameter
        pointViewHeightConstraint.constant = diameter
        pointView.layer.cornerRadius = diameter/2
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        currentBrushWidth = CGFloat(brushWidthSlider.value)
        adjustPointView(currentBrushWidth)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }

        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(view.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        tempImageView.image = nil
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(currentBrushWidth)
        context?.setStrokeColor(brushColor!.cgColor)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

