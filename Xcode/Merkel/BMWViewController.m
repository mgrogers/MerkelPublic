//
//  BMWViewController.m
//  Merkel
//
//  Created by Tim Shi on 2/9/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWViewController.h"

#import "BMWGCalenderDataSource.h"
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface BMWViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *userLabel;

@end

@implementation BMWViewController

#define GoogleClientID    @"992955494422.apps.googleusercontent.com"
#define GoogleClientSecret @"owOZqTGiK2e59tT9OqRHs5Xt"
#define KeychainItemName @"GoogleKeychainName"


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userLabel.hidden = YES;
    self.title = @"Merkel";
    self.trackedViewName = @"Home Screen";
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

        if (![[BMWGCalenderDataSource sharedDataSource] canAuthorize]) {
            [self setupNewGoogleAccount];
        }
        //grab Google auth from keychain. Will move this to grabbing Parse when we add a column for it.
        
//        GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:KeychainItemName
//                                                                     clientID:GoogleClientID
//                                                                 clientSecret:GoogleClientSecret];
//        if(![auth canAuthorize]) {
//            [self setupNewGoogleAccount];
//            

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
    GTMOAuth2ViewControllerTouch *viewController = [[BMWGCalenderDataSource sharedDataSource] authViewControllerWithCompletionHandler:^(GTMOAuth2ViewControllerTouch *viewController, NSError *error) {
        [viewController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }];
    [self presentViewController:viewController animated:YES completion:NULL];

//    NSString *scope = @"https://www.googleapis.com/auth/userinfo.profile";
//    GTMOAuth2ViewControllerTouch *viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:scope
//                                                                 clientID:GoogleClientID
//                                                             clientSecret:GoogleClientSecret
//                                                         keychainItemName:@"GoogleKeychainName"
//                                                                 delegate:self
//                                                         finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
//    [self.navigationController pushViewController:viewController animated:YES];
}

//- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
//      finishedWithAuth:(GTMOAuth2Authentication *)auth
//                 error:(NSError *)error {
//    if (error != nil) {
//        // Authentication failed
//    } else {
//        //Should make a request to Google api to get username, then save to Parse in background. Alternatively, we can just save the auth token
//        
//    
//        PFUser *curUser = [PFUser currentUser];
//        NSLog("success");
//        NSURL *google_user_api = [[NSURL alloc] initWithString:@"https://www.googleapis.com/oauth2/v1/userinfo"];
//
//        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:google_user_api];
//        
//        [auth authorizeRequest:urlRequest
//             completionHandler:^(NSError *error) {
//                 if (error == nil) {
//                     // the request has been authorized
//                 }
//             }];
//    }
//}


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
