/*  
 *  IDMultimediaInfo.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDFlushProtocol.h"


@class IDModel;

/*!
 Multimedia Info to be displayed in the Entertainment Details view in the SplitScreen.
 @abstract This class allows setting strings with information on entertainment audio (e.g. Artist, Album or Title) curently played by the application to be displayed in the "Entertainment Details" view of the SplitScreen in the vehicle display.
 @discussion The multimedia info is only displayed in the split screen view in vehicles with a wide screen display. For the multimedia info to be visible the split screen view must be enabled by the driver, the content of the SplitScreen must be set to "Entertainment Details" and the IDApplication must be the active entertainment audio source. On top of the view the name of the IDApplication playing entertainment audio is displayed, below two lines (firstLine and secondLine) of individual multimedia info can be displayed by the application. The position of the two lines is fixed and does not depend on the length of the string which is displayed. Strings taking up more space then available will be automtically cut.
 */
@interface IDMultimediaInfo : NSObject <IDFlushProtocol>

+ (id)multimediaInfo;

/*!
 The first line of the multimedia info displayed in "Entertainment Details" in the SplitScreen.
 @discussion please see the detailed the description of the multimedia info (@see IDMultimediaInfo).
 (not KVO compliant)
 */
@property (nonatomic, retain) NSString *firstLine;

/*!
 The second line of the multimedia info displayed in "Entertainment Details" in the SplitScreen.
 @discussion please see the detailed the description of the multimedia info (@see IDMultimediaInfo).
 (not KVO compliant)
 */
@property (nonatomic, retain) NSString *secondLine;

@end
