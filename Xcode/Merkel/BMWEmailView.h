//
//  BMWEmailView.h
//  Merkel
//
//  Created by Wesley Leung on 3/10/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

// Displays a selected email, providing access to basic body and header info.

#import <BMWAppKit/BMWAppKit.h>

@interface BMWEmailView : IDView

@property (nonatomic, strong) NSDictionary *email;
@end
