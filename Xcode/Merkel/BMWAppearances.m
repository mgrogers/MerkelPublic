//
//  BMWAppearances.m
//  Merkel
//
//  Created by Tim Shi on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWAppearances.h"

@implementation BMWAppearances

+ (void)setupAppearance {
    [self setupNavAppearance];
}

+ (void)setupNavAppearance {
    id appearance = [UINavigationBar appearance];
    [appearance setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [appearance setBackgroundColor:[UIColor navBarTintColor]];
    [appearance setTitleTextAttributes:@{UITextAttributeFont: [UIFont boldFontOfSize:30.0],
                                         UITextAttributeTextColor: [UIColor whiteColor]}];
}

@end
