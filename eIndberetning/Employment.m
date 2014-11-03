//
//  Employment.m
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "Employment.h"

@implementation Employment

+ (NSArray *) initFromJsonDic:(NSDictionary*)dic;
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for (NSDictionary* employment in dic) {
        Employment* e = [[Employment alloc] init];
        e.employmentPosition = [[employment objectForKey:@"EmploymentPosition"] description];
        e.employmentId = @([[employment objectForKey:@"id"] integerValue]);
        [array insertObject:e atIndex:0];
    }
    
    return array;
}

@end
