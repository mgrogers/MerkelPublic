//
//  BMWDayDetailViewController.m
//  Merkel
//
//  Created by Wesley Leung on 4/20/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWDayDetailViewController.h"

#import "BMWAPIClient.h"
#import "BMWAttendeeTableViewController.h"
#import "BMWDayTableViewController.h"
#import "BMWPhone.h"
#import "TCConnectionDelegate.h"
#import "BMWTimeIndicatorView.h"

#import <MessageUI/MessageUI.h>

@interface BMWDayDetailViewController () <TCConnectionDelegate, MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *conferencePhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *conferenceCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timer;
@property (strong, nonatomic) IBOutlet BMWTimeIndicatorView *timeIndicatorView;
@property (strong, nonatomic) UIBarButtonItem *speakerButton, *activeSpeakerButton;
@property (strong, nonatomic) MFMessageComposeViewController *messageComposeVC;

@end

@implementation BMWDayDetailViewController

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

- (UIBarButtonItem *)speakerButton {
    if (!_speakerButton) {
        _speakerButton = [[UIBarButtonItem alloc] initWithCustomView:[self speakerButtonWithImageName:@"speaker.png"]];
    }
    return _speakerButton;
}

- (UIBarButtonItem *)activeSpeakerButton {
    if (!_activeSpeakerButton) {
        _activeSpeakerButton = [[UIBarButtonItem alloc] initWithCustomView:[self speakerButtonWithImageName:@"speaker-active.png"]];
    }
    return _activeSpeakerButton;
}

- (UIButton *)speakerButtonWithImageName:(NSString *)imageName {
    static const CGRect kSpeakerButtonFrame = {{0.0, 0.0}, {50.0, 25.0}};
    UIButton *button = [[UIButton alloc] initWithFrame:kSpeakerButtonFrame];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(speakerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return button;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 42.0, 41.0)];
    [button setImage:[UIImage imageNamed:@"back-arrow.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.view.backgroundColor = [UIColor bmwLightBlueColor];
    self.title = @"Event Detail";
    self.eventTitleLabel.text = self.eventTitle;
    [self.eventTitleLabel setFont:[UIFont boldFontOfSize:24.0]];
    
    self.eventTitleLabel.adjustsFontSizeToFitWidth = YES;
    self.eventTitleLabel.adjustsLetterSpacingToFitWidth = YES;
    self.eventTitleLabel.minimumScaleFactor = 0.5;

    [self createLabels];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Speaker" style:UIBarButtonItemStyleBordered target:self action:@selector(speakerButtonPressed:)];
    self.navigationItem.rightBarButtonItem = self.speakerButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self configureFlatButton:self.joinCallButton withColor:[UIColor redColor]];
    [self configureFlatButton:self.lateButton withColor:[UIColor redColor]];


    [self loadTimeIndicatorView];
    [self loadLineSeparatorView];
}

- (void)backButtonPressed {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loadLineSeparatorView {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 280, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lineView];
}

- (void)loadTimeIndicatorView {    
    self.timeIndicatorView = [[BMWTimeIndicatorView alloc] initWithFrame:CGRectMake(40.0, 60.0, 240.0, 30.0)];
    self.timeIndicatorView.borderColor = [UIColor clearColor];
    self.timeIndicatorView.trackColor = [UIColor whiteColor];
    self.timeIndicatorView.labelColor = [UIColor clearColor];
    self.timeIndicatorView.labelFontColor = [UIColor bmwLightGrayColor];
    self.timeIndicatorView.startTime = self.event.startDate;
    self.timeIndicatorView.endTime = self.event.endDate;
    [self.view addSubview:self.timeIndicatorView];
    [self.timeIndicatorView startAnimating];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [BMWPhone sharedPhone].connectionDelegate = self;
    if ([BMWPhone sharedPhone].status == BMWPhoneStatusConnected) {
        [self.joinCallButton setTitle:@"End Call" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if ([BMWPhone sharedPhone].isSpeakerEnabled) {
            self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
        }
    } else if ([BMWPhone sharedPhone].status == BMWPhoneStatusReady) {
        [self.joinCallButton setTitle:@"Join Call" forState:UIControlStateNormal];
    }
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

-(void)createLabels {
    self.conferencePhoneNumber.text = [NSString stringWithFormat:@"%@", self.phoneNumber];
    self.conferenceCodeLabel.text = [NSString stringWithFormat:@"%@", self.conferenceCode];
    
    if(self.event.allDay) {
        self.eventDateLabel.text = @"All Day";
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat=@"EEEE, MMMM dd \n HH:mm";
        NSString * monthString = [[dateFormatter stringFromDate:self.event.startDate] capitalizedString];
        self.eventDateLabel.text = monthString;
        self.eventDateLabel.numberOfLines = 0;
        self.eventDateLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//        self.eventTimeLabel.text = [dateFormatter stringFromDate:self.event.startDate];
    }
}

- (IBAction)joinCallButtonPressed:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"End Call"]) {
        [[BMWPhone sharedPhone] disconnect];
        [BMWPhone sharedPhone].currentCallEvent = nil;
        [BMWPhone sharedPhone].currentCallCode = nil;
    } else {
        [self startCall];
    }
}

- (void)startCall {
    NSString *codetoCall = self.conferenceCodeLabel.text;
    if(codetoCall) {
        [self.joinCallButton setTitle:@"Joining" forState:UIControlStateNormal];
        [[BMWPhone sharedPhone] callWithDelegate:self andConferenceCode:codetoCall];
        [BMWPhone sharedPhone].currentCallEvent = self.event;
        [BMWPhone sharedPhone].currentCallCode = self.conferenceCode;
    }
}

- (void)sendInviteMessageAnimated:(BOOL)animated {
    static NSString * const kInviteMessage = @"Hi, please join me in a conference call through CallinApp.";
    NSString *body = [kInviteMessage stringByAppendingFormat:@" %@,,,%@#", self.phoneNumber, self.conferenceCode];
    self.messageComposeVC = [[MFMessageComposeViewController alloc] init];
    self.messageComposeVC.body = body;
    self.messageComposeVC.messageComposeDelegate = self;
    [self presentViewController:self.messageComposeVC animated:animated completion:^{
        
    }];
}

- (IBAction)lateButtonPressed:(id)sender {
    [[BMWCalendarAccess sharedAccess] attendeesForEvent:self.event withCompletion:^(NSArray *attendees) {
        for (int i = 0; i < [attendees count]; i++) {
            NSString *attendeePhone = [attendees[i] objectForKey:@"phone"] ? [attendees[i] objectForKey:@"phone"] : @"";
            NSString *attendeeEmail = [attendees[i] objectForKey:@"email"] ? [attendees[i] objectForKey:@"email"] : @"";
            
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        self.event.title, @"title",
                                        self.event.startDate, @"startTime",
                                        self.phoneNumber, @"phoneNumber",
                                        self.conferenceCode, @"conferenceCode",
                                        attendeePhone, @"toPhoneNumber",
                                        attendeeEmail, @"toEmail",
                                        kAlertMessageType, @"messageType",
                                        [PFUser currentUser].email, @"initiator",nil];
            
            [[BMWAPIClient sharedClient] sendSMSMessageWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Alert success with response %@", responseObject);
                self.lateButton.enabled = NO;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error sending sms message. Attempting email. %@", [error localizedDescription]);
                [[BMWAPIClient sharedClient] sendEmailMessageWithParameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"Alert success with response %@", responseObject);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error sending message %@", [error localizedDescription]);
                }];
            }];
        }
    }];
}

- (void)speakerButtonPressed:(id)sender {
    if (self.navigationItem.rightBarButtonItem == self.speakerButton) {
        // Speaker is inactive.
        [BMWPhone sharedPhone].speakerEnabled = YES;
        self.navigationItem.rightBarButtonItem = self.activeSpeakerButton;
        [BMWAnalytics mixpanelTrackSpeakerButtonClick:YES];
    } else {
        [BMWPhone sharedPhone].speakerEnabled = NO;
        self.navigationItem.rightBarButtonItem = self.speakerButton;
        [BMWAnalytics mixpanelTrackSpeakerButtonClick:NO];
    }
}

#pragma mark - View Setup

- (void)configureFlatButton:(QBFlatButton *)button withColor:(UIColor*)color {
    button.faceColor = color;
    [button setFaceColor:color forState:UIControlStateNormal];
    [button setFaceColor:[UIColor bmwDisabledGrayColor] forState:UIControlStateDisabled];
    button.margin = 0.0;
    button.radius = 5.0;
    button.depth = 2.0;
}

#pragma mark - TCConectionDelegate Methods

- (void)connectionDidStartConnecting:(TCConnection *)connection {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.joinCallButton setTitle:@"Connecting" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    });
}

- (void)connectionDidConnect:(TCConnection *)connection {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[BMWPhone sharedPhone] setSpeakerEnabled:YES];
        self.navigationItem.rightBarButtonItem = self.activeSpeakerButton;
        [self.joinCallButton setTitle:@"End Call" forState:UIControlStateNormal];
    });
    
}

- (void)connectionDidDisconnect:(TCConnection *)connection {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.joinCallButton setTitle:@"Join Call" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = self.speakerButton;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [BMWPhone sharedPhone].speakerEnabled = NO;
    });
    
}

- (void)connection:(TCConnection *)connection didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Connection failure: %@", error);
        [self.joinCallButton setTitle:@"Join Call" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = self.speakerButton;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [BMWPhone sharedPhone].speakerEnabled = NO;
    });
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:^{
        [self startCall];
    }];
}

@end
