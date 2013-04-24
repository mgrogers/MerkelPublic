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
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(50, 50, 300, 300)
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
    self.people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    self.all_contacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showPicker:(id)sender
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = sender;
    [sender presentViewController:picker animated:YES completion:^{
        
    }];
    
}

#pragma mark UITableViewCell Delegate

//#pragma mark ABPeoplePickerNavigationControllerDelegate methods
//- (void)peoplePickerNavigationControllerDidCancel:
//(ABPeoplePickerNavigationController *)peoplePicker
//{
//
//    [self dismissViewControllerAnimated:YES completion:^{}];
//}
//
//- (BOOL)peoplePickerNavigationController:
//(ABPeoplePickerNavigationController *)peoplePicker
//      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
//    
////    [self displayPerson:person];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//    return NO;
//}
//
//- (BOOL)peoplePickerNavigationController:
//(ABPeoplePickerNavigationController *)peoplePicker
//      shouldContinueAfterSelectingPerson:(ABRecordRef)person
//                                property:(ABPropertyID)property
//                              identifier:(ABMultiValueIdentifier)identifier
//{
//    return NO;
//}

@end
