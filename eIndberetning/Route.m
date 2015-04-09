//
//  Route.m
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
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
    
    NSDictionary *body = [NSMutableDictionary
                                 dictionaryWithObjectsAndKeys:
                                 self.totalDistanceEdit, @"TotalDistance",
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
