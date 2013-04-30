//
//  BMWAPIClient.h
//  Merkel
//
//  Created by Tim Shi on 4/20/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <AFNetworking/AFHTTPClient.h>

#import <EventKit/EventKit.h>

@interface BMWAPIClient : AFHTTPClient

+ (instancetype)sharedClient;

- (void)getCapabilityTokenWithParameters:(NSDictionary *)parameters
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getNewConferenceWithParameters:(NSDictionary *)parameters
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)createConferenceForCalendarEvent:(EKEvent *)event
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end