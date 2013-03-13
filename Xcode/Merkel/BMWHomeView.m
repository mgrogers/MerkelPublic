//
//  BMWMainView.m
//  Merkel
//
//  Created by Tim Shi on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWHomeView.h"

#import "BMWGCalendarDataSource.h"
#import "BMWViewProvider.h"

@implementation BMWHomeView

- (void)viewWillLoad:(IDView *)view {
    BMWViewProvider *provider = self.application.hmiProvider;
    self.title = @"Merkel";
    IDButton *nextButton = [IDButton button];
    nextButton.text = @"Next Event";
    [nextButton setTargetView:provider.calendarEventView];
    IDButton *todayButton = [IDButton button];
    todayButton.text = @"Today's Events";
    provider.calendarListView.events = [[BMWGCalendarDataSource sharedDataSource] eventsToDisplayCompletion:^(NSArray *events, NSError *error) {
        provider.calendarListView.events = events;
    }];
    [todayButton  setTargetView:provider.calendarListView];

    self.widgets = @[nextButton, todayButton];

}

- (void)viewDidBecomeFocused:(IDView *)view {
    BMWViewProvider *provider = self.application.hmiProvider;
    provider.calendarListView.events = [[BMWGCalendarDataSource sharedDataSource] eventsToDisplayCompletion:^(NSArray *events, NSError *error) {
        provider.calendarListView.events = events;
    }];
}

- (void)buttonFocused:(IDButton *)button {
    NSInteger selectedIndex = [self.widgets indexOfObject:button];
    BMWViewProvider *provider = self.application.hmiProvider;
    if (selectedIndex == 0) {
        provider.calendarEventView.event = [provider.calendarListView.events objectAtIndex:0];
    }
//    provider.calendarEventView.event = self.events[_selectedIndex];
}

@end
