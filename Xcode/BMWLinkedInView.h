//
//  BMWLinkedInView.h
//  Merkel
//
//  Created by Wesley Leung on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <BMWAppKit/BMWAppKit.h>

@interface BMWLinkedInView : IDTableLayoutView

@property (nonatomic, strong) NSDictionary *linkedInProfile;
@property (nonatomic, weak) id <BMWCalendarEventViewDelegate> eventDelegate;

@property (nonatomic, strong) BMWGCalendarEvent *event;

@end

