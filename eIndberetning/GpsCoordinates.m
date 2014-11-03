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
    //TODO: Change this!
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *timeString = [dateFormatter stringFromDate:self.loc.timestamp];
    
    NSDictionary *body = [NSMutableDictionary
                                 dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%f",self.loc.coordinate.latitude], @"lat", [NSString stringWithFormat:@"%f",self.loc.coordinate.longitude], @"lng",
                                 timeString, @"time", nil];
    
    return body;
}

@end
