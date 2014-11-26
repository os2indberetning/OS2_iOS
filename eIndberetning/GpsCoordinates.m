//
//  GpsCoordinates.m
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "GpsCoordinates.h"


@implementation GpsCoordinates

- (NSDictionary *) transformToDictionary
{
    //TODO: reduce data drastically by making timestring, lat, and lng int types...
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeString = [dateFormatter stringFromDate:self.loc.timestamp];
    
    NSDictionary *body = [NSMutableDictionary
                                 dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%f",self.loc.coordinate.latitude], @"Latitude", [NSString stringWithFormat:@"%f",self.loc.coordinate.longitude], @"Longitude",
                                 timeString, @"TimeStamp", nil];
    
    return body;
}

@end
