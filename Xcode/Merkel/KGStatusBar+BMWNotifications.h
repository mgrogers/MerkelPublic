//
//  KGStatusBar+BMWNotifications.h
//  Merkel
//
//  Created by Tim Shi on 5/21/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <KGStatusBar/KGStatusBar.h>

@interface KGStatusBar (BMWNotifications)

+ (void)bmwShowErrorWithStatus:(NSString *)status;
+ (void)bmwShowSuccessWithStatus:(NSString *)status;
+ (void)bmwShowNetworkConnectionUnavailable;
+ (void)bmwShowNetworkConnectionAvailable;

@end
