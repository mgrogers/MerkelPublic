//
//  ConferTableViewCell.m
//  Merkel
//
//  Created by Wesley Leung on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWDayTVCell.h"

@implementation ConferTableViewCell {
    CGPoint _originalCenter;
    BOOL _deleteOnDragRelease;
    BOOL _markCompleteOnDragRelease;
    
    UILabel *_tickLabel;
    UILabel *_crossLabel;
    
}


const float UI_CUES_MARGIN = 10.0f;
const float UI_CUES_WIDTH = 50.0f;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        // add a tick and cross
        _tickLabel = [self createCueLabel];
        _tickLabel.text = @"L";
        _tickLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_tickLabel];
        _crossLabel = [self createCueLabel];
        _crossLabel.text = @"J";
        _crossLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_crossLabel];
        
        
        
        UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
		recognizer.delegate = self;
		[self addGestureRecognizer:recognizer];
    }
    return self;
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
    
    // apply offset to the cell. determine whether item is far enough to initiate a delete
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        _deleteOnDragRelease = self.frame.origin.x < -self.frame.size.width / 4;
        _markCompleteOnDragRelease = self.frame.origin.x > self.frame.size.width / 4;
        
        // fade the contextual cues
        float cueAlpha = fabsf(self.frame.origin.x) / (self.frame.size.width / 4);
        _tickLabel.alpha = cueAlpha;
        _crossLabel.alpha = cueAlpha;
        
        // indicate when the item have been pulled far enough to invoke the given action
        _tickLabel.textColor = _markCompleteOnDragRelease ?
        [UIColor redColor] : [UIColor whiteColor];
        _crossLabel.textColor = _deleteOnDragRelease ?
        [UIColor greenColor] : [UIColor whiteColor];
        
    }
    
    // check flags
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // the frame this cell would have had before being dragged
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y,
                                          self.bounds.size.width, self.bounds.size.height);
        
        if (!_deleteOnDragRelease) {
            // if the item is not being deleted, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
        }
        if(_deleteOnDragRelease) {
            //change the stats
            [self.delegate cellItemDeleted:self.cellItem];
        }
        if(_markCompleteOnDragRelease) {
            self.cellItem.completed = YES;
            //change the state.
        }
    
    }
}

const float LABEL_LEFT_MARGIN = 15.0f;

-(void)layoutSubviews {
    [super layoutSubviews];

    
    _tickLabel.frame = CGRectMake(-UI_CUES_WIDTH - UI_CUES_MARGIN, 0,
                                  UI_CUES_WIDTH, self.bounds.size.height);
    _crossLabel.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0,
                                   UI_CUES_WIDTH, self.bounds.size.height);
}


-(UILabel*) createCueLabel {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectNull];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:32.0];
    label.backgroundColor = [UIColor clearColor];
    return label;
}


@end
