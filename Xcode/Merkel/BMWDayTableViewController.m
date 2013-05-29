//
//  BMWDayTableViewController.m
//  Merkel
//
//  Created by Tim Shi on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWDayTableViewController.h"

#import "BMWAPIClient.h"
#import "BMWLoginViewController.h"
#import "BMWDayDetailViewController.h"
#import "BMWPhone.h"
#import "BMWSlidingCell.h"
#import "BMWSlidingCellDelegate.h"
#import "TCConnectionDelegate.h"
#import "BMWAddressBookViewController.h"
#import "UIActionSheet+MKBlockAdditions.h"

@interface BMWDayTableViewController () <TCConnectionDelegate, ABPeoplePickerNavigationControllerDelegate, BMWSlidingCellDelegate, BMWLoginDelegate>

@property (nonatomic, strong) NSArray *calendarEvents;
@property (nonatomic, strong) NSArray *selectedPeople;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, strong) BMWLoginViewController *loginVC;
@property (nonatomic, strong) QBFlatButton *callStatusButton;

@end

@implementation BMWDayTableViewController

static NSString * const kBMWSlidingCellIdentifier = @"BMWSlidingCell";
static NSString * const kAlertMessageType = @"alert";
static NSString * const kInviteMessageType = @"invite";
static const NSInteger kTableCellRowHeight = 88;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

#pragma mark - Lazy Instantiation Methods

- (QBFlatButton *)callStatusButton {
    if (!_callStatusButton) {
        _callStatusButton = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        _callStatusButton.frame = CGRectMake(0.0, 0.0, 70.0, 30.0);
        _callStatusButton.faceColor = [UIColor bmwGreenColor];
        _callStatusButton.sideColor = [UIColor bmwGreenColor];
        _callStatusButton.margin = 0.0;
        _callStatusButton.radius = 2.0;
        _callStatusButton.depth = 2.0;
        _callStatusButton.titleLabel.font = [UIFont boldFontOfSize:12.0];
        [_callStatusButton setTitle:@"Quick Call" forState:UIControlStateNormal];
    }
    return _callStatusButton;
}

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Today";
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[BMWSlidingCell class] forCellReuseIdentifier:kBMWSlidingCellIdentifier];
    self.view.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, 25.0, 19.0);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"reveal_menu_icon_portrait.png"] forState:UIControlStateNormal];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 10.0;
    self.navigationItem.leftBarButtonItems = @[spacer, menuBarButton];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceStatusChanged:) name:BMWPhoneDeviceStatusDidChangeNotification object:nil];
    [self updateTableViewCalendarEvents];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventStoreChanged:)
                                                 name:EKEventStoreChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleIncomingCallNotification)
                                                 name:BMWPhoneDidReceiveIncomingConnectionNotification
                                               object:nil];
    self.phoneNumber = [BMWPhone sharedPhone].phoneNumber;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![PFUser currentUser]) {
        [self presentLoginViewAnimated:NO];
    } else {
        [BMWAnalytics mixpanelTrackUser:[PFUser currentUser].username];
    }
    [self synchronizePhoneStatusUI];
}

- (void)presentLoginViewAnimated:(BOOL)animated {
    self.loginVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVC"];
    self.loginVC.loginDelegate = self;
    [self presentViewController:self.loginVC animated:animated completion:NULL];
}

- (void)loginVCDidLogin:(BMWLoginViewController *)loginVC {
    [self dismissViewControllerAnimated:YES completion:^{
        self.loginVC = nil;
        [self.tableView reloadData];
        [BMWAnalytics mixpanelTrackLoggedInUser:[PFUser currentUser].username];
    }];
}

- (void)deviceStatusChanged:(NSNotification *)notification {
    [self synchronizePhoneStatusUI];
}

- (void)synchronizePhoneStatusUI {
    if ([BMWPhone sharedPhone].status == BMWPhoneStatusReady) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Quick Call" style:UIBarButtonItemStyleBordered target:self action:@selector(callButtonPressed)];
        [self.callStatusButton setTitle:@"Quick Call" forState:UIControlStateNormal];
        [self.callStatusButton removeTarget:self action:@selector(currentCallButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.callStatusButton addTarget:self action:@selector(callButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.callStatusButton];
    } else if ([BMWPhone sharedPhone].status == BMWPhoneStatusConnected) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Current Call" style:UIBarButtonItemStyleDone target:self action:@selector(currentCallButtonPressed)];
        [self.callStatusButton setTitle:@"In Call" forState:UIControlStateNormal];
        [self.callStatusButton removeTarget:self action:@selector(callButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.callStatusButton addTarget:self action:@selector(currentCallButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    } else if ([BMWPhone sharedPhone].status == BMWPhoneStatusNotReady) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    }
}

- (void)menuButtonPressed {
    PKRevealController *revealController = (PKRevealController *)self.navigationController.revealController;
    [revealController showViewController:revealController.leftViewController];
}

- (void)callButtonPressed {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    __weak UIActivityIndicatorView *wkSpinner = spinner;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    [[BMWCalendarAccess sharedAccess] createQuickEventWithCompletion:^(EKEvent *event, NSString *conferenceCode) {
        [wkSpinner stopAnimating];
        BMWDayDetailViewController *dayDetailVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"DayDetailVC"];
        dayDetailVC.event = event;
        dayDetailVC.eventTitle = event.title;
        dayDetailVC.conferenceCode = conferenceCode;
        dayDetailVC.phoneNumber = self.phoneNumber;
        [self.navigationController pushViewController:dayDetailVC animated:YES];
        [dayDetailVC sendInviteMessageAnimated:NO];
    }];
}

- (void)currentCallButtonPressed {
    EKEvent *event = [BMWPhone sharedPhone].currentCallEvent;
    NSString *conferenceCode = [BMWPhone sharedPhone].currentCallCode;
    if (event && conferenceCode) {
        BMWDayDetailViewController *dayDetailVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"DayDetailVC"];
        dayDetailVC.event = event;
        dayDetailVC.eventTitle = event.title;
        dayDetailVC.conferenceCode = conferenceCode;
        dayDetailVC.phoneNumber = self.phoneNumber;
        [self.navigationController pushViewController:dayDetailVC animated:YES];
    }
}

- (void)endCallButtonPressed {
    [[BMWPhone sharedPhone] disconnect];
}

- (void)joinIncomingCallButtonPressed {
    [[BMWCalendarAccess sharedAccess] createIncomingCallEventWithCompletion:^(EKEvent *event) {
        BMWDayDetailViewController *dayDetailVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"DayDetailVC"];
        dayDetailVC.event = event;
        dayDetailVC.eventTitle = event.title;
        dayDetailVC.conferenceCode = @"";
        dayDetailVC.phoneNumber = self.phoneNumber;
        [self.navigationController pushViewController:dayDetailVC animated:YES];
    }];
}

- (void)handleIncomingCallNotification {
    [UIActionSheet actionSheetWithTitle:@"Incoming Call"
                                message:@"You have an incoming call."
                                buttons:@[@"Accept"]
                             showInView:self.tableView
                              onDismiss:^(int buttonIndex) {
                                  [[BMWPhone sharedPhone] acceptIncomingConnection];
                                  [self joinIncomingCallButtonPressed];
                              }
                               onCancel:^{
                                   [[BMWPhone sharedPhone] ignoreIncomingConnection];
                               }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.calendarEvents.count;
}

- (NSString *)timeStringForDate:(NSDate *)date {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
    }
    return [formatter stringFromDate:date];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMWSlidingCell *cell = [tableView dequeueReusableCellWithIdentifier:kBMWSlidingCellIdentifier forIndexPath:indexPath];

    EKEvent *event = [self eventForIndexPath:indexPath];
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.textLabel.text = event.title;
    if (event.allDay) {
        cell.startLabel.text = @"All";
        cell.endLabel.text = @"Day";
    } else {
        cell.startLabel.text = [self timeStringForDate:event.startDate];
        cell.endLabel.text = [self timeStringForDate:event.endDate];
    }
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BMWSlidingCell *cell = (BMWSlidingCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"Show Detail" sender:cell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableCellRowHeight;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"Show Detail"]) {
            EKEvent *event = [self eventForIndexPath:indexPath];
            NSString *eventTitle = event.title;
            NSString *conferenceCode = [self eventConferenceCodeForIndexPath:indexPath];
            NSString *phoneNumber = self.phoneNumber;

            if ([segue.destinationViewController respondsToSelector:@selector(setEventTitle:)]) {
                [segue.destinationViewController performSelector:@selector(setEventTitle:) withObject:eventTitle];
                [segue.destinationViewController performSelector:@selector(setPhoneNumber:) withObject:phoneNumber];
                [segue.destinationViewController performSelector:@selector(setConferenceCode:) withObject:conferenceCode];
                [segue.destinationViewController performSelector:@selector(setEvent:) withObject:event];
            }
        }
    }
}

#pragma mark - Calendar Events Handling

- (void)updateTableViewCalendarEvents {
    [[BMWCalendarAccess sharedAccess] getTodaysEventsCompletion:^(NSArray *events, NSError *error) {
        self.calendarEvents = events;
        [self.tableView reloadData];
    }];
}

- (EKEvent *)eventForIndexPath:(NSIndexPath *)indexPath {
    return self.calendarEvents[indexPath.row][@"event"];
}

- (NSString *)eventConferenceCodeForIndexPath:(NSIndexPath *)indexPath {
    return self.calendarEvents[indexPath.row][@"conferenceCode"];
}

- (void)eventStoreChanged:(NSNotification *)notification {
    [self updateTableViewCalendarEvents];
}

#pragma mark - BMWSlidingCellDelegate protocol methods

/* Start a conference call */
- (void)handleLeftSwipe:(id)cellItem {
    NSInteger index = ((BMWSlidingCell *)cellItem).index;
    [self.tableView beginUpdates];
    BMWDayDetailViewController *dayDetailVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"DayDetailVC"];
    EKEvent *event = self.calendarEvents[index][@"event"];
    dayDetailVC.event = event;
    dayDetailVC.eventTitle = event.title;
    dayDetailVC.conferenceCode = self.calendarEvents[index][@"conferenceCode"];
    dayDetailVC.phoneNumber = self.phoneNumber;
    [self.navigationController pushViewController:dayDetailVC animated:YES];
    [dayDetailVC.joinCallButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self.tableView endUpdates];
}

/* Send a late text message and email */
- (void)handleRightSwipe:(id)cellItem {
    NSInteger index = ((BMWSlidingCell *)cellItem).index;
    [self.tableView beginUpdates];
    BMWDayDetailViewController *dayDetailVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"DayDetailVC"];
    EKEvent *event = self.calendarEvents[index][@"event"];
    dayDetailVC.event = event;
    dayDetailVC.eventTitle = event.title;
    dayDetailVC.conferenceCode = self.calendarEvents[index][@"conferenceCode"];
    dayDetailVC.phoneNumber = self.phoneNumber;
    [dayDetailVC lateButtonPressed:dayDetailVC.lateButton];
    [self.tableView endUpdates];
}

#pragma mark - TCConnectionDelegate Methods

- (void)connection:(TCConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"failed");
}

- (void)connectionDidConnect:(TCConnection *)connection {
    NSLog(@"connected");
}

- (void)connectionDidDisconnect:(TCConnection *)connection {
    NSLog(@"disconnected");
}

- (void)connectionDidStartConnecting:(TCConnection *)connection {
    NSLog(@"connecting");
}

- (void)createButtonPressed:(id)sender {
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    //    [self displayPerson:person];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

@end
