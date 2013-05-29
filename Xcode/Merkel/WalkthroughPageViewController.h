//
//  WalkthroughPageViewController.h
//  Merkel
//
//  Created by Wesley Leung on 5/28/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalkthroughPageViewController : UIViewController

@property (nonatomic, strong) UIImageView *image;

- (id)initWithPageNumber:(NSUInteger)page;

@end
