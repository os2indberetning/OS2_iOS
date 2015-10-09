//
//  Token.h
//  eIndberetning
//
//  Created by Jacob Hansen on 03/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Token : NSObject

@property (nonatomic, strong) NSString* guid;
@property (nonatomic, strong) NSString* tokenString;
@property (nonatomic, strong) NSString* status;

+ (NSArray *) initFromJsonDic:(NSDictionary*)dic;
- (NSDictionary *) transformToDictionary;
 

@end
