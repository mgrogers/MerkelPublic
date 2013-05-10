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

#import <MessageUI/MessageUI.h>

@interface BMWDayDetailViewController () <TCConnectionDelegate, MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *conferencePhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *conferenceCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;

@property (strong, nonatomic) MFMessageComposeViewController *messageComposeVC;

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.eventTitle;
    [self createLabels];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Speaker" style:UIBarButtonItemStyleBordered target:self action:@selector(speakerButtonPressed:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
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
                                        kTestSenderEmailAddress, @"initiator",nil];
            
            [[BMWAPIClient sharedClient] sendSMSMessageWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Alert success with response %@", responseObject);
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
    if (self.navigationItem.rightBarButtonItem.style == UIBarButtonItemStyleBordered) {
        // Speaker is inactive.
        [BMWPhone sharedPhone].isSpeakerEnabled = YES;
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
    } else {
        [BMWPhone sharedPhone].isSpeakerEnabled = NO;
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
    }
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
        [[BMWPhone sharedPhone] setIsSpeakerEnabled:YES];
        [self.joinCallButton setTitle:@"End Call" forState:UIControlStateNormal];
    });
    
}

- (void)connectionDidDisconnect:(TCConnection *)connection {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.joinCallButton setTitle:@"Join Call" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
        [BMWPhone sharedPhone].isSpeakerEnabled = NO;
    });
    
}

- (void)connection:(TCConnection *)connection didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Connection failure: %@", error);
        [self.joinCallButton setTitle:@"Join Call" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
        [BMWPhone sharedPhone].isSpeakerEnabled = NO;
    });
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:^{
        [self startCall];
    }];
}

@end
