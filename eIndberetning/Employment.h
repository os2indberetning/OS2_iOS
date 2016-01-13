/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Employment.h
//  eIndberetning
//

#import <Foundation/Foundation.h>

@interface Employment : NSObject
@property (nonatomic, strong) NSString* employmentPosition;
@property (nonatomic, strong) NSNumber* employmentId;

+ (NSArray *) initFromJsonDic:(NSDictionary*)dic;
+ (NSArray *) initFromCoreDataArray:(NSArray*)CDArray;
@end
