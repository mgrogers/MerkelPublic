//
//  BMWGCalenderDataSource.m
//  Merkel
//
//  Created by Tim Shi on 2/25/13.
//  Copyright (c) 2013 BossMobileWunderkinder. All rights reserved.
//

#import "BMWGCalendarDataSource.h"
#import "BMWGCalendarEvent.h"
#import "BMWLinkedInProfile.h"

#import <gtm-oauth2/GTMOAuth2Authentication.h>
#import <gtm-oauth2/GTMOAuth2ViewControllerTouch.h>

@interface NSURL (additions)

- (NSURL *)URLByAppendingQueryString:(NSString *)queryString;

@end

@implementation NSURL (additions)

- (NSURL *)URLByAppendingQueryString:(NSString *)queryString {
    if (![queryString length]) {
        return self;
    }
    
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@", [self absoluteString],
                           [self query] ? @"&" : @"?", queryString];
    NSURL *theURL = [NSURL URLWithString:URLString];
    return theURL;
}

@end

@interface BMWGCalendarDataSource ()

@property (nonatomic, strong) GTMOAuth2Authentication *googleAuth;
@property (nonatomic, strong) NSCache *dataCache;

@end

@implementation BMWGCalendarDataSource

//toggle on or off for testing in offline mode
static BOOL const kOfflineMode = NO;

static NSString * const kBMWGoogleClientId = @"992955494422.apps.googleusercontent.com";
static NSString * const kBMWGoogleClientSecret = @"owOZqTGiK2e59tT9OqRHs5Xt";
static NSString * const kBMWGoogleAuthKeychain = @"kBMWGoogleAuthKeychain";
static NSString * const kBMWGoogleScope = @"https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/drive https://mail.google.com";

// standard OAuth keys
static NSString *const kOAuth2AccessTokenKey       = @"access_token";
static NSString *const kOAuth2RefreshTokenKey      = @"refresh_token";
static NSString *const kOAuth2ClientIDKey          = @"client_id";
static NSString *const kOAuth2ClientSecretKey      = @"client_secret";
static NSString *const kOAuth2RedirectURIKey       = @"redirect_uri";
static NSString *const kOAuth2ResponseTypeKey      = @"response_type";
static NSString *const kOAuth2ScopeKey             = @"scope";
static NSString *const kOAuth2ErrorKey             = @"error";
static NSString *const kOAuth2TokenTypeKey         = @"token_type";
static NSString *const kOAuth2ExpiresInKey         = @"expires_in";
static NSString *const kOAuth2CodeKey              = @"code";
static NSString *const kOAuth2AssertionKey         = @"assertion";
static NSString *const kOAuth2RefreshScopeKey      = @"refreshScope";

// additional persistent keys
static NSString *const kServiceProviderKey        = @"serviceProvider";
static NSString *const kUserIDKey                 = @"userID";
static NSString *const kUserEmailKey              = @"email";
static NSString *const kUserEmailIsVerifiedKey    = @"isVerified";

static NSString * const kGTMOAuth2AccountName = @"OAuth";

+ (instancetype)sharedDataSource {
    static dispatch_once_t onceToken;
    static BMWGCalendarDataSource *sharedDataSource = nil;
    dispatch_once(&onceToken, ^{
        sharedDataSource = [[self alloc] init];
    });
    return sharedDataSource;
}

- (id)init {
    self = [super init];
    if (self) {
        self.dataCache = [[NSCache alloc] init];
        self.googleAuth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kBMWGoogleAuthKeychain
                                                                                clientID:kBMWGoogleClientId
                                                                            clientSecret:kBMWGoogleClientSecret];
        [self refreshParseAuth];
    }
    return self;
}

- (BOOL)canAuthorize {
    return [self.googleAuth canAuthorize];
}

- (GTMOAuth2ViewControllerTouch *)authViewControllerWithCompletionHandler:(BMWGCalendarAuthCompletion)handler {
    return [GTMOAuth2ViewControllerTouch controllerWithScope:kBMWGoogleScope
                                                    clientID:kBMWGoogleClientId
                                                clientSecret:kBMWGoogleClientSecret
                                            keychainItemName:kBMWGoogleAuthKeychain
                                           completionHandler:^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error) {
                                               [self authController:viewController
                                               didAuthorizeWithAuth:auth
                                                              error:error
                                                            handler:handler];
                                                        
    }];
}

- (void)authController:(GTMOAuth2ViewControllerTouch *)viewController
  didAuthorizeWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error
               handler:(BMWGCalendarAuthCompletion)handler {
    self.googleAuth = auth;
    [self saveAuthToParse:auth];
    handler(viewController, error);
}

- (void)authorizeRequest:(NSMutableURLRequest *)request
       completionHandler:(void (^)(NSError *error))handler {
    [self.googleAuth authorizeRequest:request
                    completionHandler:handler];
    request.URL = [request.URL URLByAppendingQueryString:[NSString stringWithFormat:@"key=%@", kBMWGoogleClientId]];
}

- (void)logOut {
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kBMWGoogleAuthKeychain];
    self.googleAuth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kBMWGoogleAuthKeychain
                                                                            clientID:kBMWGoogleClientId
                                                                        clientSecret:kBMWGoogleClientSecret];
}

- (BOOL)refreshParseAuth {
    if (![self.googleAuth canAuthorize]) {
        if ([PFUser currentUser]) {
            CFTypeRef accessibility = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly;
        
            // make a response string containing the values we want to save
            NSString *password = [self persistenceResponseString];
            if (!password) {
                return NO;
            }
            GTMOAuth2Keychain *keychain = [GTMOAuth2Keychain defaultKeychain];
            BOOL success = [keychain setPassword:password
                              forService:kBMWGoogleAuthKeychain
                           accessibility:accessibility
                                 account:kGTMOAuth2AccountName
                                   error:nil];
            if (success) {
                self.googleAuth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kBMWGoogleAuthKeychain
                                                                                        clientID:kBMWGoogleClientId
                                                                                    clientSecret:kBMWGoogleClientSecret];
                return YES;
            }
            return NO;
        }
    }
    return YES;
}

//This overwrites Parse's save for Facebook emails and replaces it with gmail assuming the user has correctly authed with Google.
- (void)saveAuthToParse:(GTMOAuth2Authentication *)auth {
    if ([PFUser currentUser]) {
        [[PFUser currentUser] setObject:auth.accessToken forKey:@"google_access_token"];
        [[PFUser currentUser] setObject:auth.refreshToken forKey:@"google_refresh_token"];
        [[PFUser currentUser] setObject:auth.userID forKey:@"google_user_id"];

        [[PFUser currentUser] setObject:auth.userEmail forKey:kUserEmailKey];
        [self savePersistenceResponseString];
        [[PFUser currentUser] saveInBackground];
    }
}

+ (NSString *)encodedOAuthValueForString:(NSString *)str {
    CFStringRef originalString = (CFStringRef) CFBridgingRetain(str);
    CFStringRef leaveUnescaped = NULL;
    CFStringRef forceEscaped =  CFSTR("!*'();:@&=+$,/?%#[]");
    
    CFStringRef escapedStr = NULL;
    if (str) {
        escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                             originalString,
                                                             leaveUnescaped,
                                                             forceEscaped,
                                                             kCFStringEncodingUTF8);
//        CFBridgingRelease(escapedStr);
    }
    CFBridgingRelease(originalString);
    return (NSString *)CFBridgingRelease(escapedStr);
}

+ (NSString *)encodedQueryParametersForDictionary:(NSDictionary *)dict {
    // Make a string like "cat=fluffy@dog=spot"
    NSMutableString *result = [NSMutableString string];
    NSArray *sortedKeys = [[dict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *joiner = @"";
    for (NSString *key in sortedKeys) {
        NSString *value = [dict objectForKey:key];
        NSString *encodedValue = [self encodedOAuthValueForString:value];
        NSString *encodedKey = [self encodedOAuthValueForString:key];
        [result appendFormat:@"%@%@=%@", joiner, encodedKey, encodedValue];
        joiner = @"&";
    }
    return result;
}

- (void)savePersistenceResponseString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    // Any nil values will not set a dictionary entry
    [dict setValue:self.googleAuth.refreshToken forKey:kOAuth2RefreshTokenKey];
    [dict setValue:self.googleAuth.accessToken forKey:kOAuth2AccessTokenKey];
    [dict setValue:self.googleAuth.serviceProvider forKey:kServiceProviderKey];
    [dict setValue:self.googleAuth.userID forKey:kUserIDKey];
    [dict setValue:self.googleAuth.userEmail forKey:kUserEmailKey];
    [dict setValue:self.googleAuth.userEmailIsVerified forKey:kUserEmailIsVerifiedKey];
    [dict setValue:self.googleAuth.scope forKey:kOAuth2ScopeKey];
    [[PFUser currentUser] setObject:dict forKey:@"googlePersistenceDict"];
}

- (NSString *)persistenceResponseString {
    NSDictionary *persistenceDict = [[PFUser currentUser] objectForKey:@"googlePersistenceDict"];
    if (!persistenceDict) {
        return nil;
    }
    NSString *result = [[self class] encodedQueryParametersForDictionary:persistenceDict];
    return result;
}


- (NSArray *)eventsToDisplayCompletion:(BMWGCalendarEventRequestCompletion)completion {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError *error;

        NSArray *events = [self eventRequestWithMethod:@"day" error:&error];
        if(kOfflineMode) {
            events = [self eventsToDisplayTest];
        }
        if (events) {
            [self.dataCache setObject:events forKey:@"events/day"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(events, error);
        });
    });
    
    return [self.dataCache objectForKey:@"events/day"];
}

- (NSArray *)eventsToDisplayFromCache:(BOOL)fromCache {
    if (fromCache) {
        return [self.dataCache objectForKey:@"events/day"];
    } else {
        NSError *error;
        return  [self eventRequestWithMethod:@"day" error:&error];
    }
}

- (NSArray *)eventRequestWithMethod:(NSString *)method error:(NSError **)error {
    NSString * const kBaseURL = @"http://bossmobilewunderkinds.herokuapp.com/api/events/";
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", kBaseURL, [[PFUser currentUser] objectId], method];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *response = [NSData dataWithContentsOfURL:url];
    if (!response) return nil;
    id json = [NSJSONSerialization JSONObjectWithData:response options:0 error:error];
    if ([json isKindOfClass:[NSArray class]]) {
        NSArray *events = [BMWGCalendarEvent eventsFromJSONCalendars:json sorted:YES];
        return events;
    }
    return nil;
}

#pragma mark offline test stubs

- (NSArray *)eventsToDisplayTest {
    NSDictionary *testCalendarJSON = @{
                                       @"name": @"Merkel",
                                       @"events": @[@{
                                                        @"id": @"on4vpqn3bad2pdf2cc9mtnqpes",
                                                        @"name": @"Breakfast with Taylor",
                                                        @"description": @"Catch up and discuss new watchface SDK for Pebble.",
                                                        @"location": @"Mayfield Bakery & Cafe Town & Country Village 855 El Camino Real Palo Alto, CA 94301",
                                                        @"start": @{
                                                                @"dateTime": @"2013-03-27T15:00:00Z"
                                                                },
                                                        @"end": @{
                                                                @"dateTime": @"2013-03-27T16:00:00Z"
                                                                },
                                                        @"creator": @{
                                                                @"email": @"imtonyjin@gmail.com"
                                                                },
                                                        @"attendees": @[
                                                                @{
                                                                    @"email": @"taylor@taylorsavage.com",
                                                                    @"responseStatus": @"declined",
                                                                    @"comment": @"Sounds pleasant but won't you be in Germany?"
                                                                    }
                                                                ],
                                                        @"created": @"2013-03-21T23:08:41.000Z",
                                                        @"updated": @"2013-03-21T23:10:21.746Z"
                                                        },
                                                    @{
                                                        @"id": @"h5f8bbif878gktftr7vgjd5jc8",
                                                        @"name": @"Weekly All-Hands Engineering Meeting",
                                                        @"description": @"Weely all-hands engineering meeting at Google.",
                                                        @"location": @"Google Building 43 1600 Amphitheatre Pkwy, Mountain View, CA 94043",
                                                        @"start": @{
                                                                @"dateTime": @"2013-03-27T16:30:00Z"
                                                                },
                                                        @"end": @{
                                                                @"dateTime": @"2013-03-27T18:00:00Z"
                                                                },
                                                        @"creator": @{
                                                                @"email": @"imtonyjin@gmail.com"
                                                                },
                                                        @"attendees": @[
                                                                @{
                                                                    @"email": @"mjgrogers@gmail.com",
                                                                    @"responseStatus": @"needsAction"
                                                                    },
                                                                @{
                                                                    @"email": @"wes.k.leung@gmail.com",
                                                                    @"responseStatus": @"needsAction"
                                                                    }
                                                                ],
                                                        @"created": @"2013-03-21T23:14:09.000Z",
                                                        @"updated": @"2013-03-21T23:14:22.264Z"
                                                        },
                                                    @{
                                                        @"id": @"bdu18rpiri4g0nls8k8k2kdhac",
                                                        @"name": @"Lunch with Team",
                                                        @"description": @"Love the sushi here.",
                                                        @"location": @"Long Life Cafe Amphitheatre Pkwy & Garcia Ave Mountain View, CA 94043",
                                                        @"start": @{
                                                                @"dateTime": @"2013-03-27T19:00:00Z"
                                                                },
                                                        @"end": @{
                                                                @"dateTime": @"2013-03-27T20:30:00Z"
                                                                },
                                                        @"creator": @{
                                                                @"email": @"imtonyjin@gmail.com"
                                                                },
                                                        @"created": @"2013-03-21T23:17:14.000Z",
                                                        @"updated": @"2013-03-21T23:17:14.056Z"
                                                        },
                                                    @{
                                                        @"id": @"q8teo8bmjq8kp3h1fngp30shq0",
                                                        @"name": @"Meeting with Tim from IDEO",
                                                        @"description": @"Discuss potential design change - removal of header bar from Google web products.",
                                                        @"location": @"IDEO Palo Alto 100 Forest Avenue Palo Alto, CA 94301",
                                                        @"start": @{
                                                                @"dateTime": @"2013-03-27T21:00:00Z"
                                                                },
                                                        @"end": @{
                                                                @"dateTime": @"2013-03-27T23:00:00Z"
                                                                },
                                                        @"creator": @{
                                                                @"email": @"imtonyjin@gmail.com"
                                                                },
                                                        @"attendees": @[
                                                                @{
                                                                    @"email": @"timgshi@gmail.com",
                                                                    @"responseStatus": @"needsAction"
                                                                    }
                                                                ],
                                                        @"created": @"2013-03-21T23:24:06.000Z",
                                                        @"updated": @"2013-03-21T23:24:31.105Z"
                                                        },
                                                    @{
                                                        @"id": @"t3949ecbfq46ha46d2ik19jrfo",
                                                        @"name": @"Dinner with Michelle",
                                                        @"location": @"NOLA Restaurant & Bar 535 Ramona St Palo Alto, CA 94301",
                                                        @"start": @{
                                                                @"dateTime": @"2013-03-28T00:00:00Z"
                                                                },
                                                        @"end": @{
                                                                @"dateTime": @"2013-03-28T02:00:00Z"
                                                                },
                                                        @"creator": @{
                                                                @"email": @"imtonyjin@gmail.com"
                                                                },
                                                        @"attendees": @[
                                                                @{
                                                                    @"email": @"yuzukonii@gmail.com",
                                                                    @"responseStatus": @"needsAction"
                                                                    }
                                                                ],
                                                        @"created": @"2013-03-21T23:27:02.000Z",
                                                        @"updated": @"2013-03-21T23:27:02.094Z"
                                                        },
                                                    @{
                                                        @"id": @"58fpvu5la70suto5aqpvkf4r08",
                                                        @"name": @"Ideate on Future of Google Keep",
                                                        @"description": @"Public sentiment has become negative towards Google Keep because of the shutdown of Google Reader and similarity with Evernote. We need to ideate on ways to reverse this sentiment and portray Keep as a logical extension of Google Drive.",
                                                        @"location": @"Starbucks Coffee 376 University Ave Palo Alto, CA 94301",
                                                        @"start": @{
                                                                @"dateTime": @"2013-03-28T02:30:00Z"
                                                                },
                                                        @"end": @{
                                                                @"dateTime": @"2013-03-28T05:00:00Z"
                                                                },
                                                        @"creator": @{
                                                                @"email": @"imtonyjin@gmail.com"
                                                                },
                                                        @"attendees": @[
                                                                @{
                                                                    @"email": @"imtonyjin@gmail.com",
                                                                    @"displayName": @"Tony Jin",
                                                                    @"responseStatus": @"needsAction"
                                                                    }
                                                                ],
                                                        @"created": @"2013-03-21T23:34:13.000Z",
                                                        @"updated": @"2013-03-21T23:34:13.826Z"
                                                        }
                                                    ]
                                       };
    
    
    NSArray *testEventsArrayfromCalendar = [testCalendarJSON objectForKey:@"events"];
    NSMutableArray *events = [NSMutableArray array];
    for (int i = 0; i < [testEventsArrayfromCalendar count]; i++) {
        NSDictionary *event = [testEventsArrayfromCalendar objectAtIndex:i];
        [events addObject:[BMWGCalendarEvent eventFromJSONDict:event]];
    }
    return events;
}

- (NSArray *)attendeesToDisplayTest {
    NSDictionary *attendee = @{@"name": @"Wesley Leung",
                               @"jobTitle": @"CS Student",
                               @"profileImageURl": @"http://m.c.lnkd.licdn.com/media/p/8/000/1c6/09c/29b17fa.jpg",
                               @"summary": @"I currently attend Stanford.",
                               @"emails": @[
                                       
                                       @{@"date":@{@"dateTime": @"2013-01-08T10:00:00-08:00"},@"subject":@"Re: Catching up for lunch.", @"content":@"Let's meet at the GSB"},
                                       
                                       @{@"date":@{@"dateTime": @"2013-01-18T10:00:00-08:00"},@"subject":@"Re: Meeting with associates.", @"content":@"This is an all-hands meeting."}
                                       
                                       ]};
    NSMutableArray *attendees = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        [attendees addObject:[BMWLinkedInProfile profileFromJSONDict:attendee]];
        
    }
    return attendees;
}




@end
