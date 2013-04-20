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

-(id)init {
    if ( self = [super init] ) {
        NSDictionary *params = @{@"clientId": [PFUser currentUser].email};
        [[BMWAPIClient sharedClient] getCapabilityTokenWithParameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *capabilityToken = responseObject[@"capabilityToken"];
            self.device = [[TCDevice alloc] initWithCapabilityToken:capabilityToken delegate:self];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error logging into Twilio: %@", [error localizedDescription]);
        }]; 
    }
    return self;
}

- (void)connectWithConferenceCode:(NSString *)conferenceCode delegate:(id<TCConnectionDelegate>)connectionDelegate {
    [self connectWithParameters:@{@"conferenceCode": conferenceCode} delegate:connectionDelegate];
}

- (void)connectWithParameters:(NSDictionary *)parameters
                     delegate:(id<TCConnectionDelegate>)connectionDelegate {
    self.connection = [self.device connect:parameters delegate:connectionDelegate];
}

- (void)disconnect {
    [self.connection disconnect];
}

- (void)quickCallWithDelegate:(id<TCConnectionDelegate>)connectionDelegate {
    [[BMWAPIClient sharedClient] getNewConferenceWithParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *conferenceCode = responseObject[@"conferenceCode"];
        [self connectWithConferenceCode:conferenceCode delegate:connectionDelegate];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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
