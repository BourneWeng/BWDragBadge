//
//  DragBadge.swift
//  DragView
//
//  Created by BourneWeng on 15/7/16.
//  Copyright (c) 2015年 Bourne. All rights reserved.
//

import UIKit

class DragBadge: UIView {

    var maxLength: CGFloat! = 100
    var dragColor: UIColor! = UIColor.redColor()
    var title: String! {
        didSet {
            if self.titleLabel != nil {
                self.titleLabel.text = title
            }
        }
    }
    
    private var backView: UIView!
    private var titleLabel: UILabel!
    private var dragLayer: CAShapeLayer!
    private var path: UIBezierPath!
    private var backViewWidth: CGFloat!
    
    private var point1: CGPoint!
    private var point2: CGPoint!
    private var r1: CGFloat!
    private var r2: CGFloat!
    
    private var pointA: CGPoint!
    private var pointB: CGPoint!
    private var pointC: CGPoint!
    private var pointD: CGPoint!
    
    private var pointM: CGPoint!
    private var pointN: CGPoint!
    
    func setUp() {
        //self
        self.layer.cornerRadius = self.bounds.width / 2.0
        self.layer.masksToBounds = true
        self.backgroundColor = self.dragColor
        self.backViewWidth = self.bounds.width * 0.6
        
        //title
        self.titleLabel = UILabel(frame: self.bounds)
        self.addSubview(self.titleLabel)
        self.titleLabel.font = UIFont.systemFontOfSize(12)
        self.titleLabel.textColor = UIColor.whiteColor()
        self.titleLabel.textAlignment = NSTextAlignment.Center
        if self.title != nil {
            self.titleLabel.text = self.title
        }
        
        //backView
        self.backView = UIView(frame: CGRectMake(0, 0, self.backViewWidth, self.backViewWidth))
        self.backView.center = self.center
        self.backView.layer.cornerRadius = self.backViewWidth / 2.0
        self.backView.backgroundColor = self.dragColor
        self.superview?.insertSubview(self.backView, belowSubview: self)
        
        //dragLayer
        self.dragLayer = CAShapeLayer()
        self.dragLayer.fillColor = self.dragColor.CGColor

        //Points
        point1 = self.backView.center
        point2 = self.center
        r1 = self.backView.bounds.width / 2.0
        r2 = self.bounds.width / 2.0
        
        //手势
        let pan = UIPanGestureRecognizer(target: self, action: Selector("panGesture:"))
        self.addGestureRecognizer(pan)
    }
    
    func panGesture(pan: UIPanGestureRecognizer) {
        let point = pan.locationInView(self.superview)
        let trans = pan.translationInView(self.superview!)
        
        
        if pan.state == UIGestureRecognizerState.Began {
            self.backView.hidden = false
            self.superview?.layer.insertSublayer(self.dragLayer, below: self.backView.layer)
            self.setNeedsDisplay()
            
        } else if pan.state == UIGestureRecognizerState.Changed {
            let d: CGFloat = sqrt(trans.x * trans.x + trans.y * trans.y)
            
            if d < self.maxLength {
                self.setNeedsDisplay()
            } else {
                self.backView.hidden = true
                self.dragLayer.removeFromSuperlayer()
            }
            
            self.center = point
        } else if pan.state == .Ended || pan.state == .Cancelled || pan.state == .Failed {
            self.backView.hidden = true
            self.dragLayer.removeFromSuperlayer()
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.center = self.backView.center
                }, completion: { (finish: Bool) -> Void in
                    self.backView.hidden = false
            })
        }
        
        
        
        
        
    }
    
    func calculatePoints() {
        point2 = self.center
        let h = point2.x - point1.x
        let v = point2.y - point1.y
        let d = sqrt(h * h + v * v)
        let cos = d == 0 ? 1 : (v / d)
        let sin = d == 0 ? 0 : (h / d)
        r1 = self.backViewWidth * (((1 - d / self.maxLength) * 0.6) + 0.4) / 2.0
        
        pointA = CGPointMake(point1.x - r1 * cos, point1.y + r1 * sin)
        pointB = CGPointMake(point1.x + r1 * cos, point1.y - r1 * sin)
        pointC = CGPointMake(point2.x + r2 * cos, point2.y - r2 * sin)
        pointD = CGPointMake(point2.x - r2 * cos, point2.y + r2 * sin)
        
        pointM = CGPointMake(pointA.x + (d / 2) * sin, pointA.y + (d / 2) * cos)
        pointN = CGPointMake(pointB.x + (d / 2) * sin, pointB.y + (d / 2) * cos)
    }
    
    override func drawRect(rect: CGRect) {
        calculatePoints()
        
        self.path = UIBezierPath()
        self.path.moveToPoint(pointA)
        self.path.addLineToPoint(pointB)
        self.path.addQuadCurveToPoint(pointC, controlPoint: pointN)
        self.path.addLineToPoint(pointD)
        self.path.addQuadCurveToPoint(pointA, controlPoint: pointM)

        if !self.backView.hidden {
            self.dragLayer.path = self.path.CGPath
            self.backView.bounds = CGRectMake(0, 0, r1 * 2, r1 * 2)
            self.backView.layer.cornerRadius = r1
        }
    }

}
