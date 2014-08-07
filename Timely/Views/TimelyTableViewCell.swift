//
//  TimelyTableViewCell.swift
//  Timely
//
//  Created by Charlie Wu on 25/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import UIKit

class TimelyTableViewCell: WXSwipeTableViewCell {

    @IBOutlet var taskNameTopConstraint: NSLayoutConstraint!
    @IBOutlet var taskNameLabel:UILabel!;

    @IBOutlet var taskDueDateLabel:UILabel!;

    override func layoutSubviews() {
        super.layoutSubviews()
        allowSwipeRight = true
        shortSwipeOffsetWidth = frame.size.width.d * 0.25
        longSwipeOffsetWidth = frame.size.width.d * 0.55

        iconShortRight = UIImage(named: "tick").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
        iconLongRight  = UIImage(named: "cross").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);

        self.contentView.backgroundColor = UIColor.whiteColor()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.contentView.backgroundColor = UIColor.whiteColor()
    }
}
