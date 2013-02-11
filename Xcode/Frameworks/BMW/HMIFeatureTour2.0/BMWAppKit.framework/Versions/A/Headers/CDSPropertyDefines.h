/*  
 *  CDSPropertyDefines.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "CDSPropertyDefinesControls.h"
#import "CDSPropertyDefinesDriving.h"
#import "CDSPropertyDefinesEngine.h"
#import "CDSPropertyDefinesEntertainment.h"
#import "CDSPropertyDefinesNavigation.h"
#import "CDSPropertyDefinesSensors.h"
#import "CDSPropertyDefinesVehicle.h"

// CDSError definitions
enum
{
    CDSErrorInvalidProperty = 400,
    CDSErrorPropertyUnavailable = 401,
    CDSErrorPropertyForbidden = 402
};
