// Playground - noun: a place where people can play

import Cocoa
import Swift
//import XCPlayground
//import CoreData
//
//let color = UIColor.blackColor()
//
//var image = UIImage(named: "Easter-Bell-icon.png")
//
//image = image.imageWithRenderingMode(.AlwaysTemplate)
//
//let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
//
//imageView.tintColor = UIColor.redColor()
//
//imageView.image = image
//
//imageView
//
//var url = NSURL(string: "http://www.google.com")


//var number = Int[]()
//
//for i in 0..20 {
//    number.append(Int(arc4random()) % 100)
//
//}
//
//number
//
//var num = number.map { (i) -> Int in
//    return i + 10
//}
//
//num

//dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//    println("hello")
//})
//
//XCPExecutionShouldContinueIndefinitely()

class Account :Printable, Equatable {
    let name:NSString

    init(_ name:String) {
        self.name = name
    }


    var description: String {
    get {
        return "hello"
    }
    }
}

func ==(lhs: Account, rhs: Account) -> Bool {
    return lhs.name == rhs.name
}

let me = Account("Charlie")

let you = Account("You")

println(me)

let match = me == you

match












