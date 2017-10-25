//
//  AntiPodeLocation.h
//  CurrentLocation
//
//  Created by Edmund Trujillo on 10/25/17.
//  Copyright © 2017 Edmund Trujillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol AntiPodLocationDelegate
- (void)locationUpdated;
@end

@interface AntiPodeLocation : NSObject

@property (readonly, assign) CLLocationCoordinate2D location;
@property (readonly, assign) CLLocationCoordinate2D antipodeLocation;
@property (weak, nonatomic) id <AntiPodLocationDelegate> delegate;

- (void)beginQueryingLocationAndAskForPermission;
- (void)stopQueryingLocation;

@end
