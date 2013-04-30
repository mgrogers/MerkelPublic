//
//  BMWAddressBookViewController.m
//  Merkel
//
//  Created by Wesley Leung on 4/23/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWAddressBookViewController.h"
#import <AddressBook/AddressBook.h>

@interface BMWAddressBookViewController ()


@property (nonatomic, strong) NSArray *all_contacts;
@property (nonatomic, assign) CFArrayRef people;
@property (nonatomic, strong) NSMutableSet *selected_contacts;

@end

@implementation BMWAddressBookViewController

@synthesize all_contacts = _all_contacts; 
@synthesize people = _people;
@synthesize selected_contacts = _selected_contacts;

- (NSMutableSet *) selected_contacts {
    if (_selected_contacts == nil) {
        _selected_contacts = [[NSMutableSet alloc] init];
    }
    return _selected_contacts;
}

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
}
//	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(50, 50, 300, 300)
//                                                          style:UITableViewStylePlain];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    [self.view addSubview:tableView];
//    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
//    self.people = ABAddressBookCopyArrayOfAllPeople(addressBook);
//    self.all_contacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
//    [tableView reloadData];


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//#pragma mark UITableViewCell Delegate
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellIdentifier = @"ContactCell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                      reuseIdentifier:CellIdentifier];
//    }
//    
//    int index = indexPath.row;
//    ABRecordRef person = CFArrayGetValueAtIndex(self.people, index);
//    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,
//                                                                         kABPersonFirstNameProperty);
//    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person,
//                                                                        kABPersonLastNameProperty);
//    NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
//    
//    cell.textLabel.text = name;
//    return cell;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section     {
//    return [self.all_contacts count];
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    id person = [self.all_contacts objectAtIndex:indexPath.row];
//    if (cell.accessoryType == UITableViewCellAccessoryNone) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        [self.selected_contacts addObject:person];
//    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        [self.selected_contacts removeObject:person];
//    }
//    NSLog(@"%@", self.selected_contacts);
//}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{

    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
//    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

@end
