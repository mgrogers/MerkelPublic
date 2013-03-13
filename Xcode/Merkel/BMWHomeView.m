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
    [self createAllViews];
}

- (void)viewDidBecomeFocused:(IDView *)view {
    BMWViewProvider *provider = self.application.hmiProvider;
    provider.calendarListView.events = [[BMWGCalendarDataSource sharedDataSource] eventsToDisplayCompletion:^(NSArray *events, NSError *error) {
        provider.calendarListView.events = events;
        
        IDLabel *spinner = self.widgets[2];
        IDButton *nextButton = self.widgets[0];
        IDButton *todayButton = self.widgets[1];
        
        spinner.waitingAnimation = NO;
        spinner.visible = NO;
        spinner.selectable = NO;
        nextButton.visible = YES;
        todayButton.visible = YES;
    }];
}

- (void)createAllViews {
    BMWViewProvider *provider = self.application.hmiProvider;
    self.title = @"Merkel";
    IDButton *nextButton = [IDButton button];
    nextButton.text = @"Next Event";
    [nextButton setTargetView:provider.calendarEventView];
    [nextButton setTarget:self selector:@selector(buttonFocused:) forActionEvent:IDActionEventFocus];
    
    
    IDButton *todayButton = [IDButton button];
    todayButton.text = @"Today's Events";
    IDLabel *spinner = [IDLabel label];
    spinner.waitingAnimation = YES;
    nextButton.visible = NO;
    todayButton.visible = NO;
    [todayButton setTarget:self selector:@selector(buttonFocused:) forActionEvent:IDActionEventFocus];
    [todayButton  setTargetView:provider.calendarListView];
    
    self.widgets = @[nextButton, todayButton, spinner];
    
}

- (void)buttonFocused:(IDButton *)button {
    NSInteger selectedIndex = [self.widgets indexOfObject:button];
    BMWViewProvider *provider = self.application.hmiProvider;
    if (selectedIndex == 0) {
        provider.calendarEventView.event = [provider.calendarListView.events objectAtIndex:0];
    }
}

@end
