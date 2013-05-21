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

@property (nonatomic, strong) QBFlatButton *logoutButton;

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.backgroundColor = [UIColor bmwLightBlueColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return 2;
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
        default:
            break;
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
