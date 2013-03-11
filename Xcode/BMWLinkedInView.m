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
#import "UIImage+Resize.h"

@interface BMWLinkedInView()

@property (nonatomic, retain) IDImage *photo;
@property (nonatomic, strong) IDLabel *jobTitleLabel, *summaryLabel;
@property (nonatomic, strong) NSURL *profileImageURL;


@end

@implementation BMWLinkedInView

@synthesize photo = _photo;


- (void)viewWillLoad:(IDView *)view {
    self.photo = [IDImage image];
    self.jobTitleLabel = [IDLabel label];
    self.summaryLabel = [IDLabel label];
    self.jobTitleLabel.selectable = NO;
    self.summaryLabel.selectable = NO;
    self.widgets = @[self.photo, self.jobTitleLabel, self.summaryLabel];
}

- (void)viewDidBecomeFocused:(IDView *)view {
    if (self.profile) {
        self.title = self.profile.name;
        self.jobTitleLabel.text = self.profile.jobTitle;
        self.summaryLabel.text = self.profile.summary;
        self.profileImageURL = self.profile.profileImageURL;
        [SDWebImageManager.sharedManager downloadWithURL:self.profileImageURL
                                                 options:optind
                                                progress:NULL
                                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                                     {
                                         [self setProfileImageWithImage:image];
                                     }];

    }
}

- (void)setProfileImageWithImage:(UIImage *)image {
    if (!image) return;
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [self.photo setImageData:[self.application.imageBundle imageWithData:imageData] clearWhileSending:YES];
    self.photo.position = CGPointMake(0, 0);
}

@end
