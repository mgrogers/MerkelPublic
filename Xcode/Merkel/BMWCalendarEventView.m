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

@property (nonatomic, strong) IDLabel *titleLabel, *descriptionLabel, *startLabel, *endLabel;

@end

@implementation BMWCalendarEventView

+ (IDView *)view {
    return [super view];
}

- (void)viewWillLoad:(IDView *)view {
    self.titleLabel = [IDLabel label];
    self.titleLabel.selectable = NO;
    self.titleLabel.position = CGPointMake(0, 8);
    self.startRow = 2;
    self.descriptionLabel = [IDLabel label];
    self.startLabel = [IDLabel label];
    self.endLabel = [IDLabel label];
    self.widgets = @[self.titleLabel, self.descriptionLabel, self.startLabel, self.endLabel];
}

- (void)viewDidBecomeFocused:(IDView *)view {
    self.event = [self.eventDelegate eventForEventView:self];
    if (self.event) {
        self.title = self.event.title;
        self.titleLabel.text = self.event.title;
        self.descriptionLabel.text = self.event.eventDescription;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        self.startLabel.text = [formatter stringFromDate:self.event.startDate];
        self.endLabel.text = [formatter stringFromDate:self.event.endDate];
    }
}

@end
