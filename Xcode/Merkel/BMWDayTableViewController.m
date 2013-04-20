//
//  BMWDayTableViewController.m
//  Merkel
//
//  Created by Tim Shi on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWDayTableViewController.h"

#import "BMWSlidingCell.h"

@interface BMWDayTableViewController ()

@property (nonatomic, strong) NSArray *testData;

@end

@implementation BMWDayTableViewController

static NSString * const kBMWSlidingCellIdentifier = @"BMWSlidingCell";

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    return self.testData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMWSlidingCell *cell = [tableView dequeueReusableCellWithIdentifier:kBMWSlidingCellIdentifier forIndexPath:indexPath];
    NSDictionary *item = self.testData[indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.startLabel.text = item[@"start"];
    cell.endLabel.text = item[@"end"];
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
            NSDictionary *item = self.testData[indexPath.row];
            NSString *eventTitle = item[@"title"];
            NSNumber *phoneNumber = [NSNumber numberWithLongLong:5554443333];
            
                       
            if ([segue.destinationViewController respondsToSelector:@selector(setEventTitle:)]) {
            
            [segue.destinationViewController performSelector:@selector(setEventTitle:) withObject:eventTitle];
            [segue.destinationViewController performSelector:@selector(setPhoneNumber:) withObject:phoneNumber];
        }
    }
}


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

@end
