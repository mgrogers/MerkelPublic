//
//  BMWSlidingCell.m
//  Merkel
//
//  Created by Tim Shi on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWSlidingCell.h"

@interface BMWSlidingCell ()

@property (nonatomic, strong) UIView *bottomBar;

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
    self.bottomBar = [[UIView alloc] init];
    self.bottomBar.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.bottomBar];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    const CGFloat kBarHeight = 2.0;
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    self.bottomBar.frame = CGRectMake(0.0, CGRectGetHeight(bounds) - kBarHeight, CGRectGetWidth(bounds), kBarHeight);
}

@end
