/*  
 *  IDHmiProvider.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>


@class IDView;
@class IDModel;
@class IDMultimediaInfo;
@class IDStatusBar;

@protocol IDHmiProvider <NSObject>

@property (nonatomic, assign) IDView *mainView;

/*!
 @method allViews
 @abstract The collection of all views representing a state defined in the HMI description.
 @return A set of all views managed by the HMI provider.
 */
- (NSArray *)allViews;


/*!
 @method multimediaInfo
 @abstract Can be used to retrive a ready to use IDMultimediaInfo object
 @return An initialized instance of a subclass of IDMultimediaInfo
 */
- (IDMultimediaInfo *)multimediaInfo;

/*!
 @method statusBar
 @abstract Can be used to retrive a ready to use IDStatusBar object
 @return An initialized instance of a subclass of IDStatusBar
 */
- (IDStatusBar *)statusBar;

@end
