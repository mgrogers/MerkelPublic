//
//  BMWLoginViewController.m
//  Merkel
//
//  Created by Tim Shi on 5/8/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWLoginViewController.h"

#import "BMWAPIClient.h"

@interface BMWLoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (strong, nonatomic) IBOutlet UILabel *secondFieldLabel;
@property (strong, nonatomic) IBOutlet UITextField *secondField;
@property (strong, nonatomic) IBOutlet UIButton *primaryNextButton;
@property (strong, nonatomic) IBOutlet UIButton *secondaryNextButton;

@property (copy, nonatomic) NSString *confirmationCode;

@end

@implementation BMWLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor bmwDarkBlueColor];
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)primaryNextButtonPressed:(UIButton *)sender {
    [self.phoneNumberField resignFirstResponder];
    NSString *phoneNumber = self.phoneNumberField.text;
    [[BMWAPIClient sharedClient] sendConfirmationCodeForPhoneNumber:phoneNumber success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.primaryNextButton setTitle:@"Resend" forState:UIControlStateNormal];
        self.confirmationCode = responseObject[@"code"];
        NSLog(@"%@", self.confirmationCode);
        self.secondField.hidden = NO;
        self.secondFieldLabel.hidden = NO;
        self.secondaryNextButton.hidden = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.primaryNextButton setTitle:@"Resend" forState:UIControlStateNormal];
    }];
}

- (IBAction)secondaryNextButtonPressed:(UIButton *)sender {
    
}

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

@end
