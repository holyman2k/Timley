//
//  TimelyTableViewControllerScrollExtension.swift
//  Timely
//
//  Created by Charlie Wu on 20/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import Foundation

extension TimelyTableViewController {

    // #program mark - scroll delegates

    override func scrollViewDidScroll(scrollView: UIScrollView!){
        if scrollView.contentOffset.y < 0 {
            var offset = max(-scrollView.contentOffset.y - 64 - 20, 0)
            var addIconAlpha = min(CGFloat(offset) / CGFloat(-addIcon.frame.origin.y), 1)
            addIcon.alpha = addIconAlpha
            if addIcon.alpha == 1 {
                addIcon.tintColor = self.view.tintColor
            } else {
                addIcon.tintColor = UIColor(white: 0.6, alpha: 0.8)
            }
        }
    }
    override func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        if addIcon.alpha == 1 {
            self.performSegueWithIdentifier("add", sender: self)
        }
    }
}