////
////  BMWCalendarAccess.h
////  Merkel
////
////  Created by Tim Shi on 4/23/13.
////  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//
//#import <EventKit/EventKit.h>
//
//extern NSString * const BMWCalendarAccessGrantedNotification;
//extern NSString * const BMWCalendarAccessDeniedNotification;
//
//typedef void(^BMWCalendarEventCompletion)(NSArray *events, NSError *error);
//typedef void(^BMWCalendarAuthorizeCompletion)(BOOL granted, NSError *error);
//
//@interface BMWCalendarAccess : NSObject
//
//+ (instancetype)sharedAccess;
//- (void)authorizeCompletion:(BMWCalendarAuthorizeCompletion)completion;
//- (void)getTodaysEventsCompletion:(BMWCalendarEventCompletion)completion;
//
//@property (readonly) BOOL isAuthorized;
//
//@end
