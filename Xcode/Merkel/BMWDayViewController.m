//
//  ConferViewController.m
//  Merkel
//
//  Created by Wesley Leung on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWDayViewController.h"
#import "BMWDayListItem.h"
#import "BMWDayTVCell.h"

@implementation BMWDayViewController {
    NSMutableArray *_cellItems;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _cellItems = [[NSMutableArray alloc] init];
    [_cellItems addObject:[ConferListItem cellItemWithText:@"Daily SCRUM"]];
    [_cellItems addObject:[ConferListItem cellItemWithText:@"SGM"]];
    
	self.tableView.dataSource = self;
    self.tableView.delegate = self;
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
	cell.textLabel.text = item.text;
    
    cell.delegate = self;
    cell.cellItem = item;
    return cell;
}

#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(void)cellItemDeleted:(id)cellItem {
    // use the UITableView to animate the removal of this row
    NSUInteger index = [_cellItems indexOfObject:cellItem];
    [self.tableView beginUpdates];
    [_cellItems removeObject:cellItem];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

@end
