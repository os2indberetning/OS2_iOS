//
//  Rate.m
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "Rate.h"
#import "CDRate.h"

@implementation Rate

+ (NSArray *) initFromJsonDic:(NSDictionary*)dic;
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for (NSDictionary* rate in dic) {
        Rate* r = [[Rate alloc] init];
        
        r.kmrate = @([[rate objectForKey:@"KmRate"] integerValue]);
        r.tfcode = @([[rate objectForKey:@"TFCode"] integerValue]);
        r.rateid = @([[rate objectForKey:@"Id"] integerValue]);
        
        r.type = [[rate objectForKey:@"Type"] description];
        [array insertObject:r atIndex:0];
    }
    
    return array;
}

+ (NSArray *) initFromCoreDataArray:(NSArray*)CDArray
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity: CDArray.count];
    
    for (CDRate *CDr in CDArray)
    {
        Rate* rate = [[Rate alloc] init];
        
        rate.kmrate = CDr.kmrate;
        rate.tfcode = CDr.tfcode;
        rate.type = CDr.type;
        rate.rateid = CDr.rateid;
        
        [array insertObject:rate atIndex:0];
    }
    
    return array;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.kmrate forKey:@"kmrate"];
    [encoder encodeObject:self.tfcode forKey:@"tfcode"];
    [encoder encodeObject:self.rateid forKey:@"rateid"];
    [encoder encodeObject:self.type forKey:@"type"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.kmrate = [decoder decodeObjectForKey:@"kmrate"];
        self.tfcode = [decoder decodeObjectForKey:@"tfcode"];
        self.rateid = [decoder decodeObjectForKey:@"rateid"];
        self.type = [decoder decodeObjectForKey:@"type"];
    }
    return self;
}

- (BOOL)isEqual:(Rate*)object
{
    return( [self.type isEqualToString:object.type] &&
           [self.kmrate isEqualToNumber:object.kmrate] &&
           [self.tfcode isEqualToNumber:object.tfcode] &&
           [self.rateid isEqualToNumber:object.rateid] );
}
@end
