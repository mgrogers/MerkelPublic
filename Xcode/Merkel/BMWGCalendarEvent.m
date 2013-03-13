//
//  BMWCalendarEvent.m
//  Merkel
//
//  Created by Tim Shi on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWGCalendarEvent.h"

#import "BMWLinkedInProfile.h"

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
    id attendees = dict[@"attendees"];
    if ([attendees isKindOfClass:[NSArray class]]) {
        event.attendees = [BMWLinkedInProfile profilesFromEmails:attendees];
    } else if ([attendees isKindOfClass:[NSDictionary class]]) {
        event.attendees = [BMWLinkedInProfile profilesFromJSONDict:attendees];
    }
    return event;
}

+ (NSArray *)eventsFromJSONDict:(NSDictionary *)dict {
    NSMutableArray *returnArray = [NSMutableArray array];
    for (NSDictionary *event in dict[@"events"]) {
        [returnArray addObject:[self eventFromJSONDict:event]];
    }
    return returnArray;
}

+ (NSArray *)eventsFromJSONCalendars:(NSArray *)calendars sorted:(BOOL)sorted {
    NSMutableArray *events = [NSMutableArray array];
    for (NSDictionary *dict in calendars) {
        [events addObjectsFromArray:[BMWGCalendarEvent eventsFromJSONDict:dict]];
    }
    if (sorted) {
        [events sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            BMWGCalendarEvent *e1 = (BMWGCalendarEvent *)obj1;
            BMWGCalendarEvent *e2 = (BMWGCalendarEvent *)obj2;
            return [e1 compare:e2];
        }];
    }
    return events;
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

+ (instancetype)testEvent {
    NSDictionary *event = @{@"name": @"Test Event",
                            @"description": @"This is the greatest event",
                            @"start": @{@"dateTime": @"2013-01-08T10:00:00-08:00"},
                            @"end": @{@"dateTime": @"2013-01-08T12:00:00-08:00"}};
    return [self eventFromJSONDict:event];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"title: %@\ndescription: %@\nstart: %@\nend: %@", self.title, self.eventDescription, self.startDate, self.endDate];
}

- (NSComparisonResult)compare:(BMWGCalendarEvent *)event {
    return [self.startDate compare:event.startDate];
}

@end
