//
//  BMWViewController.m
//  Merkel
//
//  Created by Tim Shi on 2/9/13.
//  Copyright (c) 2013 BossMobileWunderkinder. All rights reserved.
//

#import "BMWViewController.h"

#import "BMWGCalendarDataSource.h"
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import <Google-API-Client/GTLCalendar.h>

@interface BMWViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberValidator;

@property (weak, nonatomic) IBOutlet UIImageView *chargerView;
@property (weak, nonatomic) IBOutlet UIImageView *bmwLogoView;

@end

@implementation BMWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userLabel.hidden = YES;
    self.title = @"Merkel";
    self.trackedViewName = @"Home Screen";
    self.phoneNumberField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectedBMW:)
                                                 name:IDVehicleDidConnectNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectedBMW:)
                                                 name:IDVehicleDidDisconnectNotification
                                               object:nil];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, 25.0, 19.0);
    button.backgroundColor = [UIColor clearColor];
    [button setBackgroundImage:[UIImage imageNamed:@"reveal_menu_icon_portrait.png"] forState:UIControlStateNormal];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 10.0;
    self.navigationItem.leftBarButtonItems = @[spacer, menuBarButton];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal_menu_icon_portrait.png"] landscapeImagePhone:[UIImage imageNamed:@"reveal_menu_icon_landscape.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
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
    self.userLabel.text = [curUser objectForKey:@"first_name"];
    if([curUser objectForKey:@"phone_number"]) {
        NSString *numberString = [[curUser objectForKey:@"phone_number"] stringValue];
        self.phoneNumberField.text = [self addDashtoPhoneNumber:numberString];
        self.phoneNumberValidator.hidden = NO;
    }
    
}

#pragma mark UITextFieldDelegate Methods

- (void)doneEditingTextField:(id)sender {

    if([self isValidPhoneNumber:self.phoneNumberField.text]) {
        self.phoneNumberValidator.hidden = NO;
        PFUser *curUser = [PFUser currentUser];
        
        NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterNoStyle];
        NSNumber *phoneNumber = [formatter numberFromString:self.phoneNumberField.text];
        [curUser setObject:phoneNumber forKey:@"phone_number"];
        [curUser saveInBackground];
        
        self.phoneNumberField.text = [self addDashtoPhoneNumber:self.phoneNumberField.text];
    } else {
        self.phoneNumberValidator.hidden = YES;
    }
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonPressed:)];
    [self.phoneNumberField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *combinedString = [textField.text stringByReplacingCharactersInRange:range withString:string];    
    if([self isValidPhoneNumber: combinedString]) {
        self.phoneNumberValidator.hidden = NO;

    } else {
        self.phoneNumberValidator.hidden = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneEditingTextField:)];
    NSString *numberWithoutDashes = [textField.text
                                     stringByReplacingOccurrencesOfString:@"-" withString:@""];
    textField.text = numberWithoutDashes;
    self.navigationItem.rightBarButtonItem = doneButton;
    return YES;
}

-(BOOL)isValidPhoneNumber:(NSString*)phoneNumber {
    if(phoneNumber.length == 10) {
        return YES;
    } else {
        return false;
    }
}

- (NSString*)addDashtoPhoneNumber:(NSString*)text
{
    NSMutableString *phoneNumber = [NSMutableString stringWithString:text];
    int length = [phoneNumber length];
    for (int i = 3;i <= length; i++) {
        [phoneNumber insertString:@"-" atIndex:i];
        i+=3;
    }
    return phoneNumber;
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

#pragma mark - View Callbacks
// When phone is connected (or start button in simulator pressed), BMWManager is
// Started. The status of the connection will be updated via NSNotification tracking IDVehicleDidConnectNotification
- (void)connectedBMW:(NSNotification *)notification
{
    self.bmwLogoView.hidden = NO;
    self.chargerView.hidden = NO;
}

- (void)disconnectedBMW:(NSNotification *)notification
{
    self.bmwLogoView.hidden = YES;
    self.chargerView.hidden = YES;
}



@end
