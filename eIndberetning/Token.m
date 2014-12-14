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
