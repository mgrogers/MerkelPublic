//
//  ConferListItem.m
//  Merkel
//
//  Created by Wesley Leung on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "ConferListItem.h"

@implementation ConferListItem

-(id)initWithText:(NSString*)text {
    if (self = [super init]) {
		self.text = text;
    }
    return self;
}

+(id)cellItemWithText:(NSString *)text {
    return [[ConferListItem alloc] initWithText:text];
}


@end
