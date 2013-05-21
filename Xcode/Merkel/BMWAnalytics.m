//
//  BMWAnalytics.m
//  Merkel
//
//  Created by Tim Shi on 5/20/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWAnalytics.h"

#import <Mixpanel/Mixpanel.h>

@implementation BMWAnalytics

static NSString * const kBMWMixpanelLogin = @"User Login";
static NSString * const kBMWMixpanelSpeakerButtonClicked = @"Speaker Button Clicked";
static NSString * const kBMWMixpanelMuteButtonClicked = @"Mute Button Clicked";
static NSString * const kBMWMixpanelVOIPFailure = @"VOIP Failure";

+ (void)mixpanelTrackLoggedInUser:(NSString *)username {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:username];
    [mixpanel track:kBMWMixpanelLogin];
}

+ (void)mixpanelTrackSpeakerButtonClick:(BOOL)isActive {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:kBMWMixpanelSpeakerButtonClicked
         properties:@{@"isActive": [NSNumber numberWithBool:isActive]}];
}

+ (void)mixpanelTrackMuteButtonClick:(BOOL)isActive {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:kBMWMixpanelMuteButtonClicked
         properties:@{@"isActive": [NSNumber numberWithBool:isActive]}];
}

+ (void)mixpanelTrackVOIPFailure:(NSError *)error {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:kBMWMixpanelVOIPFailure
         properties:@{@"errorDescription": [error localizedDescription],
                      @"errorFailure": ([error localizedFailureReason]) ? [error localizedFailureReason] : [NSNull null]}];
}

@end
