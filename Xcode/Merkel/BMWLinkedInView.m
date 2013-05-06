////
////  BMWLinkedInView.m
////  Merkel
////
////  Created by Wesley Leung on 3/2/13.
////  Copyright (c) 2013 BossMobileWunderkinder. All rights reserved.
////
//
//#import "BMWLinkedInView.h"
//#import "BMWLinkedInProfile.h"
//#import "BMWViewProvider.h"
//#import <SDWebImage/SDWebImageManager.h>
//#import <BMWAppKit/UIImage+BMWAppKit.h>
//
//@interface BMWLinkedInView()
//
//@property (nonatomic, retain) IDImage *photo;
//@property (nonatomic, strong) IDLabel *nameLabel, *jobTitleLabel, *summaryLabel, *emailHeaderLabel, *spinner;
//@property (nonatomic, strong) NSArray *emails;
//@property (nonatomic, strong) NSURL *profileImageURL;
//@property NSInteger selectedIndex;
//
//@end
//
//@implementation BMWLinkedInView
//
//@synthesize photo = _photo;
//
//static const CGFloat kImageHeight = 200.0;
//static const CGFloat kImageWidth = 200.0;
//static const NSInteger kIndexofEmail = 6;
//
//
//- (void)viewWillLoad:(IDView *)view {
//    [self createAllAssets];
//    self.startRow = 4;
//}
//
//- (void)createAllAssets {
//    BMWViewProvider *provider = self.application.hmiProvider;
//    
//    self.photo = [IDImage image];
//    self.photo.position = CGPointMake(5, 5);
//    self.nameLabel = [IDLabel label];
//    self.nameLabel.selectable = NO;
//    self.jobTitleLabel = [IDLabel label];
//    self.jobTitleLabel.selectable = NO;
//    self.summaryLabel = [IDLabel label];
//    self.summaryLabel.selectable = NO;
//    
//    self.nameLabel.position = CGPointMake(230, 5);
//    self.jobTitleLabel.position = CGPointMake(230, 45);
//    self.summaryLabel.position = CGPointMake(230, 85);
//    
//    self.emailHeaderLabel = [IDLabel label];
//    self.emailHeaderLabel.isInfoLabel = YES;
//    self.emailHeaderLabel.selectable = NO;
//    
//    self.spinner = [IDLabel label];
//    self.spinner.selectable = NO;
//    
//    NSMutableArray *mutableEmailWidgets = [NSMutableArray array];
//    
//    const NSInteger kButtonLimit = 3;
//    for (int i = 0; i < kButtonLimit; i++) {
//        IDButton *button = [IDButton button];
//        [button setTarget:self selector:@selector(buttonFocused:) forActionEvent:IDActionEventFocus];
//        [button setTargetView:provider.emailView];
//        button.visible = NO;
//        [mutableEmailWidgets addObject:button];
//    }
//
//    self.widgets = [[@[self.spinner, self.photo, self.nameLabel, self.jobTitleLabel, self.summaryLabel, self.emailHeaderLabel] arrayByAddingObjectsFromArray:mutableEmailWidgets] mutableCopy];
//    [self hideAllAssets];
//}
//
//- (void)hideAllAssets {
//    self.nameLabel.visible = NO;
//    self.jobTitleLabel.visible = NO;
//    self.summaryLabel.visible = NO;
//    self.emailHeaderLabel.visible = NO;
//    self.spinner.waitingAnimation = YES;
//    self.spinner.selectable = NO;
//    
//}
//
//- (void)showAllAssets {
//    self.nameLabel.visible = YES;
//    self.jobTitleLabel.visible = YES;
//    self.summaryLabel.visible = YES;
//    self.emailHeaderLabel.visible = YES;
//    self.spinner.waitingAnimation = NO;
//    self.spinner.visible = NO;
//    
//    NSInteger index = kIndexofEmail;
//    for (NSDictionary *emails in self.emails) {
//        IDButton *button = [self.widgets objectAtIndex:index];
//        button.text = emails[@"subject"];
//        button.visible = YES;
//        index++;
//    }
//
//}
//
//- (void)viewDidBecomeFocused:(IDView *)view {
//    if (self.profile) {
//        self.title = self.profile.name;
//    
//        
//        self.nameLabel.text = self.profile.name;
//        self.jobTitleLabel.text = self.profile.jobTitle;
//        self.summaryLabel.text = self.profile.summary;
//        self.profileImageURL = self.profile.profileImageURL;
//        self.emails = self.profile.emails;
//        self.emailHeaderLabel.text = @"Recent Emails";
//
//        
//        [SDWebImageManager.sharedManager downloadWithURL:self.profileImageURL
//                                                 options:optind
//                                                progress:NULL
//                                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
//                                     {
//                                    
//                                        [self setProfileImageWithImage:image];
//                                        [self showAllAssets];
//
//                                     }];
//        
//        }
//}
//
//- (void)setProfileImageWithImage:(UIImage *)image {
//    if (!image) return;
//    UIImage *resized_image = [image idResizedImage:CGSizeMake(kImageWidth, kImageHeight) interpolationQuality:1.0];
//    [self.photo setImageData: [resized_image idPNGImageData]];
//}
//
//- (void)buttonFocused:(IDButton *)button {
//    _selectedIndex = [self.widgets indexOfObject:button];
//    BMWViewProvider *provider = self.application.hmiProvider;
//    provider.emailView.email = self.emails[_selectedIndex - kIndexofEmail];
//    
//}
//
//
//
//
//@end
