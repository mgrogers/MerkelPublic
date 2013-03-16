//
//  BMWViewController.m
//  Merkel
//
//  Created by Tim Shi on 2/9/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWViewController.h"

#import "BMWGCalendarDataSource.h"
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import <Google-API-Client/GTLCalendar.h>

@interface BMWViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;

@end

@implementation BMWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userLabel.hidden = YES;
    self.title = @"Merkel";
    self.trackedViewName = @"Home Screen";
    self.phoneNumberField.delegate = self;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![PFUser currentUser]) {
        [self presentLoginView];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonPressed:)];
        // If the user doesn't have a "first_name" key set that means we need to load their Facebook data.
        if (![[PFUser currentUser] objectForKey:@"first_name"]) {
            [self setupNewUserAccount];
        }
        if (![[BMWGCalendarDataSource sharedDataSource] canAuthorize]) {
            [self setupNewGoogleAccount];
            
        }
        [self setupViewForUser];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Management

- (void)setupNewGoogleAccount {
    GTMOAuth2ViewControllerTouch *viewController = [[BMWGCalendarDataSource sharedDataSource] authViewControllerWithCompletionHandler:^(GTMOAuth2ViewControllerTouch *viewController, NSError *error) {
        [viewController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }];
    [self presentViewController:viewController animated:YES completion:NULL];
}


- (void)setupNewUserAccount {
    [[PF_FBRequest requestForMe] startWithCompletionHandler:^(PF_FBRequestConnection *connection, id result, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary<PF_FBGraphUser> *user = (NSDictionary<PF_FBGraphUser> *)result;
            PFUser *curUser = [PFUser currentUser];
            id username = (user.username) ? user.username : [NSNull null];
            id first_name = (user.first_name) ? user.first_name : [NSNull null];
            id last_name = (user.last_name) ? user.last_name : [NSNull null];
            id email = ([user objectForKey:@"email"]) ? [user objectForKey:@"email"] : [NSNull null];
            [curUser setObject:username forKey:@"username"];
            [curUser setObject:first_name forKey:@"first_name"];
            [curUser setObject:last_name forKey:@"last_name"];
            [curUser setObject:email forKey:@"email"];
            [curUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self setupViewForUser];
            }];
        }
    }];
}


- (void)setupViewForUser {
    PFUser *curUser = [PFUser currentUser];
    
    
    if (![curUser objectForKey:@"first_name"]) {
        return;
    }
    
        
    self.userLabel.hidden = NO;
    self.userLabel.text = curUser.username;
}

- (void)setupPhoneNumberField {
    self.phoneNumberField.keyboardType = UIKeyboardTypePhonePad;
    
}


#pragma mark UITextFieldDelegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if([self isValidPhoneNumber:textField.text]) {
        PFUser *curUser = [PFUser currentUser];
        [curUser setObject:textField.text forKey:@"phone_number"];
        [curUser saveInBackground];
    }
    return YES;
}

-(BOOL)isValidPhoneNumber:(NSString*)phoneNumber {
    return YES;
}

#pragma mark - User Login

- (void)presentLoginView {
    PFLogInViewController *loginVC = [[PFLogInViewController alloc] init];
    loginVC.delegate = self;
    loginVC.signUpController.delegate = self;
    loginVC.fields = PFLogInFieldsFacebook;
    [self.navigationController presentViewController:loginVC animated:YES completion:nil];
}

- (void)logoutButtonPressed:(id)sender {
    [PFUser logOut];
    [[BMWGCalendarDataSource sharedDataSource] logOut];
    [self presentLoginView];
}

#pragma mark PFLogInViewControllerDelegate Methods

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [[BMWGCalendarDataSource sharedDataSource] refreshParseAuth];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark PFSignUpViewControllerDelegate Methods

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [[BMWGCalendarDataSource sharedDataSource] refreshParseAuth];
}

-(void)fetchLatestCalendarEvent {
    NSString *urlString = @"https://www.googleapis.com/calendar/v3/users/me/calendarList";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    [[BMWGCalendarDataSource sharedDataSource] authorizeRequest:request
                                              completionHandler:^(NSError *error) {
                                                  if (error == nil) {
                                                      //change this to async?
                                                      NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                                                      if(responseData) {
                                                          NSError *error;
                                                          NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                                                          NSLog(@"Response string %@", responseString);
                                                          
                                                          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                                                          NSArray *eventsFromJSON = [json objectForKey:@"events"];
//                                                          NSString *output = [NSString stringWithFormat:@"Event name: %@ on %@", [eventsFromJSON[1] objectForKey:@"summary"], [[eventsFromJSON[1] objectForKey:@"start"] objectForKey:@"dateTime"]];
//                                                          [[self.widgets lastObject] setText: output];
                                                      } else {
//                                                          [[self.widgets lastObject] setText: @"Connection to calendar failed."];
                                                          
                                                          
                                                      }
                                                      
                                                  } else {
                                                      NSLog("failed");
                                                  }
                                              }];
}

- (void)fetchCalendarList {
//    self.calendarList = nil;
//    self.calendarListFetchError = nil;
    
    GTLServiceCalendar *service = [[GTLServiceCalendar alloc] init];
    service.authorizer = [BMWGCalendarDataSource sharedDataSource].googleAuth;
    
    GTLQueryCalendar *query = [GTLQueryCalendar queryForCalendarListList];
    
//    BOOL shouldFetchedOwned = ([calendarSegmentedControl_ selectedSegment] == 1);
//    if (shouldFetchedOwned) {
//        query.minAccessRole = kGTLCalendarMinAccessRoleOwner;
//    }
    
    GTLServiceTicket *calendarListTicket = [service executeQuery:query
                                  completionHandler:^(GTLServiceTicket *ticket,
                                                      id calendarList, NSError *error) {
                                      NSLog(@"%@", calendarList);
                                      // Callback
//                                      self.calendarList = calendarList;
//                                      self.calendarListFetchError = error;
//                                      self.calendarListTicket = nil;
                                      
                                  }];
}

@end
