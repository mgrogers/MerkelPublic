//
//  BMWCalendarEventView.h
//  Merkel
//
//  Created by Tim Shi on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <BMWAppKit/BMWAppKit.h>

@class BMWCalendarEventView;
@class BMWGCalendarEvent;

@protocol BMWCalendarEventViewDelegate

- (BMWGCalendarEvent *)eventForEventView:(BMWCalendarEventView *)eventView;

@end

@interface BMWCalendarEventView : IDToolbarView

@property (nonatomic, weak) id <BMWCalendarEventViewDelegate> eventDelegate;

@property (nonatomic, strong) BMWGCalendarEvent *event;

@end
