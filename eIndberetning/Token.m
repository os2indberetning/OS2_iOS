//
//  Token.m
//  eIndberetning
//
//  Created by Jacob Hansen on 03/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "Token.h"

@implementation Token


+ (NSArray *) initFromJsonDic:(NSDictionary*)dic
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for (NSDictionary* token in dic) {
        Token *t = [[Token alloc] init];
        t.tokenString = [[token objectForKey:@"TokenString"] description];
        t.status = [[token objectForKey:@"Status"] description];
        t.guid = [[token objectForKey:@"GuId"] description];
        
        [array insertObject:t atIndex:0];
    }
    
    return array;
}

@end
