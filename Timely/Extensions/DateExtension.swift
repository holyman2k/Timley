//
//  DateExtension.swift
//  Timely
//
//  Created by Charlie Wu on 16/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import Foundation

extension NSDate {
    func dateTimeStringLong() -> String {
        let pattern = "dd-MM-yyyy";
        if dateString(pattern) == NSDate.date().dateString(pattern) {
            return "Today"
        }
        return dateString("MMMM d, 'at' h:mm a")
    }

    func dateString(pattern:String) -> String {
        var formatter = NSDateFormatter();
        formatter.dateFormat = pattern;
        return formatter.stringFromDate(self)
    }
}