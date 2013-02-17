//
//  BMWViewController.m
//  Merkel
//
//  Created by Tim Shi on 2/9/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWViewController.h"

@interface BMWViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *userLabel;

@end

@implementation BMWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userLabel.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![PFUser currentUser]) {
        [self presentLoginView];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonPressed:)];
        [self setupViewForUser];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewForUser {
    PFUser *curUser = [PFUser currentUser];
    self.userLabel.hidden = NO;
    self.userLabel.text = curUser.username;
}

#pragma mark - User Login

- (void)presentLoginView {
    PFLogInViewController *loginVC = [[PFLogInViewController alloc] init];
    loginVC.delegate = self;
    loginVC.signUpController.delegate = self;
    loginVC.fields = PFLogInFieldsFacebook;
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)logoutButtonPressed:(id)sender {
    [PFUser logOut];
    [self presentLoginView];
}

#pragma mark PFLogInViewControllerDelegate Methods

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
}

@end
