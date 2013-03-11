//
//  BMWEmailView.m
//  Merkel
//
//  Created by Wesley Leung on 3/10/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWEmailView.h"

@interface BMWEmailView();

@property (nonatomic, strong) IDLabel *subjectLabel, *dateLabel, *contentLabel;
@property (nonatomic, strong) NSDate *date;

@end
@implementation BMWEmailView



- (void)viewWillLoad:(IDView *)view {
    

    self.title = @"Email View";
    self.subjectLabel = [IDLabel label];
    self.subjectLabel.selectable = NO;
    self.dateLabel = [IDLabel label];
    self.dateLabel.selectable = NO;
    self.contentLabel = [IDLabel label];
    self.contentLabel.selectable = NO;
    
    
    
    self.widgets = @[self.subjectLabel, self.dateLabel, self.contentLabel];
    
}

- (NSDate *)dateFromEventObject:(NSDictionary *)dict {
    if (dict[@"date"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        return [formatter dateFromString:dict[@"date"]];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        NSMutableString *mutableDate = [dict[@"dateTime"] mutableCopy];
        [mutableDate deleteCharactersInRange:NSMakeRange(mutableDate.length - 3, 1)];
        NSDate *date = [formatter dateFromString:mutableDate];
        return date;
    }
}



- (void)viewDidBecomeFocused:(IDView *)view {
    if (self.email) {
        self.subjectLabel.text = self.email[@"subject"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        
        self.date = [self dateFromEventObject:self.email[@"date"]];
        self.dateLabel.text = [NSString stringWithFormat:@"Start: %@", [formatter stringFromDate:self.date]];
        
        self.contentLabel.text = self.email[@"content"];
    }
}
@end
