//
//  BMWLoginViewController.m
//  Merkel
//
//  Created by Tim Shi on 5/8/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWLoginViewController.h"

#import "BMWAPIClient.h"
#import "QBFlatButton.h"

#import <EventKit/EventKit.h>

@interface BMWLoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (strong, nonatomic) IBOutlet UILabel *secondFieldLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondFieldCorrectLabel;
@property (strong, nonatomic) IBOutlet UITextField *secondField;
@property (strong, nonatomic) IBOutlet QBFlatButton *primaryNextButton;
@property (strong, nonatomic) IBOutlet QBFlatButton *secondaryNextButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (copy, nonatomic) NSString *confirmationCode;
@property BOOL isInEmailMode;
@property BOOL isInRetryMode;
@property (nonatomic, strong) EKEventStore *eventStore;
@property BOOL isCalendarAccessGranted;

@end

@implementation BMWLoginViewController

static NSString * const kTestPhoneNumber = @"1234567890";
static NSString * const kTestCode = @"1234";
static NSString * const kTestEmail = @"test@callinapp.com";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
	self.view.backgroundColor = [UIColor bmwLightBlueColor];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped:)];
    [self.view addGestureRecognizer:tapGR];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.secondField.hidden = YES;
    self.secondFieldLabel.hidden = YES;
    self.secondaryNextButton.hidden = YES;
    self.secondFieldCorrectLabel.hidden = YES;
    [self configureFlatButton:self.primaryNextButton];
    [self configureFlatButton:self.secondaryNextButton];
    [self configureTextField:self.phoneNumberField];
    [self configureTextField:self.secondField];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View Setup

- (void)configureFlatButton:(QBFlatButton *)button {
    button.faceColor = [UIColor bmwDarkBlueColor];
    [button setFaceColor:[UIColor bmwDarkBlueColor] forState:UIControlStateNormal];
    [button setFaceColor:[UIColor bmwDisabledGrayColor] forState:UIControlStateDisabled];
    button.margin = 0.0;
    button.radius = 5.0;
    button.depth = 0.0;
    button.enabled = NO;
}

- (void)configureTextField:(UITextField *)textField {
    textField.font = [UIFont boldFontOfSize:textField.font.pointSize];
}

#pragma mark - View Configuration Modes

- (void)setupSecondaryTextForEmail {
    _isInEmailMode = YES;
    self.primaryNextButton.enabled = NO;
    self.secondFieldCorrectLabel.hidden = YES;
    [self.secondField resignFirstResponder];
    self.secondField.keyboardType = UIKeyboardTypeEmailAddress;
    self.secondField.returnKeyType = UIReturnKeyGo;
    [UIView animateWithDuration:0.5 animations:^{
        self.secondField.alpha = 0.0;
        self.secondFieldLabel.alpha = 0.0;
        self.secondaryNextButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.secondFieldLabel.text = @"One last thing, please enter your email";
        self.secondField.text = @"";
        self.secondField.placeholder = @"email";
        self.secondaryNextButton.enabled = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.secondaryNextButton.alpha = 1.0;
            self.secondFieldLabel.alpha = 1.0;
            self.secondField.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.secondField becomeFirstResponder];
        }];
    }];
}
- (void)setSecondFieldCorrect:(BOOL)isCorrect {
    static NSString * const kIncorrectSymbol = @"✘";
    static NSString * const kCorrectSymbol = @"✓";
    if (isCorrect) {
        self.secondFieldCorrectLabel.textColor = [UIColor greenColor];
        self.secondFieldCorrectLabel.text = kCorrectSymbol;
    } else {
        self.secondFieldCorrectLabel.textColor = [UIColor redColor];
        self.secondFieldCorrectLabel.text = kIncorrectSymbol;
    }
}

- (void)configureForLoading:(BOOL)isLoading {
    if (isLoading) {
        self.phoneNumberLabel.text = @"please wait while we sign you in...";
        [self.spinner startAnimating];
    } else {
        self.phoneNumberLabel.text = @"";
        [self.spinner stopAnimating];
    }
    self.phoneNumberField.hidden = isLoading;
    self.primaryNextButton.hidden = isLoading;
    self.secondFieldLabel.hidden = isLoading;
    self.secondField.hidden = isLoading;
    self.secondaryNextButton.hidden = isLoading;
}

- (void)configureForSuccessfulSignin:(BOOL)isNewUser {
    _isInRetryMode = NO;
    _isInEmailMode = NO;
    __block BOOL blockGranted;
    self.eventStore = [[EKEventStore alloc] init];
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        blockGranted = granted;
        dispatch_async(dispatch_get_main_queue(), ^{
            _isCalendarAccessGranted = blockGranted;
            [self.spinner stopAnimating];
            if ([[PFUser currentUser].username isEqualToString:kTestEmail]) {
                self.phoneNumberLabel.text = @"Welcome! Thank you for testing our app :)";
            } else {
                if (isNewUser) {
                    self.phoneNumberLabel.text = @"Welcome! We're excited for you to get started.";
                } else {
                    self.phoneNumberLabel.text = @"Welcome back!";
                }
            }
            [self.primaryNextButton setTitle:@"Start" forState:UIControlStateNormal];
            self.primaryNextButton.enabled = _isCalendarAccessGranted;
            self.primaryNextButton.hidden = NO;
            self.phoneNumberField.hidden = YES;
            self.secondFieldLabel.hidden = _isCalendarAccessGranted;
            self.secondField.hidden = YES;
            self.secondaryNextButton.hidden = YES;
            if (!_isCalendarAccessGranted) {
                self.secondFieldLabel.text = @"Please enable calendar access in privacy settings.";
            }
        });
    }];
}

#pragma mark - Sign In Methods

- (void)signIn {
    NSString *phoneNumber = [self.phoneNumberField.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *email = self.secondField.text;
    [self configureForLoading:YES];
    [PFUser logInWithUsernameInBackground:email password:phoneNumber block:^(PFUser *user, NSError *error) {
        if (!error) {
            NSLog(@"Logged in user: %@", user.username);
            [self configureForSuccessfulSignin:NO];
        } else {
            NSLog(@"%@", error);
            PFUser *newUser = [PFUser user];
            newUser.username = email;
            newUser.email = email;
            newUser.password = phoneNumber;
            [newUser setObject:phoneNumber forKey:@"phone"];
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"New user: %@", newUser.username);
                    [self configureForSuccessfulSignin:YES];
                } else {
                    NSLog(@"%@", error);
                    self.phoneNumberLabel.text = @"We're sorry, there was an error. Please try again.";
                    [self.primaryNextButton setTitle:@"Retry" forState:UIControlStateNormal];
                    self.primaryNextButton.enabled = YES;
                    self.primaryNextButton.hidden = NO;
                    [self.spinner stopAnimating];
                }
            }];
        }
    }];
}

- (void)signinComplete {
    [self.loginDelegate loginVCDidLogin:self];
}

#pragma mark - Button Action Handlers

- (IBAction)primaryNextButtonPressed:(UIButton *)sender {
    if (!_isInRetryMode && ![PFUser currentUser]) {
        [self.phoneNumberField resignFirstResponder];
        NSString *phoneNumber = self.phoneNumberField.text;
        // Remove the hyphens from the phone number.
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        self.primaryNextButton.enabled = NO;
        self.primaryNextButton.titleLabel.text = @"Submitting...";
        if ([phoneNumber isEqualToString:kTestPhoneNumber]) {
            self.primaryNextButton.enabled = YES;
            [self.primaryNextButton setTitle:@"Resend" forState:UIControlStateNormal];
            self.confirmationCode = kTestCode;
            NSLog(@"%@", self.confirmationCode);
            self.secondField.hidden = NO;
            self.secondFieldLabel.hidden = NO;
            self.secondaryNextButton.hidden = NO;
            [self.secondField becomeFirstResponder];
        } else {
            [[BMWAPIClient sharedClient] sendConfirmationCodeForPhoneNumber:phoneNumber success:^(AFHTTPRequestOperation *operation, id responseObject) {
                self.primaryNextButton.enabled = YES;
                [self.primaryNextButton setTitle:@"Resend" forState:UIControlStateNormal];
                self.confirmationCode = [responseObject[@"code"] stringValue];
                NSLog(@"%@", self.confirmationCode);
                self.secondField.hidden = NO;
                self.secondFieldLabel.hidden = NO;
                self.secondaryNextButton.hidden = NO;
                [self.secondField becomeFirstResponder];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Verification code sending error: %@", error);
                self.phoneNumberLabel.text = @"Unfortunately there was an error. Please resend.";
                self.primaryNextButton.enabled = YES;
                [self.primaryNextButton setTitle:@"Resend" forState:UIControlStateNormal];
            }];
        }
    } else if ([PFUser currentUser]) {
        [self signinComplete];
    } else {
        [self signIn];
    }
}

- (IBAction)secondaryNextButtonPressed:(UIButton *)sender {
    if (!_isInEmailMode) {
        [self setupSecondaryTextForEmail];
    } else {
        [self.secondField resignFirstResponder];
        [self signIn];
    }
}

#pragma mark - Keyboard Management

- (void)screenTapped:(UITapGestureRecognizer *)tapGR {
    [self.phoneNumberField resignFirstResponder];
    [self.secondField resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if ([self.secondField isFirstResponder]) {
        CGRect frame = self.view.frame;
        CGRect keyboard = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        frame.origin.y -= keyboard.size.height;
        frame.origin.y += 20;
        [UIView animateWithDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.frame = frame;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = frame;
    }];
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.secondField && _isInEmailMode) {
        [self secondaryNextButtonPressed:self.secondaryNextButton];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneNumberField) {
        // Adding last digit; enable next button.
        if (range.location == 11 && range.length == 0) {
            self.primaryNextButton.enabled = YES;
        }
        
        // The user is deleting the last digit; disable next button.
        if (range.location == 11 && range.length == 1) {
            self.primaryNextButton.enabled = NO;
        }
        
        // All digits entered
        if (range.location == 12) {
            return NO;
        }
        
        // Reject appending non-digit characters
        if (range.length == 0 &&
            ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
            return NO;
        }
        
        // Auto-add hyphen before appending 4rd or 7th digit
        if (range.length == 0 &&
            (range.location == 3 || range.location == 7)) {
            textField.text = [NSString stringWithFormat:@"%@-%@", textField.text, string];
            return NO;
        }
        
        // Delete hyphen when deleting its trailing digit
        if (range.length == 1 &&
            (range.location == 4 || range.location == 8))  {
            range.location--;
            range.length = 2;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    } else if (textField == self.secondField) {
        if (!_isInEmailMode) {
            if (range.length == 1 && range.location == 3) {
                self.secondFieldCorrectLabel.hidden = YES;
                return YES;
            }
            if (range.length == 0 && range.location == 3) {
                self.secondFieldCorrectLabel.hidden = NO;
                NSString *enteredCode = [textField.text stringByAppendingString:string];
                BOOL isCorrect = [enteredCode isEqualToString:self.confirmationCode];
                [self setSecondFieldCorrect:isCorrect];
                self.secondaryNextButton.enabled = isCorrect;
                return YES;
            }
            if (range.location == 4) {
                return NO;
            }
        } else {
            NSString *enteredEmail = [textField.text stringByReplacingCharactersInRange:range withString:string];
            self.secondaryNextButton.enabled = [enteredEmail isValidEmail];
        }
    }
    return YES;
}

@end
