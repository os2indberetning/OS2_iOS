/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Authorization.m
//  OS2Indberetning
//


#import "Authorization.h"

@implementation Authorization

+(Authorization *) initFromJsonDic:(NSDictionary *) dic {
    Authorization *auth = [[Authorization alloc] init];
    
    auth.guId = [[dic objectForKey:@"GuId"] description];
    
    return auth;
}

-(NSDictionary *) transformGuIdToDictionary {
    NSDictionary *authDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.guId, @"GuId", nil];
    
    return authDic;
}

- (BOOL) isEqual:(Authorization*)object{
    return ([self.guId isEqualToString:object.guId]);
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.guId forKey:@"GuId"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.guId = [decoder decodeObjectForKey:@"GuId"];
    }
    return self;
}

@end
