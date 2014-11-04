//
//  Rate.h
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rate : NSObject
@property (nonatomic, strong) NSDate* year;
@property (nonatomic, strong) NSNumber* kmrate;
@property (nonatomic,strong) NSNumber* tfcode;
@property (nonatomic,strong) NSNumber* rateid;
@property (nonatomic, strong) NSString* type;

+ (NSArray *) initFromJsonDic:(NSDictionary*)dic;
+ (NSArray *) initFromCoreDataArray:(NSArray*)CDArray;

@end
