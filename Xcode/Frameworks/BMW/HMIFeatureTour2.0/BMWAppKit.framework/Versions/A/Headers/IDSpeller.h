/*  
 *  IDSpeller.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDWidget.h"


@class IDModel;
@class IDSpeller;

@protocol IDSpellerDelegate <NSObject>
/**
 * This method is called on every change to the string. It always delivers the entire string.
 */
- (void)speller:(IDSpeller *)speller didChangeText:(NSString *)string;
/**
 * This method returns the index of the selected result list element.
 */
- (void)speller:(IDSpeller *)speller didSelectResultAtIndex:(NSInteger)index;
/**
 * This method is called when 'OK' is selected with the speller.
 */
- (void)spellerDidSelectOK:(IDSpeller *)speller;

@end

#pragma mark -

@interface IDSpeller : IDWidget

/**
 * Clears the string and result list.
 */
- (void)clear;

/**
 * The current input string typed by the user.
 */
@property (readonly) NSString *text;

/**
 * Set the delegate for speller input events.
 */
@property (nonatomic, assign) id<IDSpellerDelegate> delegate;

/**
 * Results as an array of strings. No special formatting is allowed in this list. (In contrast to a standard IDTable)
 */
@property (nonatomic, retain) NSArray *results;

/*!
 * Set the target view for when a result list element is selected
 * (not KVO compliant).
 */
@property (nonatomic, assign) IDView *targetView;

+ (id)speller;

@end
