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

@property (weak, nonatomic) IBOutlet UILabel *conferencePhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *conferenceCodes;
@property (weak, nonatomic) IBOutlet UIButton *masterCallButton;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;


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

-(void)setEventDate:(NSDate *)eventDate {
    _eventDate = eventDate;
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



    self.view.backgroundColor = [UIColor whiteColor];

    
    self.title = self.eventTitle;
    
    self.conferencePhoneNumber.text =[NSString stringWithFormat:@"%@", self.phoneNumber];
    

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"EEEE, MMMM dd";
    NSString * monthString = [[dateFormatter stringFromDate:self.eventDate] capitalizedString];
    self.eventDateLabel.text = monthString;
    
    self.eventDateLabel.numberOfLines = 0;
    
    self.eventTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;

    
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.eventTimeLabel.text = [dateFormatter stringFromDate:self.eventDate];
    
    
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
