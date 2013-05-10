//
//  BMWSlidingCell.m
//  Merkel
//
//  Created by Tim Shi on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWSlidingCell.h"


@interface BMWSlidingCell ()

@property (nonatomic, strong) UIView *bottomBar, *verticalBar;

@end

@implementation BMWSlidingCell {
    CGPoint _originalCenter;
    BOOL _rightDragRelease;
    BOOL _leftDragRelease;
    
    UILabel *_leftLabel;
    UILabel *_rightLabel;
    
}


const float UI_CUES_MARGIN = 10.0f;
const float UI_CUES_WIDTH = 100.0f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
        [self setupGestureRecognizers];
    }
    return self;
}

- (void)setupView {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont defaultFontOfSize:20.0];
    self.textLabel.textColor = [UIColor bmwDarkGrayColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.adjustsLetterSpacingToFitWidth = YES;
    self.textLabel.minimumScaleFactor = 0.5;
    self.startLabel = [self timeTextLabel];
    [self.contentView addSubview:self.startLabel];
    self.endLabel = [self timeTextLabel];
    [self.contentView addSubview:self.endLabel];
    self.bottomBar = [[UIView alloc] init];
    self.bottomBar.backgroundColor = [UIColor bmwLightGrayColor];
    [self.contentView addSubview:self.bottomBar];
    self.verticalBar = [[UIView alloc] init];
    self.verticalBar.backgroundColor = [UIColor bmwLightGrayColor];
    [self.contentView addSubview:self.verticalBar];
    [self setupCueLabels];
}

- (void)setupGestureRecognizers {
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    recognizer.delegate = self;
    [self addGestureRecognizer:recognizer];
}

- (UILabel *)timeTextLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor bmwDarkGrayColor];
    label.font = [UIFont defaultFontOfSize:14.0];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    const CGFloat kTextLabelOffset = 75.0;
    const CGFloat kBarHeight = 1.0;
    CGRect bounds = self.contentView.bounds;
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = kTextLabelOffset;
    textLabelFrame.origin.y += 3.0;
    textLabelFrame.size.width = CGRectGetWidth(bounds) - kTextLabelOffset;
    self.textLabel.frame = textLabelFrame;
    CGRect timeLabelFrame = CGRectMake(5.0, 10.0, kTextLabelOffset - 10.0, 15.0);
    self.startLabel.frame = timeLabelFrame;
    timeLabelFrame.origin.y += 15.0;
    self.endLabel.frame = timeLabelFrame;
    self.bottomBar.frame = CGRectMake(0.0, CGRectGetHeight(bounds) - kBarHeight, CGRectGetWidth(bounds), kBarHeight);
    self.verticalBar.frame = CGRectMake(kTextLabelOffset - 3.0, 0.0, 1.0, CGRectGetHeight(bounds));
    
    _leftLabel.frame = CGRectMake(-UI_CUES_WIDTH - UI_CUES_MARGIN, 0,
                                  UI_CUES_WIDTH, self.bounds.size.height);
    
    _rightLabel.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0,
                                   UI_CUES_WIDTH, self.bounds.size.height);
}


#pragma mark - horizontal pan gesture methods
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [gestureRecognizer translationInView:[self superview]];
        
        //checks for horizontal gestures
        if (fabsf(translation.x) > fabsf(translation.y)) {
            return YES;
        }
        return NO;
    } else return NO;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    //if the gesture has just started, record the current center location
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _originalCenter = self.center;
    }
    
    // apply offset to the cell. determine whether item is far enough to initiate a delete
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        _rightDragRelease = self.frame.origin.x < -self.frame.size.width / 4 ;
        _leftDragRelease = self.frame.origin.x > self.frame.size.width / 4;
        
        // fade the contextual cues
        float cueAlpha = fabsf(self.frame.origin.x) / (self.frame.size.width / 4);
        _leftLabel.alpha = cueAlpha;
        _rightLabel.alpha = cueAlpha;
        
        // indicate when the item have been pulled far enough to invoke the given action
        _leftLabel.textColor = _leftDragRelease ?
        [UIColor greenColor] : [UIColor whiteColor];
       
        _rightLabel.textColor = _rightDragRelease ?
         [UIColor redColor] : [UIColor whiteColor];
      
        
    }
    
    // check flags
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // the frame this cell would have had before being dragged
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y,
                                          self.bounds.size.width, self.bounds.size.height);
        
        if (!_rightDragRelease) {
            // if the item is not being deleted, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
        }
        if(!_leftDragRelease) {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];

        }
        if(_rightDragRelease) {
            [self.delegate handleRightSwipe:self];
            

        }
        if(_leftDragRelease) {
            [self.delegate handleLeftSwipe:self];

        }
        
    }
}

#pragma mark context cues
- (UILabel*) createCueLabel {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectNull];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:32.0];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (void)setupCueLabels {
    _leftLabel = [self createCueLabel];
    _leftLabel.text = @"Join";
    _leftLabel.font = [UIFont boldFontOfSize:20.0];
    _leftLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_leftLabel];
    
    _rightLabel = [self createCueLabel];
    _rightLabel.text = @"Late";
    _rightLabel.font = [UIFont boldFontOfSize:20.0];
    
    _rightLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_rightLabel];
}



@end
