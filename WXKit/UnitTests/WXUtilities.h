//
//  Utilities.h
//  WXKit
//
//  Created by Charlie Wu on 30/04/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#ifndef WXKit_Utilities_h
#define WXKit_Utilities_h

/*!
 * @brief suspend queue till value is true, will not block main thread
 * @param value     value that is waited to be true
 */
#define wait_while(condition, timeout)\
NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:timeout];\
while (!condition && [loopUntil timeIntervalSinceNow] > 0) {\
[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];\
}


#endif
