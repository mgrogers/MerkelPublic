//
//  BMWPhone.m
//  Merkel
//
//  Created by Tim Shi on 4/20/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWPhone.h"

#import "BMWAPIClient.h"
#import "TCConnection.h"
#import "TCDevice.h"

#import <AudioToolbox/AudioToolbox.h>

@interface BMWPhone () <TCDeviceDelegate, TCConnectionDelegate>

@property (nonatomic, strong) TCDevice *device;
@property (nonatomic, strong) TCConnection *connection;

@end

@implementation BMWPhone

@synthesize isSpeakerEnabled = _isSpeakerEnabled;

NSString * const BMWPhoneDeviceStatusDidChangeNotification = @"BMWPhoneDeviceStatusDidChangeNotification";
static NSString * const kBMWPhoneNumberKey = @"kBMWPhoneNumberKey";
static NSString * const kBMWDefaultPhoneNumber = @"+16503535255";

+ (instancetype)sharedPhone {
    static BMWPhone *sharedPhone = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPhone = [[self alloc] init];
    });
    return sharedPhone;
}

-(id)init {
    if ( self = [super init] ) {
        NSDictionary *params = @{@"clientId": ([[PFUser currentUser] objectForKey:@"phone"]) ? [[PFUser currentUser] objectForKey:@"phone"] : [NSNull null]};
       
        
        [[BMWAPIClient sharedClient] getCapabilityTokenWithParameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *capabilityToken = responseObject[@"capabilityToken"];
            self.device = [[TCDevice alloc] initWithCapabilityToken:capabilityToken delegate:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:BMWPhoneDeviceStatusDidChangeNotification
                                                                object:self
                                                              userInfo:@{@"deviceStatus": [NSNumber numberWithInteger:self.status]}];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error logging into Twilio: %@", [error localizedDescription]);
        }];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *number = [defaults stringForKey:kBMWPhoneNumberKey];
        if (!number) {
            [defaults setObject:kBMWDefaultPhoneNumber forKey:kBMWPhoneNumberKey];
            [[BMWAPIClient sharedClient] getPhoneNumberSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [defaults setObject:responseObject[@"number"] forKey:kBMWPhoneNumberKey];
            } failure:NULL];
        }
    }
    return self;
}

- (BOOL)isReady {
    return self.device != nil;
}

- (BOOL)isSpeakerEnabled {
    return _isSpeakerEnabled;
}

- (void)setIsSpeakerEnabled:(BOOL)isSpeakerEnabled {
    _isSpeakerEnabled = isSpeakerEnabled;
    UInt32 route = (_isSpeakerEnabled) ? kAudioSessionOverrideAudioRoute_Speaker : kAudioSessionOverrideAudioRoute_None;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
}

- (BMWPhoneStatus)status {
    if ((self.connection && self.connection.state == TCConnectionStateConnected) || self.connection.state == TCConnectionStateConnecting) {
        return BMWPhoneStatusConnected;
    } else if (self.device != nil) {
        return BMWPhoneStatusReady;
    }
    return BMWPhoneStatusNotReady;
}

- (NSString *)phoneNumber {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kBMWPhoneNumberKey];
}

- (void)connectWithConferenceCode:(NSString *)conferenceCode delegate:(id<TCConnectionDelegate>)connectionDelegate {
    [self connectWithParameters:@{@"conferenceCode": conferenceCode} delegate:connectionDelegate];
}

- (void)connectWithParameters:(NSDictionary *)parameters
                     delegate:(id<TCConnectionDelegate>)connectionDelegate {
    self.connectionDelegate = connectionDelegate;
    if (self.connection) {
        [self.connection disconnect];
    }
    self.connection = [self.device connect:parameters delegate:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:BMWPhoneDeviceStatusDidChangeNotification
                                                        object:self
                                                      userInfo:@{@"deviceStatus": [NSNumber numberWithInteger:self.status]}];
}

- (void)disconnect {
    [self.connection disconnect];
    [[NSNotificationCenter defaultCenter] postNotificationName:BMWPhoneDeviceStatusDidChangeNotification
                                                        object:self
                                                      userInfo:@{@"deviceStatus": [NSNumber numberWithInteger:self.status]}];
}

- (void)quickCallWithDelegate:(id<TCConnectionDelegate>)connectionDelegate {
    NSString *testCode = @"0991035193";
    [self connectWithConferenceCode:testCode delegate:connectionDelegate];
//    [[BMWAPIClient sharedClient] getNewConferenceWithParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *conferenceCode = responseObject[@"conferenceCode"];
//        NSLog(@"conference code: %@", conferenceCode);
//        [self connectWithConferenceCode:conferenceCode delegate:connectionDelegate];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
}

- (void)callWithDelegate:(id<TCConnectionDelegate>)connectionDelegate
       andConferenceCode: (NSString*) conferenceCode {
    [self connectWithConferenceCode:conferenceCode delegate:connectionDelegate];
}

- (void)dialConferenceCode:(NSString *)conferenceCode {
    static NSString * const kJoinCallURLString = @"tel:%@,,,%@#";
    NSString *callNumber = [NSString stringWithFormat:kJoinCallURLString, self.phoneNumber, conferenceCode];
    NSURL *callURL = [NSURL URLWithString:callNumber];
    [[UIApplication sharedApplication] openURL:callURL];
}

#pragma mark - TCDeviceDelegate Methods

- (void)device:(TCDevice *)device didStopListeningForIncomingConnections:(NSError *)error {
    
}

- (void)device:(TCDevice *)device didReceiveIncomingConnection:(TCConnection *)connection {
    
}

- (void)device:(TCDevice *)device didReceivePresenceUpdate:(TCPresenceEvent *)presenceEvent {
    
}

- (void)deviceDidStartListeningForIncomingConnections:(TCDevice *)device {
    
}

#pragma mark - TCConnectionDelegate Methods

- (void)connectionDidStartConnecting:(TCConnection *)connection {
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    [self.connectionDelegate connectionDidStartConnecting:connection];
}

- (void)connectionDidConnect:(TCConnection *)connection {
    [self.connectionDelegate connectionDidConnect:connection];
}

- (void)connectionDidDisconnect:(TCConnection *)connection {
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [self.connectionDelegate connectionDidDisconnect:connection];
}

- (void)connection:(TCConnection *)connection didFailWithError:(NSError *)error {
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [self.connectionDelegate connection:connection didFailWithError:error];
}

@end
