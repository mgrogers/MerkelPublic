//
//  BMWGCalenderDataSource.m
//  Merkel
//
//  Created by Tim Shi on 2/25/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWGCalendarDataSource.h"
#import "BMWGCalendarEvent.h"
#import <Google-API-Client/GTMOAuth2Authentication.h>
#import <Google-API-Client/GTMOAuth2ViewControllerTouch.h>
//#import "GTMOAuth2Authentication.h"
//#import "GTMOAuth2ViewControllerTouch.h"

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

static NSString * const kBMWGoogleClientId = @"992955494422.apps.googleusercontent.com";
static NSString * const kBMWGoogleClientSecret = @"owOZqTGiK2e59tT9OqRHs5Xt";
static NSString * const kBMWGoogleAuthKeychain = @"kBMWGoogleAuthKeychain";
static NSString * const kBMWGoogleScope = @"https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/drive";

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

- (void)saveAuthToParse:(GTMOAuth2Authentication *)auth {
    if ([PFUser currentUser]) {
        [[PFUser currentUser] setObject:auth.accessToken forKey:@"google_access_token"];
        [[PFUser currentUser] setObject:auth.refreshToken forKey:@"google_refresh_token"];
        [[PFUser currentUser] setObject:auth.userID forKey:@"google_user_id"];
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
        CFBridgingRelease(escapedStr);
    }
    
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
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
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

- (NSArray *)eventsToDisplayTest {
    NSDictionary *event = @{@"name": @"Test Event",
                                            @"description": @"This is the greatest event",
                                            @"start": @{@"dateTime": @"2013-01-08T10:00:00-08:00"},
                                            @"end": @{@"dateTime": @"2013-01-08T12:00:00-08:00"}};
    NSMutableArray *events = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [events addObject:[BMWGCalendarEvent eventFromJSONDict:event]];
    }
    return events;
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
    id json = [NSJSONSerialization JSONObjectWithData:response options:0 error:error];
    if ([json isKindOfClass:[NSArray class]]) {
        NSDictionary *dict = ((NSArray *)json)[0];
        NSArray *events = [BMWGCalendarEvent eventsFromJSONDict:dict];
        return events;
    }
    return nil;
}

-(NSDictionary *)linkedinToDisplayFromEvent {
    //Request to get event attendee linkedin profile object

    NSDictionary *response = @{@"profileURL":@"http://m.c.lnkd.licdn.com/media/p/8/000/1c6/09c/29b17fa.jpg",@"name":@"Wesley"};
    return response;
}

@end
