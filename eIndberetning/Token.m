/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Token.m
//  eIndberetning
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

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.tokenString forKey:@"TokenString"];
    [encoder encodeObject:self.status forKey:@"Status"];
    [encoder encodeObject:self.guid forKey:@"GuId"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.tokenString = [decoder decodeObjectForKey:@"TokenString"];
        self.status = [decoder decodeObjectForKey:@"Status"];
        self.guid = [decoder decodeObjectForKey:@"GuId"];
    }
    return self;
}

- (BOOL)isEqual:(Token*)object
{
    return( [self.guid isEqualToString:object.guid]);
}

- (NSDictionary *) transformToDictionary
{
    
    NSDictionary *body = [NSMutableDictionary
                          dictionaryWithObjectsAndKeys: self.guid, @"GuId", nil];
    
    return body;
}
@end
