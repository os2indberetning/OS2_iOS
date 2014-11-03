//
//  Rate.m
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "Rate.h"

@implementation Rate

+ (NSArray *) initFromJsonDic:(NSDictionary*)dic;
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for (NSDictionary* rate in dic) {
        Rate* r = [[Rate alloc] init];
        
        r.kmrate = @([[rate objectForKey:@"KmRate"] integerValue]);
        r.tfcode = @([[rate objectForKey:@"TFCode"] integerValue]);
        r.rateid = @([[rate objectForKey:@"id"] integerValue]);
        
        r.type = [[rate objectForKey:@"Type"] description];
        [array insertObject:r atIndex:0];
    }
    
    return array;
}
@end
