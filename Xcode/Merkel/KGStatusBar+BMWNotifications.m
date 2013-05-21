//
//  KGStatusBar+BMWNotifications.m
//  Merkel
//
//  Created by Tim Shi on 5/21/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "KGStatusBar+BMWNotifications.h"

#import "UIColor+BMW.h"

@implementation KGStatusBar (BMWNotifications)

+ (void)bmwShowErrorWithStatus:(NSString *)status {
    [[self sharedView] showWithStatus:status barColor:[UIColor bmwRedColor] textColor:[UIColor whiteColor]];
}

+ (void)bmwShowSuccessWithStatus:(NSString *)status {
    [[self sharedView] showWithStatus:status barColor:[UIColor bmwGreenColor] textColor:[UIColor whiteColor]];
}

+ (void)bmwShowNetworkConnectionUnavailable {
    [self bmwShowErrorWithStatus:@"Network Connection Unavailable."];
}

+ (void)bmwShowNetworkConnectionAvailable {
    [self bmwShowSuccessWithStatus:@"Network Connection Available."];
}

@end
