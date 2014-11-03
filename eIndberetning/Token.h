//
//  Token.h
//  eIndberetning
//
//  Created by Jacob Hansen on 03/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Token : NSObject

@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) NSString* status;

+ (Token *) initFromJsonDic:(NSDictionary*)dic;

@end
