//
//  BMWLinkedInProfile.m
//  Merkel
//
//  Created by Wesley Leung on 3/10/13.
//  Copyright (c) 2013 BossMobileWunderkinder. All rights reserved.
//

#import "BMWLinkedInProfile.h"
#import "BMWGCalendarEvent.h"


@implementation BMWLinkedInProfile


+ (instancetype)profileFromJSONDict:(NSDictionary *)dict {
    BMWLinkedInProfile *profile = [[self alloc] init];
    profile.JSON = dict;
    profile.name = dict[@"name"];
    profile.jobTitle = dict[@"jobTitle"];
    profile.summary = dict[@"summary"];
    profile.emails = dict[@"emails"];
    profile.profileImageURL = [NSURL URLWithString:dict[@"profileImageURl"]];
    return profile;
}

+ (NSArray *)profilesFromJSONDict:(NSDictionary *)dict {
    NSMutableArray *returnArray = [NSMutableArray array];
    for (NSDictionary *profile in dict[@"profiles"]) {
        [returnArray addObject:[self profileFromJSONDict:profile]];
    }
    return returnArray;
}

+ (instancetype)profileFromEmail:(NSDictionary *)email {
    BMWLinkedInProfile *profile = [[self alloc] init];
    profile.name = email[@"email"];
    profile.responseStatus = email[@"responseStatus"];
    return profile;
}

+ (NSArray *)profilesFromEmails:(NSArray *)emails {
    NSMutableArray *returnArray = [NSMutableArray array];
    for (NSDictionary *email in emails) {
        [returnArray addObject:[self profileFromEmail:email]];
    }
    return returnArray;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Name: %@\nTitle: %@\nsummary: %@\nnumber of Emails: %d@", self.name, self.jobTitle, self.summary, [self.emails count]];
}

@end
