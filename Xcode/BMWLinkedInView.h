//
//  BMWLinkedInView.h
//  Merkel
//
//  Created by Wesley Leung on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <BMWAppKit/BMWAppKit.h>


@class BMWLinkedInProfile;
@class BMWLinkedInView;

@protocol BMWLinkedInViewDelegate

- (BMWLinkedInProfile *)attendeeforAttendeeView:(BMWLinkedInView *)profileView;

@end

@interface BMWLinkedInView : IDTableLayoutView

//@property (nonatomic, strong) NSDictionary *linkedInProfile;

@property (nonatomic, weak) id <BMWLinkedInViewDelegate> linkedInDelegate;
@property (nonatomic, strong) BMWLinkedInProfile *profile;




@end



