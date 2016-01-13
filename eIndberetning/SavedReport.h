/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  SavedReport.h
//  OS2Indberetning
//

#import <Foundation/Foundation.h>

// objective c header
@interface SavedReport : NSObject<NSCoding>
@property NSString * jsonToSend;
@property NSString * purpose;
@property NSString * rate;
@property NSNumber * totalDistance;
@property NSDate * createdAt;
+(SavedReport *) parseFromJsonString :(NSString *) jsonString;

+(NSMutableArray* ) parseAllFromJson:(NSString *)json;

-(NSDictionary *)saveToJson;
+(NSString *) saveArrayToJson:(NSArray *)arr;
@end