//
//  BMWLinkedInProfile.h
//  Merkel
//
//  Created by Wesley Leung on 3/10/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

// Object model class for LinkedIn user profiles. Provides class
// methods to create objects from JSON reponses.

#import <Foundation/Foundation.h>

@interface BMWLinkedInProfile : NSObject

@property (nonatomic, copy) NSString *name, *jobTitle, *summary, *responseStatus;
@property (nonatomic, strong) NSArray *emails;
@property (nonatomic, strong) NSURL *profileImageURL;
@property (nonatomic, strong) NSDictionary *JSON;

+ (instancetype)profileFromJSONDict:(NSDictionary *)dict;
+ (NSArray *)profilesFromJSONDict:(NSDictionary *)dict;
+ (instancetype)profileFromEmail:(NSDictionary *)email;
+ (NSArray *)profilesFromEmails:(NSArray *)emails;

@end
