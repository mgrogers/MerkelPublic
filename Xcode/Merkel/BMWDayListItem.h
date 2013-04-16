//
//  ConferListItem.h
//  Merkel
//
//  Created by Wesley Leung on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BMWDayListItem : NSObject

// A text description of this item.
@property (nonatomic, copy) NSString *text;

// A boolean value that determines the completed state of this item.
@property (nonatomic) BOOL completed;

// Returns a cell tem initialised with the given text.
-(id)initWithText:(NSString*)text;

// Returns a cell tem initialised with the given text.
+(id)cellItemWithText:(NSString*)text;

@end
