//
//  BMWLinkedInProfile.m
//  Merkel
//
//  Created by Wesley Leung on 3/10/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWLinkedInProfile.h"
#import "BMWGCalendarEvent.h"


@implementation BMWLinkedInProfile

- (BMWLinkedInProfile*)testProfile {
    
}
+ (instancetype)profileFromJSONDict:(NSDictionary *)dict {
    BMWLinkedInProfile *profile = [[self alloc] init];
    profile.JSON = dict;
    profile.name = dict[@"name"];
    profile.jobTitle = dict[@"jobTitle"];
    profile.summary = dict[@"summary"];
    profile.emails = dict[@"emails"];
    return profile;
}

+ (NSArray *)profilesFromJSONDict:(NSDictionary *)dict {
    NSMutableArray *returnArray = [NSMutableArray array];
    for (NSDictionary *profile in dict[@"profiles"]) {
        [returnArray addObject:[self profileFromJSONDict:profile]];
    }
    return returnArray;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Name: %@\nTitle: %@\nsummary: %@\nnumber of Emails: %d@", self.name, self.jobTitle, self.summary, [self.emails count]];
}

@end
