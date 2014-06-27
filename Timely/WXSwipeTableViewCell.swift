//
//  WXSwipeTableViewCell.swift
//  Timely
//
//  Created by Charlie Wu on 25/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import UIKit



enum SwipeState :Int {
    case ShortLeftSwipe = 0
    case LongLeftSwipe = 1
    case ShortRightSwipe = 2
    case LongRightSwipe = 3
    case NoSwipe = 4

    static func Create(state:Int) -> SwipeState {
        switch state {
        case 0:
            return SwipeState.ShortLeftSwipe
        case 1:
            return SwipeState.LongLeftSwipe
        case 2:
            return SwipeState.ShortRightSwipe
        case 3:
            return SwipeState.LongRightSwipe
        case 4:
            return SwipeState.NoSwipe
        default:
            return SwipeState.NoSwipe
        }
    }
}

enum SwipeDirection {
    case SwipeLeft
    case SwipeRight
}

//@class_protocol
@objc
protocol WXSwipeTableViewCellDelegate {
    func tableViewCellDidEndSwipeWithState(cell:WXSwipeTableViewCell, state:Int)
    func tableViewCellChangedSwipeWithState(cell:WXSwipeTableViewCell, state:Int)
}

class WXSwipeTableViewCell: UITableViewCell {


    weak var delegate:WXSwipeTableViewCellDelegate?

    var allowSwipeLeft:Bool = false
    var allowSwipeRight:Bool = false

    var shortSwipeOffsetWidth:Double = 96
    var longSwipeOffsetWidth:Double = 210

    var iconShortLeft:UIImage?
    var iconLongLeft:UIImage?
    var iconShortRight:UIImage?
    var iconLongRight:UIImage?

    var imageViewLeft:UIImageView?
    var imageViewRight:UIImageView?

    override func layoutSubviews()  {
        super.layoutSubviews();

        let gesture = UIPanGestureRecognizer(target: self, action: "gestureHandle:")
        self.addGestureRecognizer(gesture)

        let iconSize = 20.0
        let iconPadding = 18.0
        let posY = (frame.size.height - iconSize) / 2
        let rectLeft = CGRectMake(-iconSize - iconPadding, posY, iconSize, iconSize)
        imageViewLeft = UIImageView(frame: rectLeft)
        imageViewLeft!.backgroundColor = UIColor.clearColor();
        imageViewLeft!.tintColor = UIColor.whiteColor();

        let rectRight = CGRectMake(frame.size.width + iconPadding, posY, iconSize, iconSize)
        imageViewRight = UIImageView(frame: rectRight)
        imageViewRight!.backgroundColor = UIColor.clearColor();
        imageViewRight!.tintColor = UIColor.whiteColor();

        contentView.addSubview(imageViewLeft)
        contentView.addSubview(imageViewRight)
    }

    override func prepareForReuse()  {
        super.prepareForReuse();

        moveContentView(offset: 0, animated: false)
        self.contentView.backgroundColor = UIColor.whiteColor()
    }

    func gestureHandle(gesture:UIPanGestureRecognizer) {

        let point = gesture.translationInView(self.contentView);

        if point.x > 0 && !allowSwipeRight { return }
        if point.x < 0 && !allowSwipeLeft { return }

        switch gesture.state {
        case .Began:()
        case .Changed:
            moveContentView(offset: point.x, animated: false)
            let state = findSwipeState(offset: point.x);
            triggerSwipeDelegate(swipeState: state, swipeEnded: false)
        case .Ended:
            let state = findSwipeState(offset: point.x);
            triggerSwipeDelegate(swipeState: state, swipeEnded: true)
        default:()
        }

    }

    func triggerSwipeDelegate(#swipeState:SwipeState, swipeEnded:Bool) {

        switch (swipeState, swipeEnded) {
        case (.ShortLeftSwipe, false):
            imageViewRight!.image = iconShortLeft
        case (.ShortRightSwipe, false):
            imageViewLeft!.image = iconShortRight
        case (.LongLeftSwipe, false):
            imageViewRight!.image = iconLongLeft
        case (.LongRightSwipe, false):
            imageViewLeft!.image = iconLongRight
        case (.NoSwipe, false):
            imageViewRight!.image = nil
            imageViewLeft!.image = nil
        default: ()
        }

        if let handler = delegate {
            if swipeEnded {
                handler.tableViewCellDidEndSwipeWithState(self, state: swipeState.toRaw())
            } else {
                handler.tableViewCellChangedSwipeWithState(self, state: swipeState.toRaw())
            }
        }

        if (swipeEnded && swipeState == .NoSwipe) {
            self.moveContentView(offset: 0, animated:true)
        }
    }

    func animateSwipe(#direction:SwipeDirection, completed: ()->() = {}) {
        let finalX = direction == .SwipeLeft ? -self.contentView.frame.width : self.contentView.frame.width
        moveContentView(offset: finalX, animated: true, completed: completed)
    }

    func moveContentView(#offset:Double, animated:Bool, completed: ()->() = {}) {
        var block = { ()->() in
            let frame = self.contentView.frame;
            self.contentView.frame = CGRectMake(offset, 0, frame.size.width, frame.size.height);
        }

        if animated {

            UIView.animateWithDuration(0.7, animations: block, completion: { (isCompleted:Bool) in

                dispatch_after(10, dispatch_get_main_queue(), completed);
            })

        } else {
            block()
            completed();
        }
    }

    func findSwipeState(#offset:Double) -> SwipeState {

        let direction = offset > 0 ? SwipeDirection.SwipeRight : SwipeDirection.SwipeLeft

        let aOffset = abs(offset)

        if aOffset > shortSwipeOffsetWidth && aOffset < longSwipeOffsetWidth {
            if direction == SwipeDirection.SwipeRight {
                return .ShortRightSwipe
            } else {
                return .ShortLeftSwipe
            }
        } else if aOffset > longSwipeOffsetWidth {
            if direction == SwipeDirection.SwipeRight {
                return .LongRightSwipe
            } else {
                return .ShortLeftSwipe
            }
        }
        return .NoSwipe
    }
}