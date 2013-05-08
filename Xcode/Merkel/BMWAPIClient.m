//
//  BMWAPIClient.m
//  Merkel
//
//  Created by Tim Shi on 4/20/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWAPIClient.h"

#import <AFNetworking/AFJSONRequestOperation.h>`

@interface EKAttendee : EKParticipant

@property (readonly) NSString *email;

@end

@implementation BMWAPIClient

static NSString * const kBMWAPIClientBaseURLString = @"http://api.callinapp.com/2013-04-23/";

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
    static NSString * const kBMWCapabilityTokenPath = @"conference/capability";
    [self getPath:kBMWCapabilityTokenPath
       parameters:parameters
          success:success
          failure:failure];
}

- (void)getNewConferenceWithParameters:(NSDictionary *)parameters
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    static NSString * const kBMWNewConferencePath = @"conference/create";
    [self getPath:kBMWNewConferencePath
       parameters:parameters
          success:success
          failure:failure];
}

- (void)createConferenceForCalendarEvent:(EKEvent *)event
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    static NSString * const kBMWNewConferencePath = @"conference/create";
    NSMutableArray *attendeeArray = [NSMutableArray array];
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        for (EKParticipant *attendee in event.attendees) {
            NSMutableDictionary *attendeeObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            attendee.name, @"name", nil];
//            ABRecordRef record = [attendee ABRecordWithAddressBook:addressBook];
//            if (record) {
//                CFStringRef email = ABRecordCopyValue(record, kABPersonEmailProperty);
//                NSString *nsEmail = (__bridge NSString *)email;
//                [attendeeObject setObject:nsEmail forKey:@"email"];
//                CFRelease(email);
//            }
            [attendeeArray addObject:attendeeObject];
        }
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    event.title, @"title",
                                    event.notes, @"description",
                                    event.startDate, @"start",
                                    attendeeArray, @"attendees", nil];
        
        [self postPath:kBMWNewConferencePath
            parameters:parameters
               success:success
               failure:failure];
//    });
//    if (addressBook) {
//        CFRelease(addressBook);
//    }
}

- (void)sendEmailMessageWithParameters:(NSDictionary *)parameters
                             success:(void (^)(AFHTTPRequestOperation *, id))success
                             failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    static NSString * const kBMWEmailConferencePath = @"conference/email";
    
    [self postPath:kBMWEmailConferencePath
        parameters:parameters
           success:success
           failure:failure];
}

- (void)sendSMSMessageWithParameters:(NSDictionary *)parameters
                              success:(void (^)(AFHTTPRequestOperation *, id))success
                              failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    static NSString * const kBMWSMSConferencePath = @"conference/sms";
    
    [self postPath:kBMWSMSConferencePath
        parameters:parameters
           success:success
           failure:failure];
}

- (void)getPhoneNumberSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    static NSString * const kBMWPhoneNumberPath = @"conference/number";
    [self getPath:kBMWPhoneNumberPath
       parameters:nil
          success:success
          failure:failure];
}

@end
