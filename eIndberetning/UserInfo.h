/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  UserInfo.h
//  eIndberetning
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Employment.h"
#import "Rate.h"
#import "Purpose.h"
#import "Token.h"
#import "AppInfo.h"

@interface UserInfo : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) CLLocation* home_loc;
@property (nonatomic, strong) NSNumber* profileId;

@property (nonatomic, strong) AppInfo* appInfo;
@property (nonatomic, strong) Purpose* last_purpose;
@property (nonatomic, strong) Employment* last_employment;
@property (nonatomic, strong) Rate* last_rate;
@property (nonatomic, strong) Token* token;
@property (nonatomic, strong) NSDate* last_sync_date;

@property (nonatomic, strong) NSString *guId;

+ (id)sharedManager;
-(void)resetInfo;
-(void)saveInfo;
-(void)loadInfo;
-(BOOL)isLastSyncDateNotToday;

@end
