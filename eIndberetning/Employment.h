//
//  Employment.h
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employment : NSObject
@property (nonatomic, strong) NSString* employmentPosition;
@property (nonatomic, strong) NSNumber* employmentId;

+ (NSArray *) initFromJsonDic:(NSDictionary*)dic;
+ (NSArray *) initFromCoreDataArray:(NSArray*)CDArray;
@end
