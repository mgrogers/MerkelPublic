//
//  BMWCalendarAccess.m
//  Merkel
//
//  Created by Tim Shi on 4/23/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWCalendarAccess.h"

@interface BMWCalendarAccess ()

@property (nonatomic, retain) EKEventStore *store;
@property (readwrite) BOOL isAuthorized;

@end

@implementation BMWCalendarAccess

NSString * const BMWCalendarAccessGrantedNotification = @"BMWCalendarAccessGrantedNotification";
NSString * const BMWCalendarAccessDeniedNotification = @"BMWCalendarAccessDeniedNotification";

+ (instancetype)sharedAccess {
    static BMWCalendarAccess *sharedAccess = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAccess = [[self alloc] init];
    });
    return sharedAccess;
}

- (id)init {
    self = [super init];
    if (self) {
        self.store = [[EKEventStore alloc] init];
    }
    return self;
}

- (void)authorize {
    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        self.isAuthorized = granted;
        if (granted) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BMWCalendarAccessGrantedNotification object:self];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:BMWCalendarAccessDeniedNotification object:self];
        }
        if (error) {
            NSLog(@"Calendar access error: %@", [error localizedDescription]);
        }
    }];
}

@end
