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
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *timeString = [dateFormatter stringFromDate:self.loc.timestamp];
    id isVia =  @NO;
    if(self.isViaPoint){
        isVia = @YES;
    }
    
    NSDictionary *body  =
            @{@"Latitude":[NSString stringWithFormat:@"%f",self.loc.coordinate.latitude],
              @"Longitude":[NSString stringWithFormat:@"%f",self.loc.coordinate.longitude],
              @"IsViaPoint": isVia};
    
    return body;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isViaPoint = NO;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.loc forKey:@"loc"];
    [encoder encodeBool:self.isViaPoint forKey:@"isViaPoint"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.loc = [decoder decodeObjectForKey:@"loc"];
        self.isViaPoint = [decoder decodeBoolForKey:@"isViaPoint"];
    }
    return self;
}

@end
