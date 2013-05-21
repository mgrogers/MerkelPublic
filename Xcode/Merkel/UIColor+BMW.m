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

+ (instancetype)bmwYellowColor {
    static NSString * const kBMWYellowColor = @"#F1C40F";
    return [self colorFromHexString:kBMWYellowColor];
}

+ (instancetype)bmwDarkYellowColor {
    static NSString * const kbmwDarkYellowColor = @"#F39C12";
    return [self colorFromHexString:kbmwDarkYellowColor];
}

+ (instancetype)bmwRedColor {
    static NSString * const kBMWRedColor = @"#E74C3C";
    return [self colorFromHexString:kBMWRedColor];
}

+ (instancetype)bmwDarkRedColor {
    static NSString * const kBMWDarkRedColor = @"#C0392B";
    return [self colorFromHexString:kBMWDarkRedColor];
}

+ (instancetype)bmwGreenColor {
    static NSString * const kBMWGreenColor = @"#2ECC71";
    return [self colorFromHexString:kBMWGreenColor];
}

+ (instancetype)bmwDarkGreenColor {
    static NSString * const kBMWDarkGreenColor = @"#27AE60";
    return [self colorFromHexString:kBMWDarkGreenColor];
}

+ (instancetype)bmwLightBlueColor {
    static NSString * const kBMWLightBlueColor = @"#16A6D5";
    return [self colorFromHexString:kBMWLightBlueColor];
}

+ (instancetype)bmwDarkBlueColor {
    static NSString * const kBMWDarkBlueColor = @"#23303D";
    return [self colorFromHexString:kBMWDarkBlueColor];
}

+ (instancetype)bmwDarkGrayColor {
    static NSString * const kBMWDarkGrayColor = @"#343434";
    return [self colorFromHexString:kBMWDarkGrayColor];
}

+ (instancetype)bmwLightGrayColor {
    static NSString * const kBMWLightGrayColor = @"#B3B3B3";
    return [self colorFromHexString:kBMWLightGrayColor];
}

+ (instancetype)bmwDisabledGrayColor {
    static NSString * const kBMWDisabledGrayColor = @"#B3B0B1";
    return [self colorFromHexString:kBMWDisabledGrayColor];
}

@end
