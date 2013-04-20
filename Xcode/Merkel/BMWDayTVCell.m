//
//  ConferTableViewCell.m
//  Merkel
//
//  Created by Wesley Leung on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWDayTVCell.h"

@implementation BMWDayTableViewCell {
    CGPoint _originalCenter;
    BOOL _rightDragRelease;
    BOOL _leftDragRelease;
    
    UILabel *_leftDragLabel;
    UILabel *_rightDragLabel;
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setupCueLabels];
        [self setupGestureRecognizers];
    }
    return self;
}

-(void)setupCueLabels {
    _leftDragLabel = [self createCueLabel];
    _leftDragLabel.text = @"Late";
    
    _leftDragLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_leftDragLabel];
    
    _rightDragLabel = [self createCueLabel];
    _rightDragLabel.text = @"Join";
    _rightDragLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_rightDragLabel];
}

-(void)setupGestureRecognizers {
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    recognizer.delegate = self;
    [self addGestureRecognizer:recognizer];
}

#pragma mark - horizontal pan gesture methods
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];

    //checks for horizontal gestures
    if (fabsf(translation.x) > fabsf(translation.y)) {
        return YES;
    }
    return NO;
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    //if the gesture has just started, record the current center location
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _originalCenter = self.center;
    }

    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        _rightDragRelease = self.frame.origin.x < -self.frame.size.width / 8;
        _leftDragRelease = self.frame.origin.x > self.frame.size.width / 8;
        
        float cueAlpha = fabsf(self.frame.origin.x) / (self.frame.size.width / 8);
        _leftDragLabel.alpha = cueAlpha;
        _rightDragLabel.alpha = cueAlpha;
        
        // indicate when the item have been pulled far enough to invoke the given action
        _leftDragLabel.textColor = _leftDragRelease ?
        [UIColor redColor] : [UIColor whiteColor];
        _rightDragLabel.textColor = _rightDragRelease ?
        [UIColor greenColor] : [UIColor whiteColor];
        
    }
    
    // check flags
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // the frame this cell would have had before being dragged
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y,
                                          self.bounds.size.width, self.bounds.size.height);
        
        if (!_rightDragRelease) {
            // if the swipe action is not completed, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
        }
        if(_rightDragRelease) {
            [self.delegate handleRightSwipe:self];
            //handle state change
 
        }
        if(_leftDragRelease) {
            [self.delegate handleLeftSwipe:self];
            //handle state change
        }
    
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
//    _leftDragLabel.frame = CGRectMake(-UI_CUES_WIDTH - UI_CUES_MARGIN, 0,
//                                  UI_CUES_WIDTH, self.bounds.size.height);
//
//    _rightDragLabel.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0,
//                                   UI_CUES_WIDTH, self.bounds.size.height);
}

- (UILabel*) createCueLabel {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectNull];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:32.0];
    label.backgroundColor = [UIColor clearColor];
    return label;
}


@end
