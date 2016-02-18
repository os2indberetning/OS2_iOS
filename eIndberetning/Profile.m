/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Profile.m
//  eIndberetning
//

#import "Profile.h"
#import "Employment.h"

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
    
    p.employments = [Employment initFromJsonDic:[dic objectForKey:@"Employments"]];
    
    p.profileId = @([[dic objectForKey:@"Id"] integerValue]);
    
    p.authorization = [Authorization initFromJsonDic:[dic objectForKey:@"Authorization"]];
    
    return p;
}

@end
