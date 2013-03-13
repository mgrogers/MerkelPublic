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

@interface BMWHomeView ()

@property (nonatomic, strong) IDButton *nextButton;

@end

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
    self.nextButton = [IDButton button];
    self.nextButton.text = @"Next Event";
    [self.nextButton setTargetView:provider.calendarEventView];
    [self.nextButton setTarget:self selector:@selector(buttonPressed:) forActionEvent:IDActionEventSelect];
    [self.nextButton setTarget:self selector:@selector(buttonFocused:) forActionEvent:IDActionEventFocus];
    
    
    IDButton *todayButton = [IDButton button];
    todayButton.text = @"Today's Events";
    IDLabel *spinner = [IDLabel label];
    spinner.waitingAnimation = YES;
    self.nextButton.visible = NO;
    todayButton.visible = NO;
    [todayButton setTarget:self selector:@selector(buttonFocused:) forActionEvent:IDActionEventFocus];
    [todayButton  setTargetView:provider.calendarListView];
    
    self.widgets = @[self.nextButton, todayButton, spinner];
    
}

- (void)buttonFocused:(IDButton *)button {
    NSInteger selectedIndex = [self.widgets indexOfObject:button];
    BMWViewProvider *provider = self.application.hmiProvider;
    if (selectedIndex == 0) {
        provider.calendarEventView.event = [provider.calendarListView.events objectAtIndex:0];
    }
}

- (void)buttonPressed:(IDButton *)button {
    if (button == self.nextButton) {
        BMWViewProvider *provider = self.application.hmiProvider;
        BMWGCalendarEvent *nextEvent = [provider.calendarListView.events objectAtIndex:0];
        NSString *requestString = [NSString stringWithFormat:@"http://bossmobilewunderkinds.herokuapp.com/api/sms/send?to=%@&body=%@"]
    }
}

@end
