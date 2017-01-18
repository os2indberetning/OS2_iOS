/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Route.m
//  eIndberetning
//

#import "Route.h"
#import "GpsCoordinates.h"

@implementation Route

-(NSMutableArray*)coordinates
{
    if(_coordinates == nil)
        _coordinates = [[NSMutableArray alloc] init];
    
    return _coordinates;
}

- (NSDictionary *) transformToDictionary
{
    NSMutableArray *gpsArray = [[NSMutableArray alloc] initWithCapacity:[self.coordinates count]];
    
    for (int i = 0; i < [self.coordinates count]; i++) {
        GpsCoordinates *g = [self.coordinates objectAtIndex:i];
        [gpsArray addObject:[g transformToDictionary]];
    }
    
    NSString* totalDistanceEdit = @"";
    if ([self.totalDistanceEdit doubleValue] < 0.1) {
        totalDistanceEdit = @"0.0";
    } else {
        totalDistanceEdit = [self.totalDistanceEdit stringValue];
    }
    
    NSDictionary *body = [NSMutableDictionary
                                 dictionaryWithObjectsAndKeys:
                                 totalDistanceEdit, @"TotalDistance",
                                 gpsArray, @"GPSCoordinates", nil];
    
    return body;
}


-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.totalDistanceMeasure forKey:@"totalDistanceMeasure"];
    [encoder encodeObject:self.totalDistanceEdit forKey:@"totalDistanceEdit"];
    [encoder encodeObject:self.coordinates forKey:@"coordinates"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.totalDistanceMeasure = [decoder decodeObjectForKey:@"totalDistanceMeasure"];
        self.totalDistanceEdit = [decoder decodeObjectForKey:@"totalDistanceEdit"];
        self.coordinates = [decoder decodeObjectForKey:@"coordinates"];
    }
    return self;
}

@end
