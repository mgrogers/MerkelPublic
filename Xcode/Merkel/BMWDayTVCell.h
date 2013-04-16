//
//  ConferTableViewCell.h
//  Merkel
//
//  Created by Wesley Leung on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWDayListItem.h"
#import "BMWSlidingCellDelegate.h" 


// A custom table cell that renders cell items.
@interface ConferTableViewCell : UITableViewCell

// The item that this cell renders
@property (nonatomic) BMWDayListItem *cellItem;

// The object that acts as delegate for this cell.
@property (nonatomic, assign) id<BMWSlidingCellDelegate> delegate;

@end
