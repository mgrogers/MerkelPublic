//
//  BMWWalkthroughViewController.m
//  Merkel
//
//  Created by Wesley Leung on 5/28/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWWalkthroughViewController.h"
#import "WalkthroughPageViewController.h"


@interface BMWWalkthroughViewController ()

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *viewControllers;

@end

@implementation BMWWalkthroughViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSInteger number_pages = self.pageControl.numberOfPages;
    
    NSMutableArray *pageControllers = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < number_pages; i++) {
        [pageControllers addObject:[NSNull null]];
    }
    self.viewControllers = pageControllers;
    
    //make sure page is width of scroll view
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * number_pages, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.pageControl.currentPage = 0;
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];    
    [self gotoPage:animated];
}


- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= self.pageControl.numberOfPages)
        return;
    
    // replace the placeholder if necessary
    WalkthroughPageViewController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {

        controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"WalkthroughImageVC"];
        controller.pageNumber = page;
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        NSString *pageName = [NSString stringWithFormat:@"walkthrough-page-%d.png", page];
        controller.imageView.image = [UIImage imageNamed: pageName];
        controller.pageNumberLabel.text = [NSString stringWithFormat:@"%d",page];
        
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
    }
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:animated];
}


- (IBAction)changePage:(id)sender {
    [self gotoPage:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
