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
@property (nonatomic, strong) NSArray *allViews, *detailViews, *placeViews, *peopleViews;
@property (nonatomic, strong) NSMutableArray *allWidgets;

@end

@implementation BMWCalendarEventView

- (void)viewWillLoad:(IDView *)view {
//    self.titleLabel = [IDLabel label];
//    self.titleLabel.selectable = NO;
//    self.titleLabel.position = CGPointMake(0, 8);
//    self.startRow = 2;
//    self.descriptionLabel = [IDLabel label];
//    self.startLabel = [IDLabel label];
//    self.endLabel = [IDLabel label];
//    self.widgets = @[self.titleLabel, self.descriptionLabel, self.startLabel, self.endLabel];
    self.toolbarWidgets = [self createToolbarButtons];
    [self createAllViews];
    self.widgets = self.allWidgets;
}

- (void)viewDidBecomeFocused:(IDView *)view {
//    self.event = [self.eventDelegate eventForEventView:self];
    self.event = [BMWGCalendarEvent testEvent];
    if (self.event) {
        self.title = self.event.title;
        self.titleLabel.text = self.event.title;
        self.descriptionLabel.text = self.event.eventDescription;
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateStyle:NSDateFormatterMediumStyle];
//        [formatter setTimeStyle:NSDateFormatterMediumStyle];
//        self.startLabel.text = [formatter stringFromDate:self.event.startDate];
//        self.endLabel.text = [formatter stringFromDate:self.event.endDate];
    }
}

- (NSArray *)createToolbarButtons {
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
//    self.titleLabel.position = CGPointMake(0, 8);
    self.titleLabel.isInfoLabel = YES;
    self.titleLabel.visible = NO;
    self.descriptionLabel = [IDLabel label];
    self.descriptionLabel.selectable = NO;
//    self.descriptionLabel.position = CGPointMake(0, 20);
    self.descriptionLabel.visible = NO;
    self.detailViews = @[self.titleLabel, self.descriptionLabel];
    [self.allWidgets addObjectsFromArray:self.detailViews];
    return self.detailViews;
}

- (NSArray *)createPlaceViews {
    self.placeViews = @[];
    [self.allWidgets addObjectsFromArray:self.placeViews];
    return self.placeViews;
}

- (NSArray *)createPeopleViews {
    self.peopleViews = @[];
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

@end
