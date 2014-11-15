//
//  Profile.m
//  eIndberetning
//
//  Created by Jacob Hansen on 03/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "Profile.h"
#import "Employment.h"
#import "Token.h"

@implementation Profile

+ (Profile *) initFromJsonDic:(NSDictionary*)dic
{
    
    Profile *p = [[Profile alloc] init];
    
    p.FirstName = [[dic objectForKey:@"FirstName"] description];
    p.LastName = [[dic objectForKey:@"LastName"] description];
    
    if([[dic objectForKey:@"HomeLatitude"] respondsToSelector:@selector (doubleValue)]  && [[dic objectForKey:@"HomeLongitude"] respondsToSelector:@selector (doubleValue)])
    {
        CLLocation* homeLoc = [[CLLocation alloc] initWithLatitude:[[dic objectForKey:@"HomeLatitude"] doubleValue] longitude:[[dic objectForKey:@"HomeLongitude"] doubleValue]];
        p.homeCoordinate = homeLoc;
    }
    else
    {
        p.homeCoordinate = nil;
    }
    
    p.tokens = [Token initFromJsonDic:[dic objectForKey:@"Tokens"]];
    p.employments = [Employment initFromJsonDic:[dic objectForKey:@"Employments"]];
    
    p.profileId = @([[dic objectForKey:@"id"] integerValue]);
    return p;
}

@end
