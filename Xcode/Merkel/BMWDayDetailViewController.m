//
//  BMWDayDetailViewController.m
//  Merkel
//
//  Created by Wesley Leung on 4/20/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWDayDetailViewController.h"
#import "BMWPhone.h"
#import "BMWAttendeeTableViewController.h"

@interface BMWDayDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *conferencePhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *conferenceCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinCallButton;
@property (weak, nonatomic) IBOutlet UIButton *lateButton;


@end

@implementation BMWDayDetailViewController

static NSString * const kTestSenderEmailAddress = @"wes.k.leung@gmail.com";
static NSString * const kAlertMessageType = @"alert";
static NSString * const kInviteMessageType = @"invite";



- (void)setEKEvent: (EKEvent*)event {
    _event = event;
}

- (void)setPhoneNumber:(NSString *)phoneNumber
{
    _phoneNumber = phoneNumber;
}

- (void)setConferenceCode:(NSString *)conferenceCode
{
    _conferenceCode = conferenceCode;
}

-(void)setEventTitle:(NSString *)eventTitle {
    _eventTitle = eventTitle;
}

//- (BMWAttendeeTableViewController *)attendeeTable {
//    if (!_attendeeTable) {
//        _attendeeTable= [[BMWAttendeeTableViewController alloc] init];
//    }
//    return _attendeeTable;
//}

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
//    [self addChildViewController:self.attendeeTable];
//    [self.attendeeTable setEventAttendees:self.event.attendees];
//    [self.view addSubview:self.attendeeTable.tableView];
//    [self.attendeeTable didMoveToParentViewController:self];
}

-(void)createLabels {
    self.conferencePhoneNumber.text = [NSString stringWithFormat:@"%@", self.phoneNumber];
    self.conferenceCodeLabel.text = [NSString stringWithFormat:@"%@", self.conferenceCode];
    
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

- (IBAction)joinCallButtonPressed:(id)sender {
    static NSString * const kJoinCallURLString = @"tel:%@,,,%@#";
    NSString *callNumber = [NSString stringWithFormat:kJoinCallURLString, self.phoneNumber, self.conferenceCode];
    NSURL *callURL = [NSURL URLWithString:callNumber];
    [[UIApplication sharedApplication] openURL:callURL];
//    NSString *codetoCall = self.conferenceCodeLabel.text;
//    if(codetoCall) {
//        [[BMWPhone sharedPhone] callWithDelegate:self andConferenceCode:codetoCall];
//        [self.joinCallButton setTitle:@"Call in Progress" forState:UIControlStateNormal];
//    }
}

- (IBAction)lateButtonPressed:(id)sender {

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.event.title, @"title",
                                self.event.startDate, @"startTime",
                                self.phoneNumber, @"phoneNumber",
                                self.conferenceCode, @"conferenceCode",
                                self.event.attendees, @"attendees",
                                kAlertMessageType, @"messageType",
                                kTestSenderEmailAddress, @"initiator",nil];
    

    [[BMWAPIClient sharedClient] sendLateMessageWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Alert success with response %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error sending message", [error localizedDescription]);
    }];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EmbedAttendee"]) {
        BMWAttendeeTableViewController *attendeeTVC = segue.destinationViewController;
        [attendeeTVC setEventAttendees:self.event.attendees];
    }
}


@end
