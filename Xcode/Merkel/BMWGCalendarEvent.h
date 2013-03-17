//
//  BMWCalendarEvent.h
//  Merkel
//
//  Created by Tim Shi on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

// Object model class for Google Calendar events. Provides class methods
// to create objects from JSON responses and mock data.

#import <Foundation/Foundation.h>

@interface BMWGCalendarEvent : NSObject

@property (nonatomic, copy) NSString *title, *eventDescription;
@property (nonatomic, strong) NSDictionary *location, *JSON;
@property (nonatomic, strong) NSDate *startDate, *endDate;
@property (nonatomic, strong) NSArray *attendees;

+ (instancetype)eventFromJSONDict:(NSDictionary *)dict;
+ (NSArray *)eventsFromJSONDict:(NSDictionary *)dict;
+ (NSArray *)eventsFromJSONCalendars:(NSArray *)calendars sorted:(BOOL)sorted;
+ (instancetype)testEvent;

// Compares events based on start date.
- (NSComparisonResult)compare:(BMWGCalendarEvent *)event;

@end
