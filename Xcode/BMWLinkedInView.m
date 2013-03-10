//
//  BMWLinkedInView.m
//  Merkel
//
//  Created by Wesley Leung on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWLinkedInView.h"
#import "BMWLinkedInProfile.h"
#import "BMWViewProvider.h"
#import <SDWebImage/SDWebImageManager.h>

@interface BMWLinkedInView()

@property (nonatomic, retain) IDImage *photo;
@property (nonatomic, strong) IDLabel *jobTitleLabel, *summaryLabel;


@end

@implementation BMWLinkedInView

@synthesize photo = _photo;


- (void)viewWillLoad:(IDView *)view {
        
    self.photo = [IDImage image];
    IDLabel *jobTitleLabel = [IDLabel label];
    IDLabel *summaryLabel = [IDLabel label];

//    if(imageURL) {
//        dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
//        dispatch_async(imageFetchQ, ^{
//            NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
//            self.photo.imageData = [self.application.imageBundle imageWithData:imageData];
//            self.photo.position = CGPointMake(0, 0);
//        });
//    }
    self.widgets = [NSArray arrayWithObjects:
                    self.photo, jobTitleLabel, summaryLabel,
                    nil];

}

- (void)viewDidBecomeFocused:(IDView *)view {
//    
//    self.profile = [self.linkedInDelegate attendeeforAttendeeView:self];
    
//    self.profile = [self profil]
//    
//    
//    NSString *name = self.[@"name"];
//    self.title =[NSString stringWithFormat:@"%@'s Profile", name];
    if (self.profile) {
        self.title = self.profile.name;
        self.jobTitleLabel.text = self.profile.jobTitle;
        self.summaryLabel.text = self.profile.summary;
        
        
//        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
//                                             {
//                                                 __strong UIImageView *sself = wself;
//                                                 if (!sself) return;
//                                                 if (image)
//                                                 {
//                                                     sself.image = image;
//                                                     [sself setNeedsLayout];
//                                                 }
//                                                 if (completedBlock && finished)
//                                                 {
//                                                     completedBlock(image, error, cacheType);
//                                                 }
//                                             }];

    }
}



@end
