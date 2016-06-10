/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  DriveReport.h
//  eIndberetning
//

#import <Foundation/Foundation.h>
#import "Rate.h"
#import "Employment.h"
#import "Route.h"
#import "Purpose.h"

@interface DriveReport : NSObject
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic, strong) Purpose* purpose;
@property (nonatomic, strong) NSString* manuelentryremark;

@property (nonatomic) BOOL fourKmRule;
@property (nonatomic) BOOL didstarthome;
@property (nonatomic) BOOL didendhome;
@property (nonatomic) BOOL shouldReset;

@property (nonatomic, strong) NSNumber* profileId;

@property (nonatomic, strong) Rate* rate;
@property (nonatomic, strong) Employment* employment;
@property (nonatomic, strong) Route* route;

- (NSDictionary *) transformToDictionary;

@end
