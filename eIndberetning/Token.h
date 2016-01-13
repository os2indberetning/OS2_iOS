/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Token.h
//  eIndberetning
//

#import <Foundation/Foundation.h>

@interface Token : NSObject

@property (nonatomic, strong) NSString* guid;
@property (nonatomic, strong) NSString* tokenString;
@property (nonatomic, strong) NSString* status;

+ (NSArray *) initFromJsonDic:(NSDictionary*)dic;
- (NSDictionary *) transformToDictionary;
 

@end
