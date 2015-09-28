//
//  SavedReport.h
//  OS2Indberetning
//
//  Created by kasper on 9/28/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
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