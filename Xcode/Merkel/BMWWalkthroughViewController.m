//
//  BMWWalkthroughViewController.m
//  Merkel
//
//  Created by Tim Shi on 5/29/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWWalkthroughViewController.h"

@interface BMWWalkthroughViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *imageNames, *imageViews;

@end

@implementation BMWWalkthroughViewController

- (NSArray *)imageNames {
    if (!_imageNames) {
        _imageNames = @[@"walkthrough-1.png",
                        @"walkthrough-2.png",
                        @"walkthrough-3.png"];
    }
    return _imageNames;
}

- (NSArray *)imageViews {
    if (!_imageViews) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSString *imageName in self.imageNames) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            [tempArr addObject:imageView];
        }
        _imageViews = [NSArray arrayWithArray:tempArr];
    }
    return _imageViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.scrollView];
    for (UIImageView *imageView in self.imageViews) {
        [self.scrollView addSubview:imageView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scrollView.frame = self.view.frame;
    NSInteger count = 0;
    for (UIImageView *imageView in self.imageViews) {
        CGRect ivFrame = self.scrollView.bounds;
        ivFrame.origin.x = CGRectGetWidth(ivFrame) * count;
        imageView.frame = ivFrame;
        count++;
    }
    self.scrollView.contentSize = CGSizeMake((count + 1) * CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
}

@end
