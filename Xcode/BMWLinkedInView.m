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
#import <BMWAppKit/UIImage+BMWAppKit.h>

@interface BMWLinkedInView()

@property (nonatomic, retain) IDImage *photo;
@property (nonatomic, strong) IDLabel *nameLabel, *jobTitleLabel, *summaryLabel;
@property (nonatomic, strong) NSURL *profileImageURL;

@end

@implementation BMWLinkedInView

@synthesize photo = _photo;

static const CGFloat kImageHeight = 200.0;
static const CGFloat kImageWidth = 200.0;


- (void)viewWillLoad:(IDView *)view {
    self.photo = [IDImage image];
    self.photo.position = CGPointMake(0, 0);
    self.nameLabel = [IDLabel label];
    self.jobTitleLabel = [IDLabel label];
    self.summaryLabel = [IDLabel label];
    self.nameLabel.selectable = NO;
    self.jobTitleLabel.selectable = NO;
    self.summaryLabel.selectable = NO;
    self.widgets = @[self.photo, self.nameLabel, self.jobTitleLabel, self.summaryLabel];
    self.startRow = 4;
}

- (void)viewDidBecomeFocused:(IDView *)view {
    if (self.profile) {
        self.title = self.profile.name;
        self.nameLabel.text = self.profile.name;
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
    UIImage *resized_image = [image idResizedImage:CGSizeMake(kImageWidth, kImageHeight) interpolationQuality:1.0];
    [self.photo setImageData: [resized_image idPNGImageData]];
    
}




@end
