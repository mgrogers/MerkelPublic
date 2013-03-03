//
//  BMWCalendarListView.m
//  Merkel
//
//  Created by Tim Shi on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWCalendarListView.h"

#import "BMWGCalendarEvent.h"
#import "BMWViewProvider.h"

@interface BMWCalendarListView ()

@property NSInteger selectedIndex;

@end

@implementation BMWCalendarListView

+ (IDView *)view {
    return [super view];
}

- (void)viewWillLoad:(IDView *)view {
    BMWViewProvider *provider = self.application.hmiProvider;
    provider.calendarEventView.eventDelegate = self;
    self.title = @"Today's Events";
    NSMutableArray *eventButtons = [NSMutableArray array];
    for (BMWGCalendarEvent *event in self.events) {
        IDButton *button = [IDButton button];
        [button setTarget:self selector:@selector(buttonFocused:) forActionEvent:IDActionEventFocus];
        [button setTargetView:provider.calendarEventView];
        button.text = event.title;
        [eventButtons addObject:button];
    }
    self.widgets = eventButtons;
}

- (void)buttonFocused:(IDButton *)button {
    _selectedIndex = [self.widgets indexOfObject:button];
}

#pragma mark - BMWCalendarEventViewDelegate

- (BMWGCalendarEvent *)eventForEventView:(BMWCalendarEventView *)eventView {
    return self.events[self.selectedIndex];
}
@end

