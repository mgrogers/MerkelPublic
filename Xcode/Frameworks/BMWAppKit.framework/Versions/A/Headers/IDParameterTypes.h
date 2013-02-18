/*  
 *  IDParameterTypes.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

/*!
 @typedef IDPropertyType
 */
typedef enum IDParameterTypes
{
    IDParameterInvalid = 255,
    IDParameterValue = 0,
    IDParameterActionEventListIndex = 1,
    IDParameterActionEventSelectedValue = 2,
    IDParameterActionEventChecked = 3,
    IDParameterHmiEventFocus = 4,
    IDParameterHmiEventRequestDataFrom = 5,
    IDParameterHmiEventRequestDataSize = 6,
    IDParameterHmiEventSplitscreen = 7,
    IDParameterActionEventSpellerInput = 8,
    IDParameterActionEventKeyCode = 20,
    IDParameterHmiEventKeyCode = 20,
    IDParameterHmiEventChannelStatus = 21,
    IDParameterHmiEventConnectionStatus = 22,
    IDParameterHmiEventVisible = 23,
    IDParameterHmiEventMoviesPermission = 24,
    IDParameterHmiEventTUIMode = 25,
    IDParameterActionEventLocationInput = 40,
    IDParameterHmiEventListIndex = 41,
    IDParameterActionEventSelectionText = 42,
    IDParameterActionEventInvokedBy = 43
} IDParameterTypes;
