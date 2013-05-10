//
//  BMWTimeIndicatorView.m
//  Merkel
//
//  Created by Tim Shi on 5/10/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWTimeIndicatorView.h"

#import <QuartzCore/QuartzCore.h>

@interface BMWTimeIndicatorView ()

@property (readwrite) BMWTimeIndicatorState indicatorState;
@property (nonatomic, strong) UIView *indicatorBarView, *meetingDurationView;
@property (nonatomic, strong) UILabel *indicatorStartLabel, *indicatorEndLabel, *eventStartLabel, *eventEndLabel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *indicatorStartTime, *indicatorEndTime;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSTimer *animationTimer;

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
    // Set up default values.
    _indicatorState = BMWTimeIndicatorStateBeforeEvent;
    self.calendar = [NSCalendar currentCalendar];
    self.trackColor = [UIColor clearColor];
    self.timeIndicatorColor = [UIColor redColor];
    self.labelColor = [UIColor blackColor];
    self.borderColor = [UIColor blackColor];
    self.borderWidth = 1.0;
    self.labelFont = [UIFont systemFontOfSize:14.0];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"h a"];
    self.meetingDurationView = [[UIView alloc] initWithFrame:CGRectZero];
    self.meetingDurationView.backgroundColor = self.timeIndicatorColor;
    self.meetingDurationView.alpha = 0.3;
    [self addSubview:self.meetingDurationView];
    self.indicatorBarView = [[UIView alloc] initWithFrame:CGRectZero];
    self.indicatorBarView.backgroundColor = self.timeIndicatorColor;
    [self addSubview:self.indicatorBarView];
    self.indicatorStartLabel = [self createNewLabelAndAddAsSubview];
    self.indicatorStartLabel.textAlignment = NSTextAlignmentLeft;
    self.indicatorEndLabel = [self createNewLabelAndAddAsSubview];
    self.indicatorEndLabel.textAlignment = NSTextAlignmentRight;
    self.eventStartLabel = [self createNewLabelAndAddAsSubview];
    self.eventStartLabel.textAlignment = NSTextAlignmentLeft;
    self.eventEndLabel = [self createNewLabelAndAddAsSubview];
    self.eventEndLabel.textAlignment = NSTextAlignmentRight;
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

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

- (void)setStartTime:(NSDate *)startTime {
    _startTime = startTime;
    self.eventStartLabel.text = [self.dateFormatter stringFromDate:startTime];
    self.indicatorStartTime = [self dateWithHourDelta:-2 fromDate:startTime];
    self.indicatorStartLabel.text = [self.dateFormatter stringFromDate:self.indicatorStartTime];
}

- (void)setEndTime:(NSDate *)endTime {
    _endTime = endTime;
    self.eventEndLabel.text = [self.dateFormatter stringFromDate:endTime];
    self.indicatorEndTime = [self dateWithHourDelta:2 fromDate:endTime];
    self.indicatorEndLabel.text = [self.dateFormatter stringFromDate:self.indicatorEndTime];
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
    static const CGFloat kCurrentTimeIndicatorWidthScaleFactor = 0.01;
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
    [self positionLabel:self.indicatorStartLabel atXOffset:0.0];
    [self positionLabel:self.eventStartLabel withRightSideAtX:eventOffsetX];
    [self positionLabel:self.eventEndLabel atXOffset:eventOffsetX+eventWidth];
    [self positionLabel:self.indicatorEndLabel withRightSideAtX:trackWidth];
}

static const CGFloat kPadding = 2.0;

- (void)positionLabel:(UILabel *)label atXOffset:(CGFloat)xOffset {
    CGFloat trackHeight = self.frame.size.height;
    CGSize textSize = [label.text sizeWithFont:label.font];
    CGRect labelFrame = CGRectZero;
    labelFrame.size = textSize;
    label.frame = labelFrame;
    label.center = CGPointMake(xOffset + (textSize.width / 2.0) + kPadding, (trackHeight / 2.0) + (textSize.height / 2.0) - kPadding);
}

- (void)positionLabel:(UILabel *)label withRightSideAtX:(CGFloat)x {
    CGFloat trackHeight = self.frame.size.height;
    CGSize textSize = [label.text sizeWithFont:label.font];
    CGRect labelFrame = CGRectZero;
    labelFrame.size = textSize;
    label.frame = labelFrame;
    label.center = CGPointMake(x - (textSize.width / 2.0) - kPadding, (trackHeight / 2.0) + (textSize.height / 2.0) - kPadding);
}

- (void)startAnimating {
    static const NSTimeInterval kAnimationTimerInterval = 1.0;
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:kAnimationTimerInterval
                                                           target:self
                                                         selector:@selector(animateObjects)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (void)animateObjects {
    static const NSTimeInterval kAnimationDuration = 0.2;
    static const CGFloat kCurrentTimeIndicatorWidthScaleFactor = 0.01;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSInteger totalSeconds = [self.calendar components:NSSecondCalendarUnit fromDate:self.indicatorStartTime toDate:self.indicatorEndTime options:0].second;
        NSInteger currentTimeOffsetSeconds = [self.calendar components:NSSecondCalendarUnit fromDate:self.indicatorStartTime toDate:[NSDate date] options:0].second;
        CGFloat trackWidth = self.frame.size.width;
        CGFloat trackHeight = self.frame.size.height;
        CGFloat currentTimeIndicatorOffsetX = (((CGFloat)currentTimeOffsetSeconds) / totalSeconds) * trackWidth;
        CGFloat currentTimeIndicatorWidth = trackWidth * kCurrentTimeIndicatorWidthScaleFactor;
        CGRect currentTimeIndicatorFrame = CGRectMake(currentTimeIndicatorOffsetX - (currentTimeIndicatorWidth / 2), 0.0, currentTimeIndicatorWidth, trackHeight);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.indicatorBarView.frame = currentTimeIndicatorFrame;
            }];
        });
    });
}

- (void)stopAnimating {
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}

@end
