//
//  BMWDayDetailViewController.m
//  Merkel
//
//  Created by Wesley Leung on 4/20/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWDayDetailViewController.h"
#import "BMWDayTableViewController.h"

@interface BMWDayDetailViewController ()

@property (nonatomic, strong) BMWDayTableViewController *attendeeStream;

@end

@implementation BMWDayDetailViewController

- (void)setPhoneNumber:(NSNumber*)phoneNumber
{
    _phoneNumber = phoneNumber;
    //custom setter here
}

-(void)setEventTitle:(NSString *)eventTitle {
    _eventTitle = eventTitle;
    //customer setter here
}

- (BMWDayTableViewController *)attendeeStream {
    if (!_attendeeStream) {
        _attendeeStream = [[BMWDayTableViewController alloc] init];

    }
    return _attendeeStream;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)createVisualAssets {
    [self addChildViewController:self.attendeeStream];
    
    //check this.
    [self.view addSubview:self.attendeeStream.view];
    [self.attendeeStream didMoveToParentViewController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];



    self.view.backgroundColor = [UIColor blackColor];

    
    self.title = self.eventTitle;


//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0.0, 0.0, 25.0, 19.0);
//    button.backgroundColor = [UIColor clearColor];
//    [button setBackgroundImage:[UIImage imageNamed:@"reveal_menu_icon_portrait.png"] forState:UIControlStateNormal];
//    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    spacer.width = 10.0;
//    self.navigationItem.leftBarButtonItems = @[spacer, menuBarButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
