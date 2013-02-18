/*  
 *  IDToolbarView.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDView.h"

@interface IDToolbarView : IDView

@property (nonatomic, retain) NSArray *toolbarWidgets;
@property (nonatomic, assign) BOOL isPagingEnabled;

@end
