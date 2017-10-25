//
//  AntiPodeLocation.m
//  CurrentLocation
//
//  Created by Edmund Trujillo on 10/25/17.
//  Copyright © 2017 Edmund Trujillo. All rights reserved.
//

#import "AntiPodeLocation.h"

static const CLLocationAccuracy kGoodEnoughAccuracy = 100.0f;  // in meters

@interface AntiPodeLocation() <CLLocationManagerDelegate>
@property (assign, readwrite) CLLocationCoordinate2D location;
@property (assign, readwrite) CLLocationCoordinate2D antipodeLocation;
@end

@implementation AntiPodeLocation {
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _sufficientLocation;
}

- (instancetype) init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _sufficientLocation = kCLLocationCoordinate2DInvalid;
    }
    
    return self;
}

- (void)beginQueryingLocationAndAskForPermission {
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}

- (void)stopQueryingLocation {
    [_locationManager stopUpdatingLocation];
}

# pragma mark - Private

- (void)updateLocationProperty {
    
    CLAuthorizationStatus authStatus = [[CLLocationManager class] authorizationStatus];
    if (authStatus == kCLAuthorizationStatusRestricted
        || authStatus == kCLAuthorizationStatusDenied)
    {
        self.location = kCLLocationCoordinate2DInvalid;
        self.antipodeLocation = kCLLocationCoordinate2DInvalid;
        if (self.delegate) {
            [self.delegate locationUpdated];
        }
        return;
    }
    
    // Otherwise, if we have a solid location, use it.
    if (CLLocationCoordinate2DIsValid(_sufficientLocation)) {
        self.location = _sufficientLocation;
        self.antipodeLocation = [self antipode:self.location];
        if (self.delegate) {
            [self.delegate locationUpdated];
        }
        return;
    }
}

- (CLLocationCoordinate2D)antipode:(CLLocationCoordinate2D)location {
    
    /* If the geographic coordinates (latitude and longitude) of a point on the Earth's surface are (φ, θ), then the coordinates of the antipodal point are (−φ, θ ± 180°). This relation holds true whether the Earth is approximated as a perfect sphere or as a reference ellipsoid.
     */
    
    double sign = -1;
    if (location.longitude < 0) {
        sign = 1;
    }
    
    return CLLocationCoordinate2DMake(-location.latitude, location.longitude + sign * 180.);
}

# pragma mark - Helper 'locationKnown' property

- (BOOL)locationKnown {
    return CLLocationCoordinate2DIsValid(self.location);
}

# pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status != kCLAuthorizationStatusNotDetermined)
        [self updateLocationProperty];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied)
        [manager stopUpdatingLocation];
    
    [self updateLocationProperty];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (newLocation.horizontalAccuracy <= kGoodEnoughAccuracy) {
        _sufficientLocation = newLocation.coordinate;
        [manager stopUpdatingLocation];
        manager.delegate = nil;
        [self updateLocationProperty];
    }
}


@end
