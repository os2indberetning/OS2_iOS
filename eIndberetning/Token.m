//
//  Token.m
//  eIndberetning
//
//  Created by Jacob Hansen on 03/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "Token.h"

@implementation Token

+ (Token *) initFromJsonDic:(NSDictionary*)dic
{
    Token *t = [[Token alloc] init];
    
    t.token = [[dic objectForKey:@"TokenString"] description];
    t.status = [[dic objectForKey:@"Status"] description];

    return t;
}

@end
