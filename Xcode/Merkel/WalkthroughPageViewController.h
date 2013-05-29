//
//  WalkthroughPageViewController.h
//  Merkel
//
//  Created by Wesley Leung on 5/28/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalkthroughPageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) NSInteger pageNumber;



@end
