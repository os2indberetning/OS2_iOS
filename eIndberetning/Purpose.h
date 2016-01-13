/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Purpose.h
//  eIndberetning
//

#import <Foundation/Foundation.h>

@interface Purpose : NSObject

@property (nonatomic, strong) NSDate * lastusedate;
@property (nonatomic, strong) NSString * purpose;

+ (NSArray *) initFromCoreDataArray:(NSArray*)CDArray;

@end
