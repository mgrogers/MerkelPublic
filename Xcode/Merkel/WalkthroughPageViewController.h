//
//  WalkthroughPageViewController.h
//  Merkel
//
//  Created by Wesley Leung on 5/28/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalkthroughPageViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *pageNumberLabel;

@property (nonatomic, strong) IBOutlet UILabel *numberTitle;

@property (nonatomic, strong) IBOutlet UIImageView *numberImage;

- (id)initWithPageNumber:(NSUInteger)page;

@end
