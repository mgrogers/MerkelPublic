//
//  BMWCalendarEventView.h
//  Merkel
//
//  Created by Tim Shi on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

// Toolbar view to display details of a calendar event. Provides access
// to a LinkedIn list view of the attendees.

#import <BMWAppKit/BMWAppKit.h>

@class BMWGCalendarEvent;

@interface BMWCalendarEventView : IDToolbarView

@property (nonatomic, strong) BMWGCalendarEvent *event;

@end
