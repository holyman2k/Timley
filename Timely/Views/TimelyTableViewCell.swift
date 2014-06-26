//
//  TimelyTableViewCell.swift
//  Timely
//
//  Created by Charlie Wu on 25/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import UIKit

class TimelyTableViewCell: WXSwipeTableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
//        allowSwipeLeft = true
        allowSwipeRight = true
        shortSwipeOffsetWidth = self.frame.size.width * 0.25
        longSwipeOffsetWidth = self.frame.size.width * 0.55
    }
}
