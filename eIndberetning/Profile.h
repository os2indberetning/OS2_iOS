/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Profile.h
//  eIndberetning
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
//#import "Token.h"
#import "Authorization.h"

@interface Profile : NSObject

@property (nonatomic, strong) NSString* FirstName;
@property (nonatomic, strong) NSString* LastName;

@property (nonatomic, strong) CLLocation* homeCoordinate;

//@property (nonatomic, strong) NSArray* tokens;
@property (nonatomic, strong) NSArray* employments;

@property (nonatomic, strong) NSNumber* profileId;

@property (nonatomic, strong) Authorization* authorization;

+ (Profile *) initFromJsonDic:(NSDictionary*)dic;

@end
