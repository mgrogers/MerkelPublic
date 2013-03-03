//
//  BMWCalendarEvent.h
//  Merkel
//
//  Created by Tim Shi on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMWGCalendarEvent : NSObject

@property (nonatomic, copy) NSString *title, *description;
@property (nonatomic, strong) NSDictionary *location, *JSON;
@property (nonatomic, strong) NSDate *startDate, *endDate;

+ (instancetype)eventFromJSONDict:(NSDictionary *)dict;
+ (NSArray *)eventsFromJSONDict:(NSDictionary *)dict;

@end
