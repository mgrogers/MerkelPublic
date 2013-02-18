/*  
 *  IDStatusBar.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDFlushProtocol.h"


@class IDModel;

/*!
 Status Bar text to be displayed.
 @discussion This class allows setting a string with status bar information to be displayed in the status bar, the area on top of the display where the current time is shown. The text will only be shown in the status bar on views belonging to the same menu (e.g. Radio or ConnectedDrive) as the application. The menu (ApplicationType) an application belongs to is set in the Remote HMI Editor (e.g. type "OnlineServices" => "ConnectedDrive" menu).
 */
@interface IDStatusBar : NSObject <IDFlushProtocol>

+ (id)statusBar;

/*!
 The text to be displayed in the status bar.
 @discussion see the description of IDStatusBar (@see IDStatusBar) for a detailed explanation of the status bar behavior.
 */
@property (nonatomic, retain) NSString *text;

@end
