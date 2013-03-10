//
//  BMWAttendeeListViewDetail.h
//  Merkel
//
//  Created by Wesley Leung on 3/10/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <BMWAppKit/BMWAppKit.h>
#import "BMWLinkedInProfile.h"
#import "BMWLinkedInView.h"

@interface BMWAttendeeListViewDetail : IDView <BMWLinkedInViewDelegate, IDViewDelegate>

@property (nonatomic, strong) NSArray *attendees;

@end


