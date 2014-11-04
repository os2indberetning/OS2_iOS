//
//  Purpose.m
//  eIndberetning
//
//  Created by Jacob Hansen on 04/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "Purpose.h"
#import "CDPurpose.h"

@implementation Purpose

+ (NSArray *) initFromCoreDataArray:(NSArray*)CDArray
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity: CDArray.count];
    
    for (CDPurpose *CDp in CDArray)
    {
        Purpose* purpose = [[Purpose alloc] init];
        
        purpose.purpose = CDp.purpose;
        purpose.lastusedate = CDp.lastusedate;
        
        [array insertObject:purpose atIndex:0];
    }
    
    return array;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.purpose forKey:@"purpose"];
    [encoder encodeObject:self.lastusedate forKey:@"lastusedate"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.purpose = [decoder decodeObjectForKey:@"purpose"];
        self.lastusedate = [decoder decodeObjectForKey:@"lastusedate"];
    }
    return self;
}

- (BOOL)isEqual:(Purpose*)object
{
    return([self.purpose isEqualToString:object.purpose]);
}
@end
