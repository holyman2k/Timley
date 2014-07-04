// Playground - noun: a place where people can play

import UIKit

//var str = "Hello, playground"
//
//let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//view.layer.cornerRadius = 15
//view.backgroundColor = UIColor.redColor()
//view


let names = ["me", "you", "him", "her"]

names.sort({(a, b) -> Bool in
    return a < b
})

names