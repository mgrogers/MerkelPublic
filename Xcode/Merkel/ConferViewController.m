//
//  ConferViewController.m
//  Merkel
//
//  Created by Wesley Leung on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "ConferViewController.h"
#import "ConferListItem.h"
#import "ConferTableViewCell.h"

@implementation ConferViewController {
    NSMutableArray *_cellItems;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // create a dummy event list
        _cellItems = [[NSMutableArray alloc] init];
        [_cellItems addObject:[ConferListItem cellItemWithText:@"Daily SCRUM"]];
        [_cellItems addObject:[ConferListItem cellItemWithText:@"SGM"]];    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
	self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor blackColor];
	[self.tableView registerClass:[ConferTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource protocol methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"cell";
    ConferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    // find the to-do item for this index
    int index = [indexPath row];
    ConferListItem *item = _cellItems[index];
    // set the text
	cell.delegate = self;
	cell.cellItem = item;
    return cell;
}

#pragma mark - UITableViewDataDelegate protocol methods

@end
