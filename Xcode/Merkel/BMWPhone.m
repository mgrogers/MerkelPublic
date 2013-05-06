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

@interface BMWPhone () <TCDeviceDelegate>

@property (nonatomic, strong) TCDevice *device;
@property (nonatomic, strong) TCConnection *connection;

@end

@implementation BMWPhone

NSString * const BMWPhoneDeviceStatusDidChangeNotification = @"BMWPhoneDeviceStatusDidChangeNotification";

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
        NSDictionary *params = @{@"clientId": ([PFUser currentUser].username) ? [PFUser currentUser].username : [NSNull null]};
       
        
        [[BMWAPIClient sharedClient] getCapabilityTokenWithParameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *capabilityToken = responseObject[@"capabilityToken"];
            self.device = [[TCDevice alloc] initWithCapabilityToken:capabilityToken delegate:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:BMWPhoneDeviceStatusDidChangeNotification
                                                                object:self
                                                              userInfo:@{@"deviceStatus": [NSNumber numberWithInteger:self.status]}];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error logging into Twilio: %@", [error localizedDescription]);
        }]; 
    }
    return self;
}

- (BOOL)isReady {
    return self.device != nil;
}

- (BMWPhoneStatus)status {
    if (self.connection && self.connection.state == TCConnectionStateConnected || self.connection.state == TCConnectionStateConnecting) {
        return BMWPhoneStatusConnected;
    } else if (self.device != nil) {
        return BMWPhoneStatusReady;
    }
    return BMWPhoneStatusNotReady;
}

- (void)connectWithConferenceCode:(NSString *)conferenceCode delegate:(id<TCConnectionDelegate>)connectionDelegate {
    [self connectWithParameters:@{@"conferenceCode": conferenceCode} delegate:connectionDelegate];
}

- (void)connectWithParameters:(NSDictionary *)parameters
                     delegate:(id<TCConnectionDelegate>)connectionDelegate {
    NSLog(@"%@", [_device.capabilities objectForKey:TCDeviceCapabilityOutgoingKey]);
    self.connection = [self.device connect:parameters delegate:connectionDelegate];
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
#pragma mark - TCDeviceDelegate Methods

- (void)device:(TCDevice *)device didStopListeningForIncomingConnections:(NSError *)error {
    
}

- (void)device:(TCDevice *)device didReceiveIncomingConnection:(TCConnection *)connection {
    
}

- (void)device:(TCDevice *)device didReceivePresenceUpdate:(TCPresenceEvent *)presenceEvent {
    
}

- (void)deviceDidStartListeningForIncomingConnections:(TCDevice *)device {
    
}

@end
