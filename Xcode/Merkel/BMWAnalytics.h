//
//  BMWAnalytics.h
//  Merkel
//
//  Created by Tim Shi on 5/20/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMWAnalytics : NSObject

+ (void)mixpanelTrackUser:(NSString *)username;
+ (void)mixpanelTrackLoggedInUser:(NSString *)username;
+ (void)mixpanelTrackSpeakerButtonClick:(BOOL)isActive;
+ (void)mixpanelTrackMuteButtonClick:(BOOL)isActive;
+ (void)mixpanelTrackVOIPDial;
+ (void)mixpanelTrackPhoneDial;
+ (void)mixpanelTrackVOIPCall:(NSTimeInterval)duration;
+ (void)mixpanelTrackVOIPFailure:(NSError *)error;

@end
