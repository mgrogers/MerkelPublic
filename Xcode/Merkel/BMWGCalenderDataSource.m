//
//  BMWGCalenderDataSource.m
//  Merkel
//
//  Created by Tim Shi on 2/25/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWGCalenderDataSource.h"

@implementation BMWGCalenderDataSource

+ (instancetype)sharedDataSource {
    static dispatch_once_t onceToken;
    static BMWGCalenderDataSource *sharedDataSource = nil;
    dispatch_once(&onceToken, ^{
        sharedDataSource = [[self alloc] init];
    });
    return sharedDataSource;
}

@end
