//
//  UIColorExtension.swift
//  Timely
//
//  Created by Charlie Wu on 27/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import Foundation

extension UIColor {
    class func colorTaskName() -> UIColor {
        return UIColor(white: 0.37, alpha: 1)
    }

    class func colorTaskNameDue() -> UIColor {
        return UIColor(red: 0.77, green: 0.22, blue: 0.21, alpha: 1)
    }

    class func colorTaskDetail() -> UIColor {
        return UIColor(white: 0.427, alpha: 1)
    }

    class func colorTaskCompleted() -> UIColor {
        return UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
    }

    class func colorTaskDelete() -> UIColor {
        return self.colorTaskNameDue();
    }
}