/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  GPSManager.m
//  eIndberetning
//

#include <UIKit/UIKit.h>
#import "GPSManager.h"
@import QuartzCore;

const double accuracyThreshold = 50.0;
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
    if ([error domain] == kCLErrorDomain) {
        if ([error code] == kCLErrorDenied) {
            [self.delegate onGoingLocationDenied];
        }
    }
    
    NSLog(@"GPS Manager Error : %@", error.localizedDescription);
}

#pragma mark - GPS Handling
- (void)startGPS
{
    if(!self.isRunning)
    {
        if (nil == self.locationManager)
            self.locationManager = [[CLLocationManager alloc] init];
        
        if([self requestAuthorization]){
            self.locationManager.delegate = self;
            //        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestAlwaysAuthorization];
            }
            if([self.locationManager respondsToSelector:@selector(allowsBackgroundLocationUpdates)]){
                self.locationManager.allowsBackgroundLocationUpdates = YES;
            }
            
            self.locationManager.pausesLocationUpdatesAutomatically = YES;
            self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
            
            // Set a movement threshold for new events.
            self.locationManager.distanceFilter = 10; // meters
            
            
            
            [self.locationManager startUpdatingLocation];
            self.isRunning = true;
        }
    }else{
        [self.locationManager startUpdatingLocation];
    }
}

- (void)stopGPS
{
    [self.locationManager stopUpdatingLocation];
    self.isRunning = false;
}

#pragma mark - GPS Permission
- (BOOL)requestAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    // If the status is denied display an alert
    if (status == kCLAuthorizationStatusDenied) {
        NSLog(@" status number: %i", status);
        return NO;
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Not determined status number: %i", status);
        float version = [[UIDevice currentDevice] systemVersion].floatValue;
        if (version >= 8.0)
        {
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestAlwaysAuthorization];
            }
        }
        else
        {
            [self.locationManager startUpdatingLocation];
        }
        return NO;
    }else if(status == kCLAuthorizationStatusAuthorized){
        NSLog(@"Authorized status number: %i", status);
    }else if(status == kCLAuthorizationStatusAuthorizedAlways){
        NSLog(@"Auth Always status number: %i", status);
    }else if(status == kCLAuthorizationStatusRestricted){
        NSLog(@"Restricted status number: %i", status);
    }
    
    return YES;
}

@end
