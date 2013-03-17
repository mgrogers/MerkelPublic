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

- (void)viewWillLoad:(IDView *)view {
    BMWViewProvider *provider = self.application.hmiProvider;
    self.title = @"Today's Events";
    NSMutableArray *eventButtons = [NSMutableArray array];
    const NSInteger kButtonLimit = 50;
    for (int i = 0; i < kButtonLimit; i++) {
        IDButton *button = [IDButton button];
        [button setTarget:self selector:@selector(buttonFocused:) forActionEvent:IDActionEventFocus];
        [button setTargetView:provider.calendarEventView];
        button.visible = NO;
        [eventButtons addObject:button];
    }
    self.widgets = eventButtons;
}

- (void)viewDidBecomeFocused:(IDView *)view {
    
    NSInteger index = 0;
    for (BMWGCalendarEvent *event in self.events) {
        IDButton *button = [self.widgets objectAtIndex:index];
        button.text = event.title;
        button.visible = YES;
        index++;
    }
}

- (void)viewDidLoseFocus:(IDView *)view {
    for (IDButton *button in self.widgets) {
        button.visible = NO;
    }
}

- (void)buttonFocused:(IDButton *)button {
    _selectedIndex = [self.widgets indexOfObject:button];
    BMWViewProvider *provider = self.application.hmiProvider;
    provider.calendarEventView.event = self.events[_selectedIndex];
}

@end
