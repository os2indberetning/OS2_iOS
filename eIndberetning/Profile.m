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
    
    p.FirstName = [[dic objectForKey:@"Firstname"] description];
    p.LastName = [[dic objectForKey:@"Lastname"] description];
    
    
    
    if([[dic objectForKey:@"HomeLatitude"] respondsToSelector:@selector (floatValue)]  && [[dic objectForKey:@"HomeLongitude"] respondsToSelector:@selector (floatValue)])
    {
        
        NSNumber *lat = [dic valueForKey:@"HomeLatitude"];
        NSNumber *lng = [dic valueForKey:@"HomeLongitude"];
        
        CLLocation* homeLoc = [[CLLocation alloc] initWithLatitude:[lat floatValue] longitude:[lng floatValue]];
        p.homeCoordinate = homeLoc;
    }
    else
    {
        p.homeCoordinate = nil;
    }
    
    p.tokens = [Token initFromJsonDic:[dic objectForKey:@"Tokens"]];
    p.employments = [Employment initFromJsonDic:[dic objectForKey:@"Employments"]];
    
    p.profileId = @([[dic objectForKey:@"Id"] integerValue]);
    return p;
}

@end
