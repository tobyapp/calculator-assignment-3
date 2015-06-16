//
//  GraphingViewController.swift
//  calculator
//
//  Created by Toby Applegate on 10/06/2015.
//  Copyright (c) 2015 Toby Applegate. All rights reserved.
//

import UIKit

@IBDesignable

class GraphingViewController: UIView {
    
    var graphCentre : CGPoint {
        return convertPoint(center, fromView: superview) //wants to be centre of axis (in middle of grph (0,0)) is super view because thats where it gets its coordinates from (a ssuper view can change depending on device i think)
    }
    
        
    @IBInspectable
    var scale : CGFloat = 25 { didSet { setNeedsDisplay() } }
    
    override func drawRect(rect: CGRect) { //need to overide drawrect todraw something
        //let path = UIBezierPath()
        //path.moveToPoint(CGPoint(x: 80,y: 50))
        //path.addLineToPoint(CGPoint(x: 140,y: 150))
        //path.addLineToPoint(CGPoint(x: 10,y: 150))
        //UIColor.greenColor().setFill()
        //UIColor.redColor().setStroke()
        //path.lineWidth = 3.0
        //path.fill()
        //path.closePath()
        
        //        let y = CGPoint(x: 100, y: 100)
        //        let q = CGPoint(x: 150, y: 150)
        //        let z = CGFloat(5)
        //        let a = CGSize(width: 50, height: 50)
        //        let r = CGRect(origin: q, size: a)
        
        println("graph center : \(graphCentre)")

        
        
        //{ didSet { println("changed!") setNeedsDisplay() } } //if answer changes redraw

        
        var point = CGPoint(x: 0.0, y: 0.0) //defines a point in the view (a single point)
        var size = CGSize(width: 800, height: 800) // defines how long each axis is
        var bounds = CGRect(origin: point, size: size) //descirbes area drawing in in own co-ordinate system e.g. scroll view's bound constantly changes when scroll through a page
        //var origin = CGPoint(x: 200, y: 200) //wants to be centre of axis (in middle of grph (0,0))
        //var scale = CGFloat(25) //need to change this scale depending on the answer of the maths equeation e.g. if sin(m) = 5 or = 50000 etc lol
        
        let x = AxesDrawer()
        x.drawAxesInRect(bounds, origin: graphCentre, pointsPerUnit: scale) //bounds area to draw in UIView    I THINK
        
        let frame = UIView()
        
        //var contentScaleFactor : CGFloat
        
       let test = frame.contentScaleFactor

        println("frame.contentScaleFactor = \(test)")
     
        //func drawAxesInRect(bounds: CGRect, origin: CGPoint, pointsPerUnit: CGFloat)
        
        //var contentMode: UIViewContentMode//start from here in lecture 5
        

        
    }
    
    
    }

