//
//  BMWCalendarAccess.h
//  Merkel
//
//  Created by Tim Shi on 4/23/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <EventKit/EventKit.h>

extern NSString * const BMWCalendarAccessGrantedNotification;
extern NSString * const BMWCalendarAccessDeniedNotification;

@interface BMWCalendarAccess : NSObject

+ (instancetype)sharedAccess;
- (void)authorize;

@property (readonly) BOOL isAuthorized;

@end
