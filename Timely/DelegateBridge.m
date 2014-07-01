//
//  DelegateBridge.m
//  Timely
//
//  Created by Charlie Wu on 19/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "DelegateBridge.h"

@implementation DelegateBridge

- (void)bridgeInitalizer
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8) {

        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound
                                                | UIUserNotificationTypeAlert
                                                | UIUserNotificationTypeBadge categories:nil];

        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

    }
}

@end