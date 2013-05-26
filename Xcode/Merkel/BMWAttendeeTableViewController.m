//
//  BMWAttendeeTableViewController.m
//  Merkel
//
//  Created by Wesley Leung on 4/28/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWAttendeeTableViewController.h"

#import <EventKit/EventKit.h>

@interface BMWAttendeeTableViewController ()

@property (nonatomic, strong) NSArray *attendees;

@end

@implementation BMWAttendeeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return self;
}

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//    }
//    return self;
//}

- (NSArray *)attendees {
    if (!_attendees) {
        _attendees = [NSArray array];
    }
    return _attendees;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setEventAttendees:(NSArray *)attendees {
    self.attendees = attendees;
    [self.tableView reloadData];
}

- (EKParticipant *)participantForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (EKParticipant *)self.attendees[indexPath.row];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attendees.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self participantForRowAtIndexPath:indexPath].name;
   
    
    cell.textLabel.font = [UIFont defaultFontOfSize:18]; //Change this value to adjust size
    return cell;
}

@end
