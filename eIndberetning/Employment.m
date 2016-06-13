/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Employment.m
//  eIndberetning
//

#import "Employment.h"
#import "CDEmployment.h"

@implementation Employment

+ (NSArray *) initFromJsonDic:(NSDictionary*)dic;
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for (NSDictionary* employment in dic) {
        Employment* e = [[Employment alloc] init];
        e.employmentPosition = [[employment objectForKey:@"EmploymentPosition"] description];
        e.employmentId = @([[employment objectForKey:@"Id"] integerValue]);
        e.manNr = [[employment objectForKey:@"ManNr"] description];
        if ([e.manNr isEqualToString:@"<null>"] || [e.manNr isEqual:[NSNull null]]) {
            e.manNr = nil;
        }
        
        [array insertObject:e atIndex:0];
    }
    
    return array;
}

+ (NSArray *) initFromCoreDataArray:(NSArray*)CDArray
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity: CDArray.count];
    
    for (CDEmployment *CDe in CDArray)
    {
        Employment* emp = [[Employment alloc] init];
        
        emp.employmentPosition = CDe.employmentposition;
        emp.employmentId = CDe.employmentid;
        emp.manNr = CDe.mannr;
        
        [array insertObject:emp atIndex:0];
    }
    
    return array;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.employmentPosition forKey:@"employmentPosition"];
    [encoder encodeObject:self.employmentId forKey:@"employmentId"];
    [encoder encodeObject:self.manNr forKey:@"manNr"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.employmentPosition = [decoder decodeObjectForKey:@"employmentPosition"];
        self.employmentId = [decoder decodeObjectForKey:@"employmentId"];
        self.manNr = [decoder decodeObjectForKey:@"manNr"];
    }
    return self;
}

- (BOOL)isEqual:(Employment*)object
{
    return([self.employmentPosition isEqualToString:object.employmentPosition] && [self.employmentId isEqualToNumber:object.employmentId] && [self.manNr isEqualToString:object.manNr]);
}
@end
