//
//  BMWCalendarEventView.m
//  Merkel
//
//  Created by Tim Shi on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWCalendarEventView.h"

#import "BMWGCalendarDataSource.h"
#import "BMWGCalendarEvent.h"
#import "BMWLinkedInProfile.h"
#import "BMWViewProvider.h"

@interface BMWCalendarEventView ()

@property (nonatomic, strong) IDLabel *titleLabel, *descriptionLabel, *startLabel, *endLabel;
@property (nonatomic, strong) NSArray *allViews, *detailViews, *placeViews, *peopleViews;
@property (nonatomic, strong) NSMutableArray *allWidgets;
@property (nonatomic, strong) NSArray *attendees;

@end

@implementation BMWCalendarEventView

static const NSInteger kAttendeesToDisplay = 3;

- (void)viewWillLoad:(IDView *)view {
    self.toolbarWidgets = [self createToolbarButtons];
    [self createAllViews];
    self.widgets = self.allWidgets;
}

- (void)viewDidBecomeFocused:(IDView *)view {
    BMWViewProvider *provider = self.application.hmiProvider;
    
    //Grabs first event from eventsToDisplay
//    self.event = [provider.calendarListView.events objectAtIndex:0];
    self.attendees = self.event.attendees;
    provider.attendeeListView.attendees = self.attendees;
    if (self.event) {
        [self updateDisplayForEvent:self.event];
    } else {
        self.title = @"No event";
        self.titleLabel.text = @"No upcoming events";
        self.descriptionLabel.text = @"No upcoming events to show.";
    }
}

//- (void)viewDidLoseFocus:(IDView *)view {
//    BMWViewProvider *provider = self.application.hmiProvider;
//    provider.attendeeListView.attendees = nil;
//}

- (NSArray *)createToolbarButtons {
    BMWViewProvider *provider = self.application.hmiProvider;
    const NSInteger kNumToolbarButtons = 3;
    NSMutableArray *buttons = [NSMutableArray array];
    for (int i = 0; i < kNumToolbarButtons; i++) {
        IDButton *toolbarButton = [IDButton button];
        IDImageData *data = [self imageForIndex:i];
        if (data) {
            toolbarButton.imageData = data;
        }
        toolbarButton.text = [self tooltipForIndex:i];
        [toolbarButton setTarget:self selector:@selector(toolbarButtonPressed:) forActionEvent:IDActionEventSelect];
        [toolbarButton setTarget:self selector:@selector(toolbarButtonFocused:) forActionEvent:IDActionEventFocus];
        [buttons addObject:toolbarButton];
    }
    [buttons[2] setTargetView:provider.attendeeListView];
    return buttons;
}

#pragma mark - Toolbar Setup

- (IDImageData *)imageForIndex:(NSInteger)index
{
    static NSArray *images = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        images = @[[self.application.imageBundle imageWithName:@"iconNote" type:@"png"],
                   [self.application.imageBundle imageWithName:@"iconFlag" type:@"png"],
                   [self.application.imageBundle imageWithName:@"iconMan" type:@"png"]];

    });
    return [images objectAtIndex:index];
}

- (NSString *)tooltipForIndex:(NSInteger)index {
    static NSArray *tooltips = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tooltips = @[@"Details",
                     @"Place",
                     @"People"];
    });
    return [tooltips objectAtIndex:index];
}

#pragma mark - Screen Setup

- (NSArray *)createAllViews {
    self.allWidgets = [NSMutableArray array];
    self.allViews = @[[self createDetailViews], [self createPlaceViews], [self createPeopleViews]];
    return self.allViews;
}

- (NSArray *)createDetailViews {
    self.titleLabel = [IDLabel label];
    self.titleLabel.selectable = NO;
    self.titleLabel.isInfoLabel = YES;
    self.titleLabel.visible = NO;
    self.descriptionLabel = [IDLabel label];
    self.descriptionLabel.selectable = NO;
    self.descriptionLabel.visible = NO;
    self.startLabel = [IDLabel label];
    self.startLabel.selectable = NO;
    self.startLabel.visible = NO;
    self.endLabel = [IDLabel label];
    self.endLabel.selectable = NO;
    self.endLabel.visible = NO;
    self.detailViews = @[self.titleLabel, self.descriptionLabel, self.startLabel, self.endLabel];
    [self.allWidgets addObjectsFromArray:self.detailViews];
    return self.detailViews;
}

- (NSArray *)createPlaceViews {
    self.placeViews = @[];
    [self.allWidgets addObjectsFromArray:self.placeViews];
    return self.placeViews;
}

- (NSArray *)createPeopleViews {
    NSMutableArray *tempViews = [NSMutableArray array];
    for (int i = 0; i < kAttendeesToDisplay; i++) {
        IDLabel *nameLabel = [IDLabel label];
        nameLabel.isInfoLabel = YES;
        nameLabel.selectable = NO;
        nameLabel.visible = NO;
        IDLabel *titleLabel = [IDLabel label];
        titleLabel.isInfoLabel = NO;
        titleLabel.selectable = NO;
        titleLabel.visible = NO;
        [tempViews addObject:nameLabel];
        [tempViews addObject:titleLabel];
    }
    IDLabel *moreLabel = [IDLabel label];
    moreLabel.selectable = NO;
    moreLabel.visible = NO;
    moreLabel.isInfoLabel = YES;
    moreLabel.text = @"Click for more details";
    [tempViews addObject:moreLabel];
    self.peopleViews = [NSArray arrayWithArray:tempViews];
    [self.allWidgets addObjectsFromArray:self.peopleViews];
    return self.peopleViews;
}

#pragma mark - Event handlers

- (void)toolbarButtonPressed:(IDButton *)button
{
//    NSInteger index = [self.toolbarWidgets indexOfObject:button];
}

- (void)toolbarButtonFocused:(IDButton *)button
{
    NSInteger index = [self.toolbarWidgets indexOfObject:button];
    BMWViewProvider *provider = self.application.hmiProvider;
    provider.attendeeListView.attendees = self.attendees;
    [self updateDisplayForIndex:index];
}

- (void)updateDisplayForIndex:(NSInteger)index {
    for (NSArray *view in self.allViews) {
        for (IDWidget *widget in view) {
            widget.visible = NO;
        }
    }
    NSArray *curView = self.allViews[index];
    for (IDWidget *widget in curView) {
        widget.visible = YES;
    }
}

- (void)updateDisplayForEvent:(BMWGCalendarEvent *)event {
    self.title = event.title;
    self.titleLabel.text = event.title;
    self.descriptionLabel.text = event.eventDescription;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    self.startLabel.text = [NSString stringWithFormat:@"Start: %@", [formatter stringFromDate:event.startDate]];
    self.endLabel.text = [NSString stringWithFormat:@"End: %@", [formatter stringFromDate:event.endDate]];
    [self updateDisplayForAttendees:self.attendees];
    
}

- (void)updateDisplayForAttendees:(NSArray *)attendees {
    for (int i = 0; i < [attendees count]; i++) {
        BMWLinkedInProfile *profile = [attendees objectAtIndex:i];
        IDLabel *nameLabel = [self.peopleViews objectAtIndex:i*2];
        IDLabel *titleLabel = [self.peopleViews objectAtIndex:i*2 + 1];
        nameLabel.text = profile.name;
        titleLabel.text = profile.jobTitle;
    }
}

@end
