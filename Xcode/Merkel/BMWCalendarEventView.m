//
//  BMWCalendarEventView.m
//  Merkel
//
//  Created by Tim Shi on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWCalendarEventView.h"

#import "BMWGCalendarEvent.h"
#import "BMWViewProvider.h"

@interface BMWCalendarEventView ()

@property (nonatomic, strong) IDLabel *titleLabel;

@end

@implementation BMWCalendarEventView

+ (IDView *)view {
    return [super view];
}

- (void)viewWillLoad:(IDView *)view {
    self.titleLabel = [IDLabel label];
    self.titleLabel.selectable = NO;
    self.titleLabel.position = CGPointMake(80, 8);
    self.widgets = @[self.titleLabel];
}

- (void)viewDidBecomeFocused:(IDView *)view {
    self.event = [self.eventDelegate eventForEventView:self];
    if (self.event) {
        self.title = self.event.title;
        self.titleLabel.text = self.event.title;
    }
}

@end
