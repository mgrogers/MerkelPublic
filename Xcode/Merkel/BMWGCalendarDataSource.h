////
////  BMWGCalenderDataSource.h
////  Merkel
////
////  Created by Tim Shi on 2/25/13.
////  Copyright (c) 2013 BossMobileWunderkinder. All rights reserved.
////
//
//// This class provides all services needed to access a user's calendar data.
//// Use the singleton method to get the shared instance. Not thread safe.
//
//#import <Foundation/Foundation.h>
//
//@class GTMOAuth2Authentication;
//@class GTMOAuth2ViewControllerTouch;
//
//@interface BMWGCalendarDataSource : NSObject
//
//@property (readonly) GTMOAuth2Authentication *googleAuth;
//
//typedef void (^BMWGCalendarAuthCompletion)(GTMOAuth2ViewControllerTouch *viewController, NSError *error);
//typedef void (^BMWGCalendarEventRequestCompletion)(NSArray *events, NSError *error);
//
//// Singleton initializer.
//+ (instancetype)sharedDataSource;
//
//// Will return YES if the Google user is logged in and authorized to make google requests.
//- (BOOL)canAuthorize;
//
//// Returns the auth view controller to be presented to the user for login. On completion, the block callback
//// returns the view controller for dismissal.
//- (GTMOAuth2ViewControllerTouch *)authViewControllerWithCompletionHandler:(BMWGCalendarAuthCompletion)handler;
//
//// Wraparound for the google request authorizers. Adds necessary headers to authorize request to
//// Google API services.
//- (void)authorizeRequest:(NSMutableURLRequest *)request
//       completionHandler:(void (^)(NSError *error))handler;
//
//// Logs the current Google user out and deletes their information from the keychain.
//- (void)logOut;
//
//// Checks the PFUser's Parse account for Google auth data and refresh the keychain.
//- (BOOL)refreshParseAuth;
//
//// Makes a request to the heroku server to get most recent events. Caches them in memory.
//// Synchronous method.
//- (NSArray *)eventsToDisplayFromCache:(BOOL)fromCache;
//// Asynchronous method.
//- (NSArray *)eventsToDisplayCompletion:(BMWGCalendarEventRequestCompletion)completion;
//
////Returns a test stub of attendee objects
//- (NSArray *)attendeesToDisplayTest;
//
//@end
