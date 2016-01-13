/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  GPSManager.m
//  eIndberetning
//

#import "GPSManager.h"
@import QuartzCore;

const double accuracyThreshold = 100.0;
const double maxDistanceBetweenLocations = 200.0;

@interface GPSManager ()

@property (strong, nonatomic) CLLocationManager* locationManager;

@end

@implementation GPSManager


+ (GPSManager *)sharedGPSManager
{
    static GPSManager *_sharedGPSManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedGPSManager = [[self alloc] init];
    });
    
    return _sharedGPSManager;
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    
    if([self.delegate respondsToSelector:@selector(didUpdatePrecision:)])
    {
        [self.delegate didUpdatePrecision:location.horizontalAccuracy];
    }
    
    [self.delegate gotNewGPSCoordinate:location];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //TODO: Should we start timer here?
    NSLog(@"%@", error.localizedDescription);
}

#pragma mark - GPS Handling
- (void)startGPS
{
    if(!self.isRunning)
    {
        if (nil == self.locationManager)
            self.locationManager = [[CLLocationManager alloc] init];
        
        [self requestAuthorization];
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
        self.locationManager.pausesLocationUpdatesAutomatically = YES;
        self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        
        // Set a movement threshold for new events.
        self.locationManager.distanceFilter = 10; // meters
        
        [self.locationManager startUpdatingLocation];
        self.isRunning = true;
        
        
    }
}

- (void)stopGPS
{
    [self.locationManager stopUpdatingLocation];
    self.isRunning = false;
}

#pragma mark - GPS Permission
- (void)requestAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied display an alert
    if (status == kCLAuthorizationStatusDenied) {
        
        [self.delegate showGPSPermissionDenied];

    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
}

@end
