//
//  ViewController.swift
//  EasySign
//
//  Created by Mykola Zaretskyy on 7/16/18.
//  Copyright © 2018 Mykola Zaretskyy. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var canvasImageView: UIImageView!
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 40.0
    var green: CGFloat = 255.0
    var blue: CGFloat = 22.0
    var swiped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        canvasImageView.backgroundColor = UIColor.blue
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
//
//        // Merge tempImageView into mainImageView
//        UIGraphicsBeginImageContext(mainImageView.frame.size)
//        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: 1.0)
//        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: opacity)
//        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        tempImageView.image = nil
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        canvasImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // 2
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        // 3
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(CGFloat(5))
//        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: CGFloat(1))
        context?.setBlendMode(CGBlendMode.normal)
        
        // 4
        context?.strokePath()
        
        // 5
        canvasImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

