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
    static const CGFloat kCurrentTimeIndicatorWidthScaleFactor = 0.05;
    [super layoutSubviews];
    NSInteger totalMinutes = [self.calendar components:NSMinuteCalendarUnit fromDate:self.indicatorStartTime toDate:self.indicatorEndTime options:0].minute;
    NSInteger eventMinutes = [self.calendar components:NSMinuteCalendarUnit fromDate:self.startTime toDate:self.endTime options:0].minute;
    NSInteger eventOffsetMinutes = [self.calendar components:NSMinuteCalendarUnit fromDate:self.indicatorStartTime toDate:self.startTime options:0].minute;
    NSInteger currentTimeOffsetMinutes = [self.calendar components:NSMinuteCalendarUnit fromDate:self.indicatorStartTime toDate:[NSDate date] options:0].minute;
    CGFloat trackWidth = self.frame.size.width;
    CGFloat trackHeight = self.frame.size.height;
    CGFloat eventOffsetX = (((CGFloat)eventOffsetMinutes) / totalMinutes) * trackWidth;
    CGFloat currentTimeIndicatorOffsetX = (((CGFloat)currentTimeOffsetMinutes) / totalMinutes) * trackWidth;
    CGFloat eventWidth = (((CGFloat)eventMinutes) / totalMinutes) * trackWidth;
    CGRect eventFrame = CGRectMake(eventOffsetX, 0.0, eventWidth, trackHeight);
    self.meetingDurationView.frame = eventFrame;
    CGFloat currentTimeIndicatorWidth = trackWidth * kCurrentTimeIndicatorWidthScaleFactor;
    CGRect currentTimeIndicatorFrame = CGRectMake(currentTimeIndicatorOffsetX - (currentTimeIndicatorWidth / 2), 0.0, currentTimeIndicatorWidth, trackHeight);
    self.indicatorBarView.frame = currentTimeIndicatorFrame;
}

- (void)startAnimating {
    
}

- (void)stopAnimating {
    
}

@end
