//
//  BMWSlidingCell.h
//  Merkel
//
//  Created by Tim Shi on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMWSlidingCellDelegate.h"

@interface BMWSlidingCell : UITableViewCell

@property (nonatomic, strong) UILabel *startLabel, *endLabel;
@property (nonatomic, assign) id<BMWSlidingCellDelegate> delegate;

@end
