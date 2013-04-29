//
//  BMWCalendarAccess.m
//  Merkel
//
//  Created by Tim Shi on 4/23/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWCalendarAccess.h"
#import "BMWAPIClient.h"

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

- (void)authorizeCompletion:(BMWCalendarAuthorizeCompletion)completion {
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
        if (completion) {
            completion(granted, error);
        }
    }];
}

- (void)getTodaysEventsCompletion:(BMWCalendarEventCompletion)completion {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *tomorrowComponents = [[NSDateComponents alloc] init];
    tomorrowComponents.day = 1;
    NSDate *tomorrow = [calendar dateByAddingComponents:tomorrowComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    [self getEventsStartDate:[NSDate date] endDate:tomorrow completion:completion];
}

- (void)getEventsStartDate:(NSDate *)start
                   endDate:(NSDate *)end
                completion:(BMWCalendarEventCompletion)completion {
    if (!self.isAuthorized) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BMWCalendarAccessDeniedNotification
                                                            object:self];
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Calendar store access not authorized by user."};
        completion(nil, [NSError errorWithDomain:@"com.timshi.Merkel" code:400 userInfo:userInfo]);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSPredicate *predicate = [self.store predicateForEventsWithStartDate:start
                                                                     endDate:end
                                                                   calendars:nil];
        NSArray *events = [self.store eventsMatchingPredicate:predicate];
        events = [events sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
        NSMutableArray *filteredEvents = [NSMutableArray array];
        for (EKEvent *event in events) {
            if (event.birthdayPersonID == -1) {
                
                
                [filteredEvents addObject:event];
 
                if(event.attendees.count) {
                    //dispatch af netwokring call.
                    
                    [[BMWAPIClient sharedClient] createConferenceForCalendarEvent:event success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSNumber *conferenceCode = responseObject[@"conferenceCode"];
                        NSDictionary *eventWithCode = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                event, "@event",
                                                       conferenceCode, @"conferenceCode", nil];
                        [filteredEvents addObject:eventWithCode];
                        //do something with this.
                        
                    
                    }   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"Error creating conference: %@", [error localizedDescription]);
                    }];
                } else {

                    [filteredEvents addObject:@{@"event":event, @"conferenceCode":@""}];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(filteredEvents, nil);
        });
    });
}

@end
