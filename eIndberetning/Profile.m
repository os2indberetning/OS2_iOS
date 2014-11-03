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
    
    CLLocation* homeLoc = [[CLLocation alloc] initWithLatitude:[[dic objectForKey:@"HomeLatitude"] doubleValue] longitude:[[dic objectForKey:@"HomeLongitude"] doubleValue]];
    p.homeCoordinate = homeLoc;
    
    p.token = [Token initFromJsonDic:[dic objectForKey:@"token"]];
    p.employments = [Employment initFromJsonDic:[dic objectForKey:@"Employments"]];
    
    return p;
}

@end
