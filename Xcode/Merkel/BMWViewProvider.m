//
//  BMWViewProvider.m
//  TemplateName
//
//  Created by Philip Johnston on 4/6/12.
//  Copyright (c) 2012 BMW. All rights reserved.
//

#import "BMWViewProvider.h"

@interface BMWViewProvider ()

@property (nonatomic, retain) NSArray *viewArray;

@end

@implementation BMWViewProvider

@synthesize mainView = _mainView;
@synthesize viewArray = _viewArray;
@synthesize templateView = _templateView;
@synthesize multimediaInfo = _multimediaInfo;
@synthesize statusBar = _statusBar;

-(id)init
{
    if (self = [super init]) 
    {        
        _templateView = [[BMWTemplateView view] retain];
        
        _viewArray = [[NSArray alloc] initWithObjects:_templateView, nil];
        
        _mainView = _templateView;
    }
    return self;
}

-(void)dealloc
{
    [_viewArray release];
    [_templateView release];
    [_statusBar release];
    [_multimediaInfo release];
    [super dealloc];
}

#pragma mark - useless methods

/*!
 @method allViews
 @abstract The collection of all views representing a state defined in the HMI description.
 @return A set of all views managed by the HMI provider.
 */
- (NSArray *)allViews
{
    return [NSArray arrayWithArray:_viewArray];
}

/*!
 @method multimediaInfo
 @abstract Can be used to retrive a ready to use IDMultimediaInfo object
 @return An initialized instance of a subclass of IDMultimediaInfo
 */
- (IDMultimediaInfo *)multimediaInfo
{
    return _multimediaInfo;
}

/*!
 @method statusBar
 @abstract Can be used to retrive a ready to use IDStatusBar object
 @return An initialized instance of a subclass of IDStatusBar
 */
- (IDStatusBar *)statusBar
{
    return _statusBar;
}


@end
