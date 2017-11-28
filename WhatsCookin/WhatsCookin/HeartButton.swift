//
//  HeartButton.swift
//  WhatsCookin
//
//  Created by Devontae Reid on 10/31/15.
//  Copyright © 2015 Devontae Reid. All rights reserved.
//

import UIKit

class HeartButton: UIButton {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        drawHeart(rect)
    }

    
    var buttonStrokeColor: UIColor = UIColor.deepPink(1.0)
    
    var fillColor: UIColor = UIColor.lightGrayColor()
    
    
    func drawHeart(rect: CGRect)
    {
       let context = UIGraphicsGetCurrentContext()
        
        // Move the X-origin to center to simplify
        CGContextTranslateCTM(context, CGRectGetMidX(rect), 0);

        
        CGContextSetLineWidth(context, 3.0);
        CGContextSetLineJoin(context, .Round);
        CGContextSetStrokeColorWithColor(context, buttonStrokeColor.CGColor);
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        
        // Start and End points
        let startPoint: CGPoint = CGPoint(x: 0.0, y: 115.0)
        let endPoint: CGPoint = CGPoint(x: 0.0, y: 300.0)
 
       
        
        // First control point (top)
        let cp1: CGPoint = CGPoint(x: 75.0, y: 15.0)
        // Second control point (bottom)
        let cp2: CGPoint = CGPoint(x: 220.0, y: 130.0)

        // Begin new path and move to starting point
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);

        // Draw Right Side
        CGContextAddCurveToPoint(context, cp1.x, cp1.y, cp2.x, cp2.y, endPoint.x, endPoint.y);
        // Draw Light Side
        CGContextAddCurveToPoint(context, -cp2.x, cp2.y, -cp1.x, cp1.y, startPoint.x, startPoint.y);

        // Close and draw path
        CGContextClosePath(context);
        CGContextDrawPath(context, .Stroke)

    }
    
//    var isLiked: Bool = true {
//        didSet {
//            buttonStrokeColor = UIColor.deepPink(0.5)
//        }
//    }
    

}
