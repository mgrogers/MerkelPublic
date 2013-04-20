//
//  BMWAPIClient.m
//  Merkel
//
//  Created by Tim Shi on 4/20/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWAPIClient.h"

#import <AFNetworking/AFJSONRequestOperation.h>

@implementation BMWAPIClient

static NSString * const kBMWAPIClientBaseURLString = @"https://bossmobilewunderkinds.herokuapp.com/api/";

+ (instancetype)sharedClient {
    static BMWAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBMWAPIClientBaseURLString]];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

- (void)getCapabilityTokenWithParameters:(NSDictionary *)parameters
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    static NSString * const kBMWCapabilityTokenPath = @"twilio/capability";
    [self getPath:kBMWCapabilityTokenPath
       parameters:parameters
          success:success
          failure:failure];
}

@end
