//
//  BMWTestStubGCalendarDataSource.m
//  Merkel
//
//  Created by Wesley Leung on 3/22/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWTestStubGCalendarDataSource.h"
#import "BMWGCalendarDataSource.h"
#import "BMWGCalendarEvent.h"
#import "BMWLinkedInProfile.h"

@implementation BMWTestStubGCalendarDataSource


+ (NSArray *)eventsToDisplayTest {
    NSDictionary *testCalendarJSON = @{
        @"name": @"Merkel",
        @"events": @[@{
                       @"id": @"on4vpqn3bad2pdf2cc9mtnqpes",
                       @"name": @"Breakfast with Taylor",
                       @"description": @"Catch up and discuss new watchface SDK for Pebble.",
                       @"location": @"Mayfield Bakery & Cafe Town & Country Village 855 El Camino Real Palo Alto, CA 94301",
                       @"start": @{
                           @"dateTime": @"2013-03-27T15:00:00Z"
                       },
                       @"end": @{
                           @"dateTime": @"2013-03-27T16:00:00Z"
                       },
                       @"creator": @{
                           @"email": @"imtonyjin@gmail.com"
                       },
                       @"attendees": @[
                                     @{
                                         @"email": @"taylor@taylorsavage.com",
                                         @"responseStatus": @"declined",
                                         @"comment": @"Sounds pleasant but won't you be in Germany?"
                                     }
                                     ],
                       @"created": @"2013-03-21T23:08:41.000Z",
                       @"updated": @"2013-03-21T23:10:21.746Z"
                   },
                   @{
                       @"id": @"h5f8bbif878gktftr7vgjd5jc8",
                       @"name": @"Weekly All-Hands Engineering Meeting",
                       @"description": @"Weely all-hands engineering meeting at Google.",
                       @"location": @"Google Building 43 1600 Amphitheatre Pkwy, Mountain View, CA 94043",
                       @"start": @{
                           @"dateTime": @"2013-03-27T16:30:00Z"
                       },
                       @"end": @{
                           @"dateTime": @"2013-03-27T18:00:00Z"
                       },
                       @"creator": @{
                           @"email": @"imtonyjin@gmail.com"
                       },
                       @"attendees": @[
                                     @{
                                         @"email": @"mjgrogers@gmail.com",
                                         @"responseStatus": @"needsAction"
                                     },
                                     @{
                                         @"email": @"wes.k.leung@gmail.com",
                                         @"responseStatus": @"needsAction"
                                     }
                                     ],
                       @"created": @"2013-03-21T23:14:09.000Z",
                       @"updated": @"2013-03-21T23:14:22.264Z"
                   },
                   @{
                       @"id": @"bdu18rpiri4g0nls8k8k2kdhac",
                       @"name": @"Lunch with Team",
                       @"description": @"Love the sushi here.",
                       @"location": @"Long Life Cafe Amphitheatre Pkwy & Garcia Ave Mountain View, CA 94043",
                       @"start": @{
                           @"dateTime": @"2013-03-27T19:00:00Z"
                       },
                       @"end": @{
                           @"dateTime": @"2013-03-27T20:30:00Z"
                       },
                       @"creator": @{
                           @"email": @"imtonyjin@gmail.com"
                       },
                       @"created": @"2013-03-21T23:17:14.000Z",
                       @"updated": @"2013-03-21T23:17:14.056Z"
                   },
                   @{
                       @"id": @"q8teo8bmjq8kp3h1fngp30shq0",
                       @"name": @"Meeting with Tim from IDEO",
                       @"description": @"Discuss potential design change - removal of header bar from Google web products.",
                       @"location": @"IDEO Palo Alto 100 Forest Avenue Palo Alto, CA 94301",
                       @"start": @{
                           @"dateTime": @"2013-03-27T21:00:00Z"
                       },
                       @"end": @{
                           @"dateTime": @"2013-03-27T23:00:00Z"
                       },
                       @"creator": @{
                           @"email": @"imtonyjin@gmail.com"
                       },
                       @"attendees": @[
                                     @{
                                         @"email": @"timgshi@gmail.com",
                                         @"responseStatus": @"needsAction"
                                     }
                                     ],
                       @"created": @"2013-03-21T23:24:06.000Z",
                       @"updated": @"2013-03-21T23:24:31.105Z"
                   },
                   @{
                       @"id": @"t3949ecbfq46ha46d2ik19jrfo",
                       @"name": @"Dinner with Michelle",
                       @"location": @"NOLA Restaurant & Bar 535 Ramona St Palo Alto, CA 94301",
                       @"start": @{
                           @"dateTime": @"2013-03-28T00:00:00Z"
                       },
                       @"end": @{
                           @"dateTime": @"2013-03-28T02:00:00Z"
                       },
                       @"creator": @{
                           @"email": @"imtonyjin@gmail.com"
                       },
                       @"attendees": @[
                                     @{
                                         @"email": @"yuzukonii@gmail.com",
                                         @"responseStatus": @"needsAction"
                                     }
                                     ],
                       @"created": @"2013-03-21T23:27:02.000Z",
                       @"updated": @"2013-03-21T23:27:02.094Z"
                   },
                   @{
                       @"id": @"58fpvu5la70suto5aqpvkf4r08",
                       @"name": @"Ideate on Future of Google Keep",
                       @"description": @"Public sentiment has become negative towards Google Keep because of the shutdown of Google Reader and similarity with Evernote. We need to ideate on ways to reverse this sentiment and portray Keep as a logical extension of Google Drive.",
                       @"location": @"Starbucks Coffee 376 University Ave Palo Alto, CA 94301",
                       @"start": @{
                           @"dateTime": @"2013-03-28T02:30:00Z"
                       },
                       @"end": @{
                           @"dateTime": @"2013-03-28T05:00:00Z"
                       },
                       @"creator": @{
                           @"email": @"imtonyjin@gmail.com"
                       },
                       @"attendees": @[
                                     @{
                                         @"email": @"imtonyjin@gmail.com",
                                         @"displayName": @"Tony Jin",
                                         @"responseStatus": @"needsAction"
                                     }
                                     ],
                       @"created": @"2013-03-21T23:34:13.000Z",
                       @"updated": @"2013-03-21T23:34:13.826Z"
                   }
                   ]
        };
    
    
    NSArray *testEventsArrayfromCalendar = [testCalendarJSON objectForKey:@"events"];
    NSMutableArray *events = [NSMutableArray array];
    for (int i =0; i < [testEventsArrayfromCalendar count]; i++) {
        NSDictionary *event = [testEventsArrayfromCalendar objectAtIndex:i];
        [events addObject:[BMWGCalendarEvent eventFromJSONDict:event]];
    }
    
    return events;
}

+ (NSArray *)attendeesToDisplayTest {
    NSDictionary *attendee = @{@"name": @"Wesley Leung",
                               @"jobTitle": @"CS Student",
                               @"profileImageURl": @"http://m.c.lnkd.licdn.com/media/p/8/000/1c6/09c/29b17fa.jpg",
                               @"summary": @"I currently attend Stanford.",
                               @"emails": @[
                                       
                                       @{@"date":@{@"dateTime": @"2013-01-08T10:00:00-08:00"},@"subject":@"Re: Catching up for lunch.", @"content":@"Let's meet at the GSB"},
                                       
                                       @{@"date":@{@"dateTime": @"2013-01-18T10:00:00-08:00"},@"subject":@"Re: Meeting with associates.", @"content":@"This is an all-hands meeting."}
                                       
                                       ]};
    NSMutableArray *attendees = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        [attendees addObject:[BMWLinkedInProfile profileFromJSONDict:attendee]];
        
    }
    return attendees;
}

@end
