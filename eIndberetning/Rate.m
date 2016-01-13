/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Rate.m
//  eIndberetning
//

#import "Rate.h"
#import "CDRate.h"

@implementation Rate

+ (NSArray *) initFromJsonDic:(NSDictionary*)dic;
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    NSDateFormatter *ydf = [[NSDateFormatter alloc] init];
    [ydf setDateFormat:@"yyyy"];
    
    for (NSDictionary* rate in dic) {
        Rate* r = [[Rate alloc] init];
        
        NSString *year = [[rate objectForKey:@"Year"] description];
        r.year = [ydf dateFromString:year ];
        
        //Only show rates from this year
        if([[ydf stringFromDate:r.year] isEqualToString:[ydf stringFromDate:[NSDate date]]])
        {
            r.rateid = @([[rate objectForKey:@"Id"] integerValue]);
            r.rateDescription = [[rate objectForKey:@"Description"] description];
            [array insertObject:r atIndex:0];
        }
    }
    
    return array;
}

+ (NSArray *) initFromCoreDataArray:(NSArray*)CDArray
{
    
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity: CDArray.count];
 
    NSDateFormatter *ydf = [[NSDateFormatter alloc] init];
    [ydf setDateFormat:@"yyyy"];
    
    for (CDRate *CDr in CDArray)
    {
        
        Rate* rate = [[Rate alloc] init];
        
        rate.year = CDr.year;
        
        //Only show rates from this year
        if([[ydf stringFromDate:rate.year] isEqualToString:[ydf stringFromDate:[NSDate date]]])
        {
            rate.rateDescription = CDr.rateDescription;
            rate.rateid = CDr.rateid;
            [array insertObject:rate atIndex:0];
        }
    }
    
    return array;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.rateid forKey:@"rateid"];
    [encoder encodeObject:self.rateDescription forKey:@"type"];
    [encoder encodeObject:self.year forKey:@"year"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.rateid = [decoder decodeObjectForKey:@"rateid"];
        self.rateDescription = [decoder decodeObjectForKey:@"type"];
        self.year = [decoder decodeObjectForKey:@"year"];
    }
    return self;
}

- (BOOL)isEqual:(Rate*)object
{
    return(
           [self.rateDescription isEqualToString:object.rateDescription] &&
           [self.rateid isEqualToNumber:object.rateid] &&
           [self.year isEqualToDate:object.year]);
}
@end
