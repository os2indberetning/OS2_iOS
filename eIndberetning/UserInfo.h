//
//  UserInfo.h
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Employment.h"
#import "Rate.h"
#import "Purpose.h"

@interface UserInfo : NSObject
@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) CLLocation* home_loc;
@property (nonatomic, strong) NSNumber* profileId;


@property (nonatomic, strong) Purpose* last_purpose;
@property (nonatomic, strong) Employment* last_employment;
@property (nonatomic, strong) Rate* last_rate;

@property (nonatomic, strong) NSDate* last_sync_date;

+ (id)sharedManager;
-(void)saveInfo;
-(void)loadInfo;
-(BOOL)isLastSyncDateNotToday;

@end
