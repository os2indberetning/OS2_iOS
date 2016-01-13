/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Rate.h
//  eIndberetning
//

#import <Foundation/Foundation.h>

@interface Rate : NSObject
@property (nonatomic, strong) NSDate* year;
@property (nonatomic,strong) NSNumber* rateid;
@property (nonatomic, strong) NSString* rateDescription;

+ (NSArray *) initFromJsonDic:(NSDictionary*)dic;
+ (NSArray *) initFromCoreDataArray:(NSArray*)CDArray;

@end
