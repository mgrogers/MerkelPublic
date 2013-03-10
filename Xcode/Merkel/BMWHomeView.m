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

    //Added to test. Link to profile should appear when user view's his next event.
    IDButton *linkedinButton = [IDButton button];
    linkedinButton.text = @"LinkedIn Profile";
    provider.linkedinView.linkedInProfile = [[BMWGCalendarDataSource sharedDataSource] linkedinToDisplayFromEvent];
    [linkedinButton setTargetView:provider.linkedinView];
    self.widgets = @[nextButton, todayButton, linkedinButton];

}

- (void)viewDidBecomeFocused:(IDView *)view {
    BMWViewProvider *provider = self.application.hmiProvider;
    provider.calendarListView.events = [[BMWGCalendarDataSource sharedDataSource] eventsToDisplayCompletion:^(NSArray *events, NSError *error) {
        provider.calendarListView.events = events;
    }];
}

@end
