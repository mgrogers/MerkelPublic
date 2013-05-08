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
    __block ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        for (EKParticipant *attendee in event.attendees) {
            NSMutableDictionary *attendeeObject = [@{@"name": attendee.name} mutableCopy];
            ABRecordRef record = [attendee ABRecordWithAddressBook:addressBook];
            ABMultiValueRef emailMulti = NULL;
            ABMultiValueRef phoneMulti = NULL;
            if (!record) {
                // we don't have an address book record, so assume the name is also the email.
                [attendeeObject setObject:attendee.name forKey:@"email"];
            } else {
                NSString *nsEmail = nil;
                NSString *nsPhone = nil;
                emailMulti = ABRecordCopyValue(record, kABPersonEmailProperty);
                phoneMulti = ABRecordCopyValue(record, kABPersonPhoneProperty);
                CFStringRef email = ABMultiValueCopyValueAtIndex(emailMulti, 0);
                CFStringRef phone = NULL;
                for (CFIndex i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
                    CFStringRef phoneLabel = ABMultiValueCopyLabelAtIndex(phoneMulti, i);
                    CFComparisonResult comparisonResultIPhone = CFStringCompare(phoneLabel, kABPersonPhoneIPhoneLabel, kCFCompareCaseInsensitive);
                    CFComparisonResult comparisonResultMobile = CFStringCompare(phoneLabel, kABPersonPhoneMobileLabel, kCFCompareCaseInsensitive);
                    if (comparisonResultIPhone == kCFCompareEqualTo || comparisonResultMobile == kCFCompareEqualTo) {
                        phone = ABMultiValueCopyValueAtIndex(phoneMulti, i);
                    }
                    CFRelease(phoneLabel);
                }
                if (emailMulti != NULL) CFRelease(emailMulti);
                if (phoneMulti != NULL) CFRelease(phoneMulti);
                if (email != NULL) {
                    nsEmail = (__bridge NSString *)email;
                    [attendeeObject setObject:nsEmail forKey:@"email"];
                    CFRelease(email);
                }
                if (phone != NULL) {
                    nsPhone = (__bridge NSString *)phone;
                    [attendeeObject setObject:nsPhone forKey:@"phone"];
                    CFRelease(phone);
                }
                CFRelease(record);
            }
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
        if (addressBook) {
            CFRelease(addressBook);
        }
    });
}

- (void)sendLateMessageWithParameters:(NSDictionary *)parameters
                             success:(void (^)(AFHTTPRequestOperation *, id))success
                             failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    static NSString * const kBMWNewConferencePath = @"conference/invite";
    
    [self postPath:kBMWNewConferencePath
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
