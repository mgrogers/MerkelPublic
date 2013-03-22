

//
//  BMWMainView.m
//  Merkel
//
//  Created by Tim Shi on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinder. All rights reserved.
//

#import "BMWHomeView.h"

#import "BMWGCalendarDataSource.h"
#import "BMWGCalendarEvent.h"
#import "BMWViewProvider.h"

@interface BMWHomeView ()

@property (nonatomic, strong) IDButton *nextButton;

@end

@implementation BMWHomeView

- (void)viewWillLoad:(IDView *)view {
    [self createAllViews];
}

- (void)viewDidBecomeFocused:(IDView *)view {
    //check if user here?
    if([PFUser currentUser]) {
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
    } else {
        IDLabel *disconnectLabel = self.widgets[3];
        IDLabel *disconnectLabel2 = self.widgets[4];
        IDLabel *spinner = self.widgets[2];
        spinner.visible = NO;
        disconnectLabel.visible = YES;
        disconnectLabel2.visible = YES;
    }
    
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
    
    IDLabel *disconnectLabel = [IDLabel label];
    IDLabel *disconnectLabel2 = [IDLabel label];
    
    disconnectLabel.text = @"Sorry, please unplug your phone.";
    disconnectLabel2.text = @"Log in and reconnect your device.";
    disconnectLabel.visible = NO;
    disconnectLabel2.visible = NO;
    
    self.widgets = @[self.nextButton, todayButton, spinner, disconnectLabel, disconnectLabel2];
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
        NSString *phoneNumber = [[PFUser currentUser] objectForKey:@"phone_number"];
        if (!phoneNumber) {
            return;
        }
        if(nextEvent) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterShortStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            NSString *message = [NSString stringWithFormat:@"Your event: %@\r\n is at: %@", nextEvent.title, [formatter stringFromDate:nextEvent.startDate]];
            NSString *requestString = [NSString stringWithFormat:@"http://bossmobilewunderkinds.herokuapp.com/api/sms/send?to=%@&body=%@", phoneNumber, message];
            requestString  = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *requestURL = [NSURL URLWithString:requestString];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSData *response = [NSData dataWithContentsOfURL:requestURL];
                NSLog(@"%@", response);
            });
        }
    }
}

@end
