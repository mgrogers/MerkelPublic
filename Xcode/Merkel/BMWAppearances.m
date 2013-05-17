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
    const CGFloat kTitleFontSize = 24.0;
    id appearance = [UINavigationBar appearance];
    [appearance setShadowImage:[[UIImage alloc] init]];
    [appearance setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [appearance setBackgroundColor:[UIColor bmwLightBlueColor]];
    [appearance setTitleTextAttributes:@{UITextAttributeFont: [UIFont boldFontOfSize:kTitleFontSize],
                                         UITextAttributeTextColor: [UIColor whiteColor],
                                         UITextAttributeTextShadowColor: [UIColor whiteColor],
                                         UITextAttributeTextShadowOffset: @0}];
}

@end
