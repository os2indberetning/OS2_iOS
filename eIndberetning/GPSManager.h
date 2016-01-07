//
//  GPSManager.h
//  eIndberetning
//
//  Created by Jacob Hansen on 26/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern const double accuracyThreshold;
extern const double maxGpsOutageTimeInSeconds;

@protocol GPSUpdateDelegate <NSObject>
-(void)gotNewGPSCoordinate:(CLLocation*)location;
-(void)showGPSPermissionDenied;

@optional
-(void)didUpdatePrecision:(float)precision;

@end

@interface GPSManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic) BOOL isRunning;
@property BOOL shouldWarnUserAboutInaccuracy;

+ (GPSManager *)sharedGPSManager;
- (void)startGPS;
- (void)stopGPS;


@property (strong,nonatomic) id <GPSUpdateDelegate> delegate;
@end
