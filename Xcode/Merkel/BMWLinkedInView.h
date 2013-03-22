//
//  BMWLinkedInView.h
//  Merkel
//
//  Created by Wesley Leung on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinder. All rights reserved.
//

// Detail view of a LinkedIn profile. Displays user's basic info,
// profile picture, and access to recent emails.

#import <BMWAppKit/BMWAppKit.h>

@class BMWLinkedInProfile;
@class BMWLinkedInView;

@protocol BMWLinkedInViewDelegate

- (BMWLinkedInProfile *)attendeeforAttendeeView:(BMWLinkedInView *)profileView;

@end

@interface BMWLinkedInView : IDTableLayoutView

@property (nonatomic, weak) id <BMWLinkedInViewDelegate> linkedInDelegate;
@property (nonatomic, strong) BMWLinkedInProfile *profile;




@end



