//
//  XCTestCase+WXKit.m
//  Defects
//
//  Created by Charlie Wu on 30/04/2014.
//  Copyright (c) 2014 WebFM Pty Ltd. All rights reserved.
//

#import "XCTestCase+WXKit.h"

@implementation XCTestCase (WXKit)

- (void)waitForAsynchronousTask
{
    CFRunLoopRun();
}

- (void)completeAsynchronousTask
{
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)safelyCompleteAsynchronousTask
{
    if ([NSThread isMainThread]) {
        [self completeAsynchronousTask];
    } else {
        [self performSelectorOnMainThread:@selector(completeAsynchronousTask)
                               withObject:nil
                            waitUntilDone:YES];
    }
}

@end
