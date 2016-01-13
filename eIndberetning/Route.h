/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Route.h
//  eIndberetning
//

#import <Foundation/Foundation.h>

@interface Route : NSObject
@property (nonatomic, strong) NSNumber* totalDistanceMeasure;
@property (nonatomic, strong) NSNumber* totalDistanceEdit;
@property BOOL distanceWasEdited;

@property (nonatomic, strong) NSMutableArray* coordinates;

- (NSDictionary *) transformToDictionary;

@end
