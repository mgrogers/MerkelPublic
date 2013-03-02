//
//  BMWGCalenderDataSource.h
//  Merkel
//
//  Created by Tim Shi on 2/25/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTMOAuth2ViewControllerTouch;

@interface BMWGCalenderDataSource : NSObject

typedef void (^BMWGCalendarAuthCompletion)(GTMOAuth2ViewControllerTouch *viewController, NSError *error);

+ (instancetype)sharedDataSource;

- (BOOL)canAuthorize;

- (GTMOAuth2ViewControllerTouch *)authViewControllerWithCompletionHandler:(BMWGCalendarAuthCompletion)handler;

- (void)authorizeRequest:(NSMutableURLRequest *)request
       completionHandler:(void (^)(NSError *error))handler;

- (void)logOut;

@end
