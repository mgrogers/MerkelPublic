//
//  BMWLinkedInView.m
//  Merkel
//
//  Created by Wesley Leung on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWLinkedInView.h"

@interface BMWLinkedInView()

@property (nonatomic, retain) IDImage *photo;

@end

@implementation BMWLinkedInView

@synthesize photo = _photo;


- (void)viewWillLoad:(IDView *)view {
    NSString *name = self.linkedInProfile[@"name"];
    self.title =[NSString stringWithFormat:@"%@'s Profile", name];
    
    self.photo = [IDImage image];
    IDLabel *jobTitleLabel = [IDLabel label];
    IDLabel *previousJobTitleLabel = [IDLabel label];
    IDLabel *educationTitleLabel = [IDLabel label];
    
    NSURL *imageURL = [NSURL URLWithString:self.linkedInProfile[@"profileURL"]];

    if(imageURL) {
        dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
        dispatch_async(imageFetchQ, ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
//            self.photo.imageData = [self.application.imageBundle imageWithData:imageData];
            self.photo.position = CGPointMake(0, 0);
        });
    }
    self.widgets = [NSArray arrayWithObjects:
                    self.photo, jobTitleLabel, previousJobTitleLabel, educationTitleLabel,
                    nil];
}


@end
