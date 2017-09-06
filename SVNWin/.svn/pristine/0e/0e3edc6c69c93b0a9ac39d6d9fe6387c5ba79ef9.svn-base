//
//  RCApplication.m
//  RemoteControl
//
//  Created by Moshe Berman on 10/1/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "RCApplication.h"

@implementation RCApplication

extern NSString *remoteControlPlayPauseButtonTapped;
extern NSString *remoteControlStopButtonTapped;
extern NSString *remoteControlForwardButtonTapped;
extern NSString *remoteControlBackwardButtonTapped;

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            
            switch (receivedEvent.subtype) {
                    
                case UIEventSubtypeRemoteControlTogglePlayPause:
                    [self postNotificationWithName:remoteControlPlayPauseButtonTapped];
                    break;
                    
                case UIEventSubtypeRemoteControlStop:
                    [self postNotificationWithName:remoteControlStopButtonTapped];
                    break;
                    
                case UIEventSubtypeRemoteControlPreviousTrack:
                    [self postNotificationWithName:remoteControlBackwardButtonTapped];
                    break;
                    
                case UIEventSubtypeRemoteControlNextTrack:
                    [self postNotificationWithName:remoteControlForwardButtonTapped];
                    break;
                    
                default:
                    break;
            }
            
        } else {
            
            switch (receivedEvent.subtype) {
                    
                case UIEventSubtypeRemoteControlPlay:
                    [self postNotificationWithName:remoteControlPlayPauseButtonTapped];
                    break;
                    
                case UIEventSubtypeRemoteControlPause:
                    [self postNotificationWithName:remoteControlPlayPauseButtonTapped];
                    break;
                    
                case UIEventSubtypeRemoteControlStop:
                    [self postNotificationWithName:remoteControlStopButtonTapped];
                    break;
                    
                case UIEventSubtypeRemoteControlNextTrack:
                    [self postNotificationWithName:remoteControlForwardButtonTapped];
                    break;
                    
                case UIEventSubtypeRemoteControlPreviousTrack:
                    [self postNotificationWithName:remoteControlBackwardButtonTapped];
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void)postNotificationWithName:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}


@end
