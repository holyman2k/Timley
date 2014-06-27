//
//  WXSwipeTableViewCell.swift
//  Timely
//
//  Created by Charlie Wu on 25/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import UIKit

enum SwipeState : Int {
    case ShortSwipe = 0
    case LongSwipe = 1
    case NoSwipe = 2

    static func Create(state:Int) -> SwipeState {
        switch state {
        case 0:
            return SwipeState.ShortSwipe
        case 1:
            return SwipeState.LongSwipe
        default:
            return SwipeState.NoSwipe
        }
    }
}

enum SwipeDirection : Int {
    case DirectionNone =  0
    case DirectionLeft = 1
    case DirectionRight = 2

    static func Create(direction:Int) -> SwipeDirection {
        switch direction {
        case 0:
            return .DirectionNone
        case 1:
            return .DirectionLeft
        case 2:
            return .DirectionRight
        default:
            return .DirectionNone
        }
    }
}

//@class_protocol
@objc
protocol WXSwipeTableViewCellDelegate {
    func tableViewCellDidEndSwipeWithState(cell:WXSwipeTableViewCell, state:Int, direction:Int)
    func tableViewCellChangedSwipeWithState(cell:WXSwipeTableViewCell, state:Int, direction:Int)
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

    var swipeGesture:UIPanGestureRecognizer?

    override func layoutSubviews()  {
        super.layoutSubviews();

        swipeGesture = UIPanGestureRecognizer(target: self, action: "gestureHandle:")
        swipeGesture!.delegate = self;
        self.addGestureRecognizer(swipeGesture)

        let iconSize:Double = 20.0
        let iconPadding:Double = 18.0
        let posY = (Double(frame.size.height) - iconSize) / 2.0
        let rectLeft = CGRectMake(Float(-iconSize - iconPadding), Float(posY), Float(iconSize), Float(iconSize))
        imageViewLeft = UIImageView(frame: rectLeft)
        imageViewLeft!.backgroundColor = UIColor.clearColor();
        imageViewLeft!.tintColor = UIColor.whiteColor();

        let rectRight = CGRectMake(Float(Double(frame.size.width) + iconPadding), Float(posY), Float(iconSize), Float(iconSize))
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
            moveContentView(offset: Double(point.x), animated: false)
            let (swipeState, direction) = findSwipeState(offset: Double(point.x));
            triggerSwipeDelegate(swipeState: swipeState, direction: direction, swipeEnded: false)
        case .Ended:
            let (swipeState, direction) = findSwipeState(offset: Double(point.x));
            triggerSwipeDelegate(swipeState: swipeState, direction: direction, swipeEnded: true)
        default:()
        }
    }

    func triggerSwipeDelegate(#swipeState:SwipeState, direction:SwipeDirection, swipeEnded:Bool) {

        switch (swipeState, direction, swipeEnded) {
        case (.ShortSwipe, .DirectionLeft, false):
            imageViewRight!.image = iconShortLeft
        case (.ShortSwipe, .DirectionRight, false):
            imageViewLeft!.image = iconShortRight
        case (.LongSwipe, .DirectionLeft, false):
            imageViewRight!.image = iconLongLeft
        case (.LongSwipe, .DirectionRight, false):
            imageViewLeft!.image = iconLongRight
        case (.NoSwipe, _, false):
            imageViewRight!.image = nil
            imageViewLeft!.image = nil
        default: ()
        }

        if let handler = delegate {
            if swipeEnded {
                handler.tableViewCellDidEndSwipeWithState(self, state: swipeState.toRaw(), direction: direction.toRaw())
            } else {
                handler.tableViewCellChangedSwipeWithState(self, state: swipeState.toRaw(), direction: direction.toRaw())
            }
        }

        if (swipeEnded && swipeState == .NoSwipe) {
            self.moveContentView(offset: 0, animated:true)
        }
    }

    func animateSwipe(#direction:SwipeDirection, completed: ()->() = {}) {
        let finalX = direction == .DirectionLeft ? -self.contentView.frame.width : self.contentView.frame.width
        moveContentView(offset: Double(finalX), animated: true, completed: completed)
    }

    func moveContentView(#offset:Double, animated:Bool, completed: ()->() = {}) {
        var block = { ()->() in
            let frame = self.contentView.frame;
            self.contentView.frame = CGRectMake(CGFloat(offset), 0, frame.size.width, frame.size.height);
        }

        if animated {

            UIView.animateWithDuration(0.4, animations: block, completion: { (completion:Bool) in
                completed();

            });
        } else {
            block()
            completed();
        }
    }

    func findSwipeState(#offset:Double) -> (SwipeState, SwipeDirection){

        let direction = offset == 0 ? SwipeDirection.DirectionNone : offset > 0 ? SwipeDirection.DirectionRight : SwipeDirection.DirectionLeft

        let aOffset = abs(offset)
        switch aOffset {
        case let x where x < shortSwipeOffsetWidth:
            return (.NoSwipe, direction)
        case let x where x > shortSwipeOffsetWidth && x < longSwipeOffsetWidth:
            return (.ShortSwipe, direction)
        case let x where x > longSwipeOffsetWidth:x
            return (.LongSwipe, direction)
        default:
            return (.NoSwipe, direction)
        }
    }

    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        if gestureRecognizer === swipeGesture && abs(contentView.frame.origin.x) > 0 {
            return gestureRecognizer.state == UIGestureRecognizerState.Possible;
        }
        return false
    }

    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer!) -> Bool {

        if (gestureRecognizer.isMemberOfClass(UILongPressGestureRecognizer)) {
            return true;
        }

        let panGesture = gestureRecognizer as UIPanGestureRecognizer;
        let translation = panGesture.translationInView(self);
        return fabs(Double(translation.y)) < fabs(Double(translation.x))
    }



//    - (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//    {
//    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
//    return YES;
//
//    CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self];
//    return fabs(translation.y) < fabs(translation.x);
//    }
}
