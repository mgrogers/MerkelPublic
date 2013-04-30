//
//  BMWDayTableViewController.m
//  Merkel
//
//  Created by Tim Shi on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWDayTableViewController.h"

#import "BMWPhone.h"
#import "BMWSlidingCell.h"
#import "TCConnectionDelegate.h"
#import "BMWAddressBookViewController.h"

@interface BMWDayTableViewController () <TCConnectionDelegate, ABPeoplePickerNavigationControllerDelegate>


@property (nonatomic, strong) NSArray *testData;
@property (nonatomic, strong) NSArray *calendarEvents;
@property (nonatomic, strong) NSArray *selectedPeople;

@end

@implementation BMWDayTableViewController

static NSString * const kBMWSlidingCellIdentifier = @"BMWSlidingCell";

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}



- (NSArray *)testData {
    if (!_testData) {
        _testData = @[@{@"title": @"Daily Scrum",
                        @"start": @"10:30am",
                        @"end": @"11:30am"},
                      @{@"title": @"Lunch Break",
                        @"start": @"11:45am",
                        @"end": @"12:30pm"},];
    }
    return _testData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[BMWSlidingCell class] forCellReuseIdentifier:kBMWSlidingCellIdentifier];
    self.view.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"My Day";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, 25.0, 19.0);
    button.backgroundColor = [UIColor clearColor];
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
}

- (void)deviceStatusChanged:(NSNotification *)notification {
    if ([BMWPhone sharedPhone].status == BMWPhoneStatusReady) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Call" style:UIBarButtonItemStyleBordered target:self action:@selector(callButtonPressed)];
    } else if ([BMWPhone sharedPhone].status == BMWPhoneStatusConnected) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"End Call" style:UIBarButtonItemStyleDone target:self action:@selector(endCallButtonPressed)];
    } else if ([BMWPhone sharedPhone].status == BMWPhoneStatusNotReady) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    }
}

- (void)callButtonPressed {
//    BMWAddressBookViewController *abvc = [[BMWAddressBookViewController alloc] init];
//
//
//    [self presentViewController:abvc animated:YES completion:nil];
    
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];

    [[BMWPhone sharedPhone] quickCallWithDelegate:self];
    
    
}

- (void)endCallButtonPressed {
    [[BMWPhone sharedPhone] disconnect];
    
    
    // const CGFloat kTitleFontSize = 10.0;
    
    // UIView *buttonItemView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 19.0)];
    // UILabel *title_text = [[UILabel alloc] init];
    // title_text.text = @"Create";
    
    // [buttonItemView addSubview:title_text];
//    
//    UIButton *create_button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [create_button setBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
//
//    create_button.frame = CGRectMake(0.0, 0.0, 30.0, 19.0);
//    [create_button setBackgroundColor:[UIColor clearColor]];
//     
//    [create_button setTitle:@"Create" forState:UIControlStateNormal];
//    [create_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//
//    [create_button addTarget:self action:@selector(createButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // UIBarButtonItem *cbarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItemView];
    
    
//    UIBarButtonItem *menuBarButtonCreate = [[UIBarButtonItem alloc] initWithCustomView:create_button];
    // self.navigationItem.rightBarButtonItems = @[cbarButtonItem];
    
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
    /*
    NSDictionary *item = self.testData[indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.startLabel.text = item[@"start"];
    cell.endLabel.text = item[@"end"];
     */
    EKEvent *event = [self eventForIndexPath:indexPath];
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BMWSlidingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"Show Detail" sender:cell];

    
    
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
            NSNumber *conferenceCode = [self eventConferenceCodeForIndexPath:indexPath];
            NSNumber *phoneNumber = [NSNumber numberWithLongLong:5554443333];

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

- (NSNumber *)eventConferenceCodeForIndexPath:(NSIndexPath *)indexPath {
    return self.calendarEvents[indexPath.row][@"conferenceCode"];
}

- (void)eventStoreChanged:(NSNotification *)notification {
    [self updateTableViewCalendarEvents];
}

#pragma mark - UITableViewDataDelegate protocol methods

-(void)handleLeftSwipe:(id)cellItem {
    NSUInteger index = [self.testData indexOfObject:cellItem];
    [self.tableView beginUpdates];
    
        //do something with this cell

    [self.tableView endUpdates];
}

-(void)handleRightSwipe:(id)cellItem {
    NSUInteger index = [self.testData indexOfObject:cellItem];
    [self.tableView beginUpdates];
    
    //do something with this cell
    
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
