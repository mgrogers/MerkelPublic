//
//  UIFont+BMW.m
//  Merkel
//
//  Created by Tim Shi on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "UIFont+BMW.h"

@implementation UIFont (BMW)

+ (instancetype)defaultFontOfSize:(CGFloat)fontSize {
    static NSString * const kBMWDefaultFont = @"Gotham-Book";
    return [UIFont fontWithName:kBMWDefaultFont size:fontSize];
}

+ (instancetype)boldFontOfSize:(CGFloat)fontSize {
    static NSString * const kBMWBoldFont = @"Gotham-Bold";
    return [UIFont fontWithName:kBMWBoldFont size:fontSize];
}

@end
