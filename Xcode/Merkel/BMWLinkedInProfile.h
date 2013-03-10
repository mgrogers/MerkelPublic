//
//  BMWLinkedInProfile.h
//  Merkel
//
//  Created by Wesley Leung on 3/10/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMWLinkedInProfile : NSObject

@property (nonatomic, copy) NSString *name, *jobTitle, *summary;
@property (nonatomic, strong) NSDictionary *JSON;
@property (nonatomic, strong) NSArray *emails;
@property (nonatomic, strong) NSURL *profileImageURL;


+ (instancetype)profileFromJSONDict:(NSDictionary *)dict;
+ (NSArray *)profilesFromJSONDict:(NSDictionary *)dict;

@end
