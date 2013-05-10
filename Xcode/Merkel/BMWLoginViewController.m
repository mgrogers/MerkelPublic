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

@interface BMWLoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (strong, nonatomic) IBOutlet UILabel *secondFieldLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondFieldCorrectLabel;
@property (strong, nonatomic) IBOutlet UITextField *secondField;
@property (strong, nonatomic) IBOutlet QBFlatButton *primaryNextButton;
@property (strong, nonatomic) IBOutlet QBFlatButton *secondaryNextButton;

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
    self.navigationController.navigationBarHidden = YES;
	self.view.backgroundColor = [UIColor bmwLightBlueColor];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped:)];
    [self.view addGestureRecognizer:tapGR];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.secondField.hidden = NO;
    self.secondFieldLabel.hidden = NO;
    self.secondaryNextButton.hidden = NO;
    self.secondFieldCorrectLabel.hidden = NO;
    [self configureFlatButton:self.primaryNextButton];
    [self configureFlatButton:self.secondaryNextButton];
    [self configureTextField:self.phoneNumberField];
    [self configureTextField:self.secondField];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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

- (IBAction)primaryNextButtonPressed:(UIButton *)sender {
    [self.phoneNumberField resignFirstResponder];
    NSString *phoneNumber = self.phoneNumberField.text;
    // Remove the hyphens from the phone number.
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.primaryNextButton.enabled = NO;
    self.primaryNextButton.titleLabel.text = @"Submitting...";
    [[BMWAPIClient sharedClient] sendConfirmationCodeForPhoneNumber:phoneNumber success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.primaryNextButton.enabled = YES;
        [self.primaryNextButton setTitle:@"Resend" forState:UIControlStateNormal];
        self.confirmationCode = responseObject[@"code"];
        NSLog(@"%@", self.confirmationCode);
        self.secondField.hidden = NO;
        self.secondFieldLabel.hidden = NO;
        self.secondaryNextButton.hidden = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.primaryNextButton.enabled = YES;
        [self.primaryNextButton setTitle:@"Resend" forState:UIControlStateNormal];
    }];
}

- (IBAction)secondaryNextButtonPressed:(UIButton *)sender {
    
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
        if ([textField.text isEqualToString:@"123"] && [string isEqualToString:@"4"]) {
            [self setSecondFieldCorrect:YES];
        } else {
            [self setSecondFieldCorrect:NO];
        }
    }
    return YES;
}

@end
