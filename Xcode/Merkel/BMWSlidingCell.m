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

@implementation BMWSlidingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
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
    self.bottomBar = [[UIView alloc] init];
    self.bottomBar.backgroundColor = [UIColor bmwLightGrayColor];
    [self.contentView addSubview:self.bottomBar];
    self.verticalBar = [[UIView alloc] init];
    self.verticalBar.backgroundColor = [UIColor bmwLightGrayColor];
    [self.contentView addSubview:self.verticalBar];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    self.bottomBar.frame = CGRectMake(0.0, CGRectGetHeight(bounds) - kBarHeight, CGRectGetWidth(bounds), kBarHeight);
    self.verticalBar.frame = CGRectMake(kTextLabelOffset - 3.0, 0.0, 1.0, CGRectGetHeight(bounds));
}

@end
