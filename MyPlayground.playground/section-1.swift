// Playground - noun: a place where people can play

import UIKit
import QuartzCore
import XCPlayground

let view = UIView(frame: CGRectMake(0, 0, 200, 200))

let path = UIBezierPath(arcCenter: CGPointMake(10, 10), radius: 60, startAngle: 0, endAngle: 2 * M_PI, clockwise: true)
path.lineWidth = 5

path

let cycle = UIView(frame: CGRectMake(0, 0, 40, 40))

cycle.backgroundColor = UIColor.redColor()

view.addSubview(cycle)

let animation = CABasicAnimation(keyPath: "position.x")
animation.additive = true
//animation.path = path.CGPath
animation.duration = 4
animation.repeatCount = 10
animation.toValue = 25

cycle.layer.addAnimation(animation, forKey: "follow a cycle")

view