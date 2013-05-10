//
//  BMWTimeIndicatorView.m
//  Merkel
//
//  Created by Tim Shi on 5/10/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWTimeIndicatorView.h"

@interface BMWTimeIndicatorView ()

@property (readwrite) BMWTimeIndicatorState indicatorState;
@property (nonatomic, strong) UIView *indicatorBarView, *meetingDurationView;
@property (nonatomic, strong) UILabel *indicatorStartLabel, *indicatorEndLabel, *eventStartLabel, *eventEndLabel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *indicatorStartTime, *indicatorEndTime;
@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation BMWTimeIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInitializer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self sharedInitializer];
    }
    return self;
}

- (void)sharedInitializer {
    _indicatorState = BMWTimeIndicatorStateBeforeEvent;
    self.calendar = [NSCalendar currentCalendar];
    self.trackColor = [UIColor whiteColor];
    self.timeIndicatorColor = [UIColor greenColor];
    self.labelColor = [UIColor blackColor];
    self.labelFont = [UIFont systemFontOfSize:14.0];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.indicatorBarView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.indicatorBarView];
    self.meetingDurationView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.meetingDurationView];
    self.indicatorStartLabel = [self createNewLabelAndAddAsSubview];
    self.indicatorEndLabel = [self createNewLabelAndAddAsSubview];
    self.eventStartLabel = [self createNewLabelAndAddAsSubview];
    self.eventEndLabel = [self createNewLabelAndAddAsSubview];
}

- (UILabel *)createNewLabelAndAddAsSubview {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = self.labelFont;
    label.textColor = self.labelColor;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    return label;
}

- (void)setLabelFont:(UIFont *)labelFont {
    _labelFont = labelFont;
    self.indicatorStartLabel.font = labelFont;
    self.indicatorEndLabel.font = labelFont;
    self.eventStartLabel.font = labelFont;
    self.eventEndLabel.font = labelFont;
}

- (void)setLabelColor:(UIColor *)labelColor {
    _labelColor = labelColor;
    self.indicatorStartLabel.backgroundColor = labelColor;
    self.indicatorEndLabel.backgroundColor = labelColor;
    self.eventStartLabel.backgroundColor = labelColor;
    self.eventEndLabel.backgroundColor = labelColor;
}

- (void)setTrackColor:(UIColor *)trackColor {
    _trackColor = trackColor;
    self.backgroundColor = trackColor;
}

- (void)setTimeIndicatorColor:(UIColor *)timeIndicatorColor {
    _timeIndicatorColor = timeIndicatorColor;
    self.indicatorBarView.backgroundColor = timeIndicatorColor;
}

- (void)setStartTime:(NSDate *)startTime {
    _startTime = startTime;
    self.indicatorStartTime = [self dateWithHourDelta:-2 fromDate:startTime];
}

- (void)setEndTime:(NSDate *)endTime {
    _endTime = endTime;
    self.indicatorEndTime = [self dateWithHourDelta:2 fromDate:endTime];
}

- (NSDate *)dateWithHourDelta:(NSInteger)hourDelta fromDate:(NSDate *)fromDate {
    NSDateComponents *dateComponents = [self.calendar components:NSMinuteCalendarUnit fromDate:fromDate];
    NSInteger minuteDelta = 60 - dateComponents.minute;
    dateComponents.hour = hourDelta;
    dateComponents.minute = minuteDelta;
    NSDate *newDate = [self.calendar dateByAddingComponents:dateComponents toDate:fromDate options:0];
    return newDate;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)startAnimating {
    
}

- (void)stopAnimating {
    
}

@end
