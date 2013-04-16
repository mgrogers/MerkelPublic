//
//  UIColor+BMW.m
//  Merkel
//
//  Created by Tim Shi on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "UIColor+BMW.h"

@implementation UIColor (BMW)

+ (instancetype)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (instancetype)navBarTintColor {
    static NSString * const kBMWNavBarTintColor = @"#34495E";
    return [self colorFromHexString:kBMWNavBarTintColor];
}

@end
