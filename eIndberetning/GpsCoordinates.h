//
//  GpsCoordinates.h
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GpsCoordinates : NSObject
@property (nonatomic, strong) CLLocation* loc;
- (NSDictionary *) transformToDictionary;
@end
