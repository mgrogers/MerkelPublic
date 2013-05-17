//
//  BMWCalendarAccess.m
//  Merkel
//
//  Created by Tim Shi on 4/23/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWCalendarAccess.h"

#import "BMWAPIClient.h"
#import "BMWPhone.h"

#import <AddressBook/AddressBook.h>

@interface BMWCalendarAccess ()

@property (nonatomic, strong) EKEventStore *store;
@property (readwrite) BOOL isAuthorized;
@property (nonatomic, strong) NSMutableOrderedSet *processedEvents, *processedEventDicts;

@end

@implementation BMWCalendarAccess

NSString * const BMWCalendarAccessGrantedNotification = @"BMWCalendarAccessGrantedNotification";
NSString * const BMWCalendarAccessDeniedNotification = @"BMWCalendarAccessDeniedNotification";
NSString * const kAlertMessageType = @"alert";
NSString * const kInviteMessageType = @"invite";
NSString * const kTestSenderEmailAddress = @"wes.k.leung@gmail.com";

+ (instancetype)sharedAccess {
    static BMWCalendarAccess *sharedAccess = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAccess = [[self alloc] init];
    });
    return sharedAccess;
}

- (id)init {
    self = [super init];
    if (self) {
        self.store = [[EKEventStore alloc] init];
        self.processedEvents = [NSMutableOrderedSet orderedSet];
        self.processedEventDicts = [NSMutableOrderedSet orderedSet];
    }
    return self;
}

- (void)authorizeCompletion:(BMWCalendarAuthorizeCompletion)completion {
    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        self.isAuthorized = granted;
        if (granted) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BMWCalendarAccessGrantedNotification object:self];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:BMWCalendarAccessDeniedNotification object:self];
        }
        if (error) {
            NSLog(@"Calendar access error: %@", [error localizedDescription]);
        }
        if (completion) {
            completion(granted, error);
        }
    }];
}

- (void)getTodaysEventsCompletion:(BMWCalendarEventCompletion)completion {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    NSDateComponents *todayComponents = [calendar components:preservedComponents fromDate:[NSDate date]];
    NSDate *today = [calendar dateFromComponents:todayComponents];
    NSDateComponents *tomorrowComponents = [[NSDateComponents alloc] init];
    tomorrowComponents.day = 1;
    NSDate *tomorrow = [calendar dateByAddingComponents:tomorrowComponents
                                                 toDate:today
                                                options:0];
    [self getEventsStartDate:today endDate:tomorrow completion:completion];
}

- (void)getEventsStartDate:(NSDate *)start
                   endDate:(NSDate *)end
                completion:(BMWCalendarEventCompletion)completion {
    if (!self.isAuthorized) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BMWCalendarAccessDeniedNotification
                                                            object:self];
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Calendar store access not authorized by user."};
        completion(nil, [NSError errorWithDomain:@"com.timshi.Merkel" code:400 userInfo:userInfo]);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.store refreshSourcesIfNecessary];
        for (EKEvent *event in [self.processedEvents copy]) {
            if (![event refresh]) {
                // The event has been deleted or otherwise invalidated. Remove it from the set.
                NSInteger index = (NSInteger)[self.processedEvents indexOfObject:event];
                [self.processedEventDicts removeObjectAtIndex:index];
                [self.processedEvents removeObject:event];
            }
        }
        NSPredicate *predicate = [self.store predicateForEventsWithStartDate:start
                                                                     endDate:end
                                                                   calendars:nil];
        NSArray *events = [self.store eventsMatchingPredicate:predicate];
        events = [events sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
        NSMutableArray *filteredEvents = [NSMutableArray array];
        for (EKEvent *event in events) {
            if (event.birthdayPersonID == -1) {
                if((event.attendees.count || [event.title isEqualToString:@"Quick Call"]) && event.calendar.allowsContentModifications) {
                    NSMutableDictionary *eventWithCode = [@{@"event": event,
                                                          @"conferenceCode": @""} mutableCopy];
                    [filteredEvents addObject:eventWithCode];
                    [self getAndSaveConferenceCodeForEvent:event completion:^(NSString *conferenceCode) {
                        eventWithCode[@"conferenceCode"] = conferenceCode;
                        NSLog(@"Conference code: %@", conferenceCode);
                    }];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(filteredEvents, nil);
        });
    });
}

- (void)createQuickEventWithCompletion:(void (^)(EKEvent *event, NSString *conferenceCode))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        EKEvent *newEvent = [EKEvent eventWithEventStore:self.store];
        newEvent.calendar = [self.store defaultCalendarForNewEvents];
        newEvent.title = @"Quick Call";
        newEvent.startDate = [NSDate date];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.minute = 30;
        newEvent.endDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
        NSError *error;
        [self.store saveEvent:newEvent span:EKSpanThisEvent error:&error];
        [self getAndSaveConferenceCodeForEvent:newEvent completion:^(NSString *conferenceCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(newEvent, conferenceCode);
            });
        }];
    });
}

- (void)getAndSaveConferenceCodeForEvent:(EKEvent *)event completion:(void (^)(NSString *conferenceCode))completion {
    static NSString * const kBMWCalendarNote = @"Conference Added by CallInApp";
    static const NSInteger kBMWConferenceCodeLength = 10;
    [event refresh];
    if ([self.processedEvents containsObject:event]) {
        NSDictionary *eventDict = [self.processedEventDicts objectAtIndex:[self.processedEvents indexOfObject:event]];
        completion(eventDict[@"conferenceCode"]);
        return;
    }
    NSString *notes = event.notes;
    NSRange range = [notes rangeOfString:kBMWCalendarNote];
    NSLog(@"%@", event.title);
    NSLog(@"%@", event.notes);
    if (range.location == NSNotFound || (range.location == 0 && range.length == 0) || !notes) {
        NSLog(@"Code not found, creating new conference.");

        [self attendeesForEvent:event withCompletion:^(NSArray *attendees) {
            [[BMWAPIClient sharedClient] createConferenceForCalendarEvent:event
                                                           attendeesArray:attendees
                                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *conferenceCode = responseObject[@"conferenceCode"];
                NSString *dialin = [NSString stringWithFormat:@"%@,,,%@#", [BMWPhone sharedPhone].phoneNumber, conferenceCode];
                event.notes = [notes stringByAppendingFormat:@"\n\n%@Dial-in: %@\nConference Code: %@", kBMWCalendarNote, dialin, conferenceCode];
                NSError *error;
                [self.store saveEvent:event span:EKSpanFutureEvents commit:YES error:&error];
                if (error) {
                    NSLog(@"Event save error: %@", [error localizedDescription]);
                }
                [self.processedEvents addObject:event];
                [self.processedEventDicts addObject:@{@"event": event,
                 @"conferenceCode": conferenceCode}];
                
                NSDictionary *email_parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  event.title, @"title",
                                                  event.startDate, @"startTime",
                                                  [BMWPhone sharedPhone].phoneNumber, @"phoneNumber",
                                                  conferenceCode, @"conferenceCode",
                                                  event.attendees, @"attendees",
                                                  kInviteMessageType, @"messageType",
                                                  kTestSenderEmailAddress, @"initiator",nil];
                [[BMWAPIClient sharedClient] sendEmailMessageWithParameters:email_parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"Alert success with response %@", responseObject);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error sending message", [error localizedDescription]);
                }];
                completion(conferenceCode);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error creating conference: %@", [error localizedDescription]);
                completion(@"");
            }];
        }];
    } else {
        NSString *code = [event.notes substringFromIndex:event.notes.length - kBMWConferenceCodeLength];
        if (!code) {
            code = @"";
        }
        [self.processedEvents addObject:event];
        [self.processedEventDicts addObject:@{@"event": event,
                                              @"conferenceCode": code}];
        completion(code);
    }
}

- (void)attendeesForEvent:(EKEvent *)event withCompletion:(void (^)(NSArray *attendees))completion {
    NSMutableArray *attendeeArray = [NSMutableArray array];
    __block ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        for (EKParticipant *attendee in event.attendees) {
            NSString *name = (attendee.name) ? attendee.name : @"";
            NSMutableDictionary *attendeeObject = [@{@"name": name} mutableCopy];
            ABRecordRef record = [attendee ABRecordWithAddressBook:addressBook];
            ABMultiValueRef emailMulti = NULL;
            ABMultiValueRef phoneMulti = NULL;
            if (!record) {
                // we don't have an address book record, so assume the name is also the email.
                [attendeeObject setObject:attendee.name forKey:@"email"];
            } else {
                NSString *nsEmail = nil;
                NSString *nsPhone = nil;
                emailMulti = ABRecordCopyValue(record, kABPersonEmailProperty);
                phoneMulti = ABRecordCopyValue(record, kABPersonPhoneProperty);
                CFStringRef email = ABMultiValueCopyValueAtIndex(emailMulti, 0);
                CFStringRef phone = NULL;
                for (CFIndex i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
                    CFStringRef phoneLabel = ABMultiValueCopyLabelAtIndex(phoneMulti, i);
                    CFComparisonResult comparisonResultIPhone = CFStringCompare(phoneLabel, kABPersonPhoneIPhoneLabel, kCFCompareCaseInsensitive);
                    CFComparisonResult comparisonResultMobile = CFStringCompare(phoneLabel, kABPersonPhoneMobileLabel, kCFCompareCaseInsensitive);
                    if (comparisonResultIPhone == kCFCompareEqualTo || comparisonResultMobile == kCFCompareEqualTo) {
                        phone = ABMultiValueCopyValueAtIndex(phoneMulti, i);
                    }
                    CFRelease(phoneLabel);
                }
                if (emailMulti != NULL) CFRelease(emailMulti);
                if (phoneMulti != NULL) CFRelease(phoneMulti);
                if (email != NULL) {
                    nsEmail = (__bridge NSString *)email;
                    [attendeeObject setObject:[nsEmail copy] forKey:@"email"];
                    if (((NSString *)attendeeObject[@"name"]).length == 0) {
                        attendeeObject[@"name"] = [nsEmail copy];
                    }
                    CFRelease(email);
                }
                if (phone != NULL) {
                    nsPhone = (__bridge NSString *)phone;
                    [attendeeObject setObject:[nsPhone copy] forKey:@"phone"];
                    CFRelease(phone);
                }
            }
            [attendeeArray addObject:attendeeObject];
        }
        completion(attendeeArray);
        if (addressBook) {
            CFRelease(addressBook);
        }
    });
}

@end
