/*  
 *  IDView.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDFlushProtocol.h"


@class IDApplication;
@class IDWidget;
@class IDModel;
@class IDView;

/*!
 @protocol IDViewDelegate
 */
@protocol IDViewDelegate <NSObject>

@optional

- (void)viewWillLoad:(IDView *)view;

/*!
 @method viewDidBecomeFocused:
    Called when the HMI state receives the focus, i.e. it becomes visible or another hmi state that covered the state given as argument was dismissed.
 @param view
    The view object that received the focus.
 */
- (void)viewDidBecomeFocused:(IDView *)view;

/*!
 @method viewDidLoseFocus:
    Called when the HMI state loses the focus, i.e. the hmi state was dismissed or another hmi state is displayed on top.
 @param view
    The view object that lost the focus.
 */
- (void)viewDidLoseFocus:(IDView *)view;

/*!
 @method viewDidAppear:
    Called when the HMI state is pushed onto the hmi view stack.
 @param view
    The view that has been opened.
 */
- (void)viewDidAppear:(IDView *)view;

/*!
 @method viewDidDisappear:
    Called when the HMI state gets popped from the hmi view stack (i.e. the user exits the screen with ZBE left shift).
 @param view
    The view that has become visible.
 */
- (void)viewDidDisappear:(IDView *)view;

@end

#pragma mark -

@interface IDView : NSObject <IDFlushProtocol, IDViewDelegate>

+ (id)view;
+ (id)viewLocalized;

@property (nonatomic, retain) NSArray *widgets;

/*!
 @property title
    The string displayed in the hmi state's title bar
 @discussion
    This property is not KVO compliant
 */
@property (nonatomic, retain) NSString *title;

/*!
 @property application
    The application the view was added to
 */
@property (nonatomic, readonly) IDApplication *application;

/*!
 @property delegate
 */
@property (nonatomic, assign) id<IDViewDelegate> delegate;

/*!
 @property focused
 */
@property (readonly, getter=isFocused) BOOL focused;

/*!
 @property visible
 */
@property (readonly, getter=isVisible) BOOL visible;

@end

#define IDLocalizedString(key) \
[self.application.textBundle idForKey:key]



