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
    IDButton *button = [IDButton button];
    button.text = @"Today's Events";
    provider.calendarListView.events = [[BMWGCalendarDataSource sharedDataSource] eventsToDisplay];
    [button  setTargetView:provider.calendarListView];
    self.widgets = @[button];
}

@end
