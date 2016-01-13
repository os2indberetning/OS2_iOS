/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Purpose.m
//  eIndberetning
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
