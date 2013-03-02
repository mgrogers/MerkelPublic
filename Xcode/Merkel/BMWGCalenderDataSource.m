//
//  BMWGCalenderDataSource.m
//  Merkel
//
//  Created by Tim Shi on 2/25/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWGCalenderDataSource.h"
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"

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

@interface BMWGCalenderDataSource ()

@property (nonatomic, strong) GTMOAuth2Authentication *googleAuth;

@end

@implementation BMWGCalenderDataSource

static NSString * const kBMWGoogleClientId = @"992955494422.apps.googleusercontent.com";
static NSString * const kBMWGoogleClientSecret = @"owOZqTGiK2e59tT9OqRHs5Xt";
static NSString * const kBMWGoogleAuthKeychain = @"kBMWGoogleAuthKeychain";
static NSString * const kBMWGoogleScope = @"https://www.googleapis.com/auth/userinfo.profile";

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
    static BMWGCalenderDataSource *sharedDataSource = nil;
    dispatch_once(&onceToken, ^{
        sharedDataSource = [[self alloc] init];
    });
    return sharedDataSource;
}

- (id)init {
    self = [super init];
    if (self) {
        self.googleAuth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kBMWGoogleAuthKeychain
                                                                                clientID:kBMWGoogleClientId
                                                                            clientSecret:kBMWGoogleClientSecret];
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
        [[PFUser currentUser] setObject:auth.accessToken forKey:@"googleAuthToken"];
        [[PFUser currentUser] setObject:auth.refreshToken forKey:@"googleRefreshToken"];
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

@end
