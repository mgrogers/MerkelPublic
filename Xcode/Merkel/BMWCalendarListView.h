//
//  BMWCalendarListView.h
//  Merkel
//
//  Created by Tim Shi on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinder. All rights reserved.
//

// Lists the user's events as returned by eventsToDisplay:. Clicking on
// an event brings the user to a BMWCalendarEventView.

#import <BMWAppKit/BMWAppKit.h>
#import "BMWCalendarEventView.h"

@interface BMWCalendarListView : IDView <IDViewDelegate>

@property (nonatomic, strong) NSArray *events;

@end
