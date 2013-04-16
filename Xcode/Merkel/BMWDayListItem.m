//
//  ConferListItem.m
//  Merkel
//
//  Created by Wesley Leung on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWDayListItem.h"

@implementation BMWDayListItem

-(id)initWithText:(NSString*)text {
    if (self = [super init]) {
		self.text = text;
    }
    return self;
}

+(id)cellItemWithText:(NSString *)text {
    return [[BMWDayListItem alloc] initWithText:text];
}


@end
