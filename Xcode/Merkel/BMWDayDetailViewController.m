//
//  BMWDayDetailViewController.m
//  Merkel
//
//  Created by Wesley Leung on 4/20/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWDayDetailViewController.h"




@interface BMWDayDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *conferencePhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *conferenceCodes;
@property (weak, nonatomic) IBOutlet UIButton *masterCallButton;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;


@property (nonatomic, strong) BMWDayTableViewController *attendeeTable;

@end

@implementation BMWDayDetailViewController

- (void)setEKEvent: (EKEvent*)event {
    _event = event;
}

- (void)setPhoneNumber:(NSNumber*)phoneNumber
{
    _phoneNumber = phoneNumber;
}

-(void)setEventTitle:(NSString *)eventTitle {
    _eventTitle = eventTitle;
}

- (BMWDayTableViewController *)attendeeTable {
    if (!_attendeeTable) {
        _attendeeTable= [[BMWDayTableViewController alloc] init];
    }
    return _attendeeTable;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self sharedInitializer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self sharedInitializer];
    }
    return self;
}

- (void)sharedInitializer {
    [[UILabel appearanceWhenContainedIn:[self class], nil] setFont:[UIFont defaultFontOfSize:18.0]];
}

-(void)createVisualAssets {
 
    
    [self addChildViewController:self.attendeeTable];
    
    //create frame
    [self.view addSubview:self.attendeeTable.tableView];
    [self.attendeeTable didMoveToParentViewController:self];
}

-(void)createLabels {
    self.conferencePhoneNumber.text =[NSString stringWithFormat:@"%@", self.phoneNumber];
    
    if(self.event.allDay) {
        self.eventDateLabel.text = @"All Day";
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat=@"EEEE, MMMM dd";
        NSString * monthString = [[dateFormatter stringFromDate:self.event.startDate] capitalizedString];
        self.eventDateLabel.text = monthString;
        self.eventDateLabel.numberOfLines = 0;
        self.eventTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        self.eventTimeLabel.text = [dateFormatter stringFromDate:self.event.startDate];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.eventTitle;
    [self createLabels];
    
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
