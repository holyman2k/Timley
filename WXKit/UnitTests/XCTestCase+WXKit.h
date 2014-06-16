//
//  XCTestCase+WXKit.h
//  Defects
//
//  Created by Charlie Wu on 30/04/2014.
//  Copyright (c) 2014 WebFM Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCase (WXKit)

/*!
 * @brief keep runloop going; start asynchronise task and wait for completeAsynchronousTask or safelyCompleteAsynchronousTask
 */
- (void)waitForAsynchronousTask;

/*!
 * @brief stop runloop; asychronise task completed
 */
- (void)completeAsynchronousTask;

/*!
 * @brief same as completeAsynchronousTask but thread safe
 */
- (void)safelyCompleteAsynchronousTask;

@end
