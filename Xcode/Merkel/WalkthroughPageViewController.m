//
//  WalkthroughPageViewController.m
//  Merkel
//
//  Created by Wesley Leung on 5/28/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "WalkthroughPageViewController.h"

@interface WalkthroughPageViewController () 

@property (nonatomic) NSInteger pageNumber;


@end

@implementation WalkthroughPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadImage {
    
    NSString *pageName = [NSString stringWithFormat:@"walkthrough-page-%d", self.pageNumber];
    UIImage *image = [UIImage imageNamed:pageName];
    self.imageView.image = image;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadImage];
}

- (id)initWithPageNumber:(NSUInteger)page {
    self.pageNumber = page;
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
