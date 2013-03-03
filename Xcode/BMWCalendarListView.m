//
//  BMWCalendarListView.m
//  Merkel
//
//  Created by Tim Shi on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWCalendarListView.h"

#import "BMWGCalendarEvent.h"

@implementation BMWCalendarListView

- (void)viewWillLoad:(IDView *)view {
    self.title = @"Today's Events";
    NSMutableArray *eventButtons = [NSMutableArray array];
    for (BMWGCalendarEvent *event in self.events) {
        IDButton *button = [IDButton button];
        button.text = event.title;
        [eventButtons addObject:button];
    }
    self.widgets = eventButtons;
}

@end

