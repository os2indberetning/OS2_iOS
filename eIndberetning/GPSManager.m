//
//  GPSManager.m
//  eIndberetning
//
//  Created by Jacob Hansen on 26/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "GPSManager.h"


@interface GPSManager ()
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (nonatomic) BOOL isRunning;
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
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        self.locationManager.pausesLocationUpdatesAutomatically = YES;
        self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        
        // Set a movement threshold for new events.
        self.locationManager.distanceFilter = 50; // meters
        
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
