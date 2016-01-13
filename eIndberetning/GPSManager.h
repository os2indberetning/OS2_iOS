/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  GPSManager.h
//  eIndberetning
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern const double accuracyThreshold;
const double maxDistanceBetweenLocations;

@protocol GPSUpdateDelegate <NSObject>
-(void)gotNewGPSCoordinate:(CLLocation*)location;
-(void)showGPSPermissionDenied;

@optional
-(void)didUpdatePrecision:(float)precision;

@end

@interface GPSManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic) BOOL isRunning;

+ (GPSManager *)sharedGPSManager;
- (void)startGPS;
- (void)stopGPS;


@property (strong,nonatomic) id <GPSUpdateDelegate> delegate;
@end
