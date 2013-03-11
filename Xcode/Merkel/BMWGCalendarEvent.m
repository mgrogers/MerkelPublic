//
//  BMWCalendarEvent.m
//  Merkel
//
//  Created by Tim Shi on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWGCalendarEvent.h"

@interface BMWGCalendarEvent ()



@end

@implementation BMWGCalendarEvent

+ (instancetype)eventFromJSONDict:(NSDictionary *)dict {
    BMWGCalendarEvent *event = [[self alloc] init];
    event.JSON = dict;
    event.title = dict[@"name"];
    event.eventDescription = dict[@"description"];
    event.startDate = [self dateFromEventObject:dict[@"start"]];
    event.endDate = [self dateFromEventObject:dict[@"end"]];
    return event;
}

+ (NSArray *)eventsFromJSONDict:(NSDictionary *)dict {
    NSMutableArray *returnArray = [NSMutableArray array];
    for (NSDictionary *event in dict[@"events"]) {
        [returnArray addObject:[self eventFromJSONDict:event]];
    }
    return returnArray;
}

+ (NSDate *)dateFromEventObject:(NSDictionary *)dict {
    if (dict[@"date"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        return [formatter dateFromString:dict[@"date"]];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        NSMutableString *mutableDate = [dict[@"dateTime"] mutableCopy];
        [mutableDate deleteCharactersInRange:NSMakeRange(mutableDate.length - 3, 1)];
        NSDate *date = [formatter dateFromString:mutableDate];
        return date;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"title: %@\ndescription: %@\nstart: %@\nend: %@", self.title, self.eventDescription, self.startDate, self.endDate];
}

@end
