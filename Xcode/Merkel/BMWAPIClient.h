//
//  BMWAPIClient.h
//  Merkel
//
//  Created by Tim Shi on 4/20/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <AFNetworking/AFHTTPClient.h>

@interface BMWAPIClient : AFHTTPClient

+ (instancetype)sharedClient;

@end
