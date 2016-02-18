/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Authorization.h
//  OS2Indberetning
//


#import <Foundation/Foundation.h>

@interface Authorization : NSObject

@property (nonatomic, strong) NSString* guId;

+(Authorization *) initFromJsonDic:(NSDictionary *)dic;
-(NSDictionary *) transformGuIdToDictionary;

@end
