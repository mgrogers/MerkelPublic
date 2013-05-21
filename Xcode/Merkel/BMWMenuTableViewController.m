//
//  BMWMenuTableViewController.m
//  Merkel
//
//  Created by Tim Shi on 5/21/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWMenuTableViewController.h"

#import <QBFlatButton.h>

@interface BMWMenuTableViewController ()

@property (nonatomic, strong) QBFlatButton *logoutButton, *feedbackButton;

@end

@implementation BMWMenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
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
    self.logoutButton = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    [self.logoutButton setFaceColor:[UIColor bmwRedColor]];
    [self.logoutButton setSideColor:[UIColor bmwDarkRedColor]];
    self.logoutButton.radius = 2.0;
    self.logoutButton.depth = 4.0;
    self.logoutButton.margin = 4.0;
    [self.logoutButton setTitle:@"Log out" forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(logoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.feedbackButton = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    [self.feedbackButton setFaceColor:[UIColor bmwGreenColor]];
    [self.feedbackButton setSideColor:[UIColor bmwDarkGreenColor]];
    self.feedbackButton.radius = 2.0;
    self.feedbackButton.depth = 4.0;
    self.feedbackButton.margin = 4.0;
    [self.feedbackButton setTitle:@"Send Feedback" forState:UIControlStateNormal];
    [self.feedbackButton addTarget:self action:@selector(feedbackButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.backgroundColor = [UIColor bmwLightBlueColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

static NSString * const kMyNumberText = @"My Number: ";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldFontOfSize:18.0];
    CGRect buttonFrame = CGRectInset(cell.contentView.frame, 5.0, 5.0);
    buttonFrame.size.width = 270.0;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = kMyNumberText;
            if ([[PFUser currentUser] objectForKey:@"phone"]) {
                cell.textLabel.text = [cell.textLabel.text stringByAppendingString:[[PFUser currentUser] objectForKey:@"phone"]];
            }
            break;
        case 1:
            self.logoutButton.frame = buttonFrame;
            [cell.contentView addSubview:self.logoutButton];
            break;
        case 2:
            self.feedbackButton.frame = buttonFrame;
            [cell.contentView addSubview:self.feedbackButton];
            break;
        default:
            break;
    }
    return cell;
}

- (void)logoutButtonPressed {
    
}

- (void)feedbackButtonPressed {
    [TestFlight openFeedbackView];
}

@end
