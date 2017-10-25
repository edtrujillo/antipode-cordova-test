//
//  antipode.m
//  CurrentLocation
//
//  Created by Edmund Trujillo on 10/25/17.
//  Copyright © 2017 Edmund Trujillo. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "antipode.h"
#import "AntiPodeLocation.h"

@interface antipode() <AntiPodLocationDelegate>
@property (nonatomic, strong) AntiPodeLocation *antiPodeLocation;
@end

@implementation antipode

- (void)fetchAntiPode:(CDVInvokedUrlCommand *)command
{
    self.antiPodeLocation = [[AntiPodeLocation alloc] init];
    self.antiPodeLocation.delegate = self;
    [self.antiPodeLocation beginQueryingLocationAndAskForPermission];
}

#pragma mark <AntiPodeDelegate>

- (void)locationUpdated
{
    [self.antiPodeLocation stopQueryingLocation];
    NSString *antiPodeString = [NSString stringWithFormat:@"%f, %f",
                                 self.antiPodeLocation.location.latitude,
                                 self.antiPodeLocation.location.longitude];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:antiPodeString];
    [self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];
}

@end
