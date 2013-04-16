//
//  ConferTableViewCell.h
//  Merkel
//
//  Created by Wesley Leung on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "ConferListItem.h"

@protocol ConferTableViewCellDelegate <NSObject>

// indicates that the given item has been deleted
- (void) cellItemDeleted:(ConferListItem*) cellItem;
@end

// A custom table cell that renders SHCToDoItem items.
@interface ConferTableViewCell : UITableViewCell


// The item that this cell renders
@property (nonatomic) ConferListItem *cellItem;

// The object that acts as delegate for this cell.
@property (nonatomic, assign) id<ConferTableViewCellDelegate> delegate;

@end
