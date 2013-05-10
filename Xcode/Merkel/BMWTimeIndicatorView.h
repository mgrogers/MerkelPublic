//
//  BMWTimeIndicatorView.h
//  Merkel
//
//  Created by Tim Shi on 5/10/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BMWTimeIndicatorState) {
    BMWTimeIndicatorStateBeforeEvent,
    BMWTimeIndicatorStateDuringEvent,
    BMWTimeIndicatorStateAfterEvent
};

@class BMWTimeIndicatorView;

@protocol BMWTimeIndicatorViewDelegate

- (void)timeIndicatorView:(BMWTimeIndicatorView *)indicatorView didMoveIndicatorRect:(CGRect)rect;
- (void)timeIndicatorView:(BMWTimeIndicatorView *)indicatorView didChangeIndicatorState:(BMWTimeIndicatorState)indicatorState;

@end

@interface BMWTimeIndicatorView : UIView

@property (nonatomic, strong) UIColor *trackColor, *timeIndicatorColor, *labelColor, *borderColor, *labelFontColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic, strong) NSDate *startTime, *endTime;
@property (nonatomic, strong) UIFont *labelFont;
@property (readonly) BMWTimeIndicatorState indicatorState;

- (void)startAnimating;
- (void)stopAnimating;

@end
