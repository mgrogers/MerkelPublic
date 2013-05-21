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
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (strong, nonatomic) IBOutlet BMWTimeIndicatorView *timeIndicatorView;
@property (strong, nonatomic) UIBarButtonItem *speakerButton, *activeSpeakerButton;
@property (strong, nonatomic) MFMessageComposeViewController *messageComposeVC;

@end

@implementation BMWDayDetailViewController

static NSString * const kAlertMessageType = @"alert";
static NSString * const kInviteMessageType = @"invite";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
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

#pragma mark - Lazy Instantiation Getters

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

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 42.0, 41.0)];
    [backButton setImage:[UIImage imageNamed:@"back-arrow.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.view.backgroundColor = [UIColor bmwLightBlueColor];
    self.title = @"Event Detail";
    self.navigationItem.rightBarButtonItem = self.speakerButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self setupLabels];
    [self configureFlatButton:self.joinCallButton withColor:[UIColor bmwGreenColor]];
    [self configureFlatButton:self.lateButton withColor:[UIColor bmwRedColor]];
    [self createAndAddTimeIndicatorView];
    [self createAndAddLineSeparatorView];
    [self synchronizeUI];
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
    [self configureLabels];
    [self synchronizeUI];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EmbedAttendee"]) {
        BMWAttendeeTableViewController *attendeeTVC = segue.destinationViewController;
        [attendeeTVC setEventAttendees:self.event.attendees];
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

- (void)createAndAddTimeIndicatorView {
    self.timeIndicatorView = [[BMWTimeIndicatorView alloc] initWithFrame:CGRectMake(40.0, 60.0, 240.0, 30.0)];
    self.timeIndicatorView.borderColor = [UIColor clearColor];
    self.timeIndicatorView.trackColor = [UIColor whiteColor];
    self.timeIndicatorView.labelColor = [UIColor clearColor];
    self.timeIndicatorView.timeIndicatorColor = [UIColor bmwGreenColor];
    self.timeIndicatorView.labelFontColor = [UIColor bmwLightGrayColor];
    self.timeIndicatorView.startTime = self.event.startDate;
    self.timeIndicatorView.endTime = self.event.endDate;
    [self.view addSubview:self.timeIndicatorView];
    [self.timeIndicatorView startAnimating];
}

- (void)createAndAddLineSeparatorView {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 280, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lineView];
}

- (void)setupLabels {
    [self.eventTitleLabel setFont:[UIFont boldFontOfSize:24.0]];
    self.eventTitleLabel.adjustsFontSizeToFitWidth = YES;
    self.eventTitleLabel.adjustsLetterSpacingToFitWidth = YES;
    self.eventTitleLabel.minimumScaleFactor = 0.5;
}

#pragma mark - UI Updates

- (void)configureLabels {
    self.eventTitleLabel.text = self.eventTitle;
    self.conferencePhoneNumber.text = [NSString stringWithFormat:@"%@", self.phoneNumber];
    self.conferenceCodeLabel.text = [NSString stringWithFormat:@"%@", self.conferenceCode];
}

- (void)synchronizeUI {
    if ([BMWPhone sharedPhone].status == BMWPhoneStatusConnected) {
        if([BMWPhone sharedPhone].currentCallEvent) {
            if ([BMWPhone sharedPhone].currentCallEvent != self.event) {
                [self.joinCallButton setTitle:@"Join Call" forState:UIControlStateDisabled];
                self.joinCallButton.enabled = NO;
            }
        }
        [self.joinCallButton setTitle:@"End Call" forState:UIControlStateNormal];
        [self.joinCallButton setFaceColor:[UIColor bmwRedColor] forState:UIControlStateNormal];
        [self.joinCallButton setNeedsDisplay];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if ([BMWPhone sharedPhone].isSpeakerEnabled) {
            self.navigationItem.rightBarButtonItem = self.activeSpeakerButton;
        } else {
            self.navigationItem.rightBarButtonItem = self.speakerButton;
        }
        if ([BMWPhone sharedPhone].isMuted) {
            [self.lateButton setTitle:@"Unmute" forState:UIControlStateNormal];
        } else {
            [self.lateButton setTitle:@"Mute" forState:UIControlStateNormal];
        }
        self.lateButton.enabled = YES;
        
        
    } else {
        self.joinCallButton.enabled = YES;
        [self.joinCallButton setTitle:@"Join Call" forState:UIControlStateNormal];
        [self.joinCallButton setFaceColor:[UIColor bmwGreenColor] forState:UIControlStateNormal];
        [self.joinCallButton setNeedsDisplay];

        self.navigationItem.rightBarButtonItem = self.speakerButton;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.lateButton setTitle:@"I'm Late" forState:UIControlStateNormal];
        if (self.event.attendees.count < 1) {
            self.lateButton.enabled = NO;
        } else {
            self.lateButton.enabled = YES;
        }
    }
}

#pragma mark - Button Handlers

- (void)backButtonPressed {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)joinCallButtonPressed:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"End Call"]) {
        [BMWPhone sharedPhone].currentCallEvent = nil;
        [BMWPhone sharedPhone].currentCallCode = nil;
        [[BMWPhone sharedPhone] disconnect];
        [self synchronizeUI];
    } else {
        [self startCall];
    }
}

- (IBAction)lateButtonPressed:(id)sender {
    if ([BMWPhone sharedPhone].status == BMWPhoneStatusConnected) {
        BOOL currentMuteStatus = [BMWPhone sharedPhone].isMuted;
        [BMWPhone sharedPhone].muted = !currentMuteStatus;
        [self synchronizeUI];
    } else {
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
}

- (void)speakerButtonPressed:(id)sender {
    if (self.navigationItem.rightBarButtonItem == self.speakerButton) {
        // Speaker is inactive.
        [BMWPhone sharedPhone].speakerEnabled = YES;
        [BMWAnalytics mixpanelTrackSpeakerButtonClick:YES];
    } else {
        [BMWPhone sharedPhone].speakerEnabled = NO;
        [BMWAnalytics mixpanelTrackSpeakerButtonClick:NO];
    }
    [self synchronizeUI];
}

#pragma mark - Phone Actions

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
        [self synchronizeUI];
    });
}

- (void)connectionDidDisconnect:(TCConnection *)connection {
    dispatch_async(dispatch_get_main_queue(), ^{
        [BMWPhone sharedPhone].speakerEnabled = NO;
        [BMWPhone sharedPhone].muted = NO;
        [self synchronizeUI];
    });
}

- (void)connection:(TCConnection *)connection didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Connection failure: %@", error);
        [self.joinCallButton setTitle:@"Join Call" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = self.speakerButton;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [BMWPhone sharedPhone].speakerEnabled = NO;
        [BMWPhone sharedPhone].muted = NO;
        [self synchronizeUI];
    });
}

#pragma mark - MFMessageComposeViewControllerDelegate Methods

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:^{
        [self startCall];
    }];
}

@end
