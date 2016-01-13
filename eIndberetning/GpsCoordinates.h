/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  GpsCoordinates.h
//  eIndberetning
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GpsCoordinates : NSObject
@property (nonatomic, strong) CLLocation* loc;
@property (nonatomic) BOOL isViaPoint;
- (NSDictionary *) transformToDictionary;
@end
