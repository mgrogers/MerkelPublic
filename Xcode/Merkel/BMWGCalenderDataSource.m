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

@interface BMWGCalenderDataSource ()

@property (nonatomic, strong) GTMOAuth2Authentication *googleAuth;

@end

@implementation BMWGCalenderDataSource

static NSString * const kBMWGoogleClientId = @"992955494422.apps.googleusercontent.com";
static NSString * const kBMWGoogleClientSecret = @"owOZqTGiK2e59tT9OqRHs5Xt";
static NSString * const kBMWGoogleAuthKeychain = @"kBMWGoogleAuthKeychain";
static NSString * const kBMWGoogleScope = @"https://www.googleapis.com/auth/userinfo.profile";

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
                                                        
    }];
}

- (void)authController:(GTMOAuth2ViewControllerTouch *)viewController
  didAuthorizeWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    self.googleAuth = auth;
}

@end
