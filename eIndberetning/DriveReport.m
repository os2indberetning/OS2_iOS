//
//  DriveReport.m
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "DriveReport.h"

@implementation DriveReport

- (NSDictionary *) transformToDictionary
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:self.date];
    
    NSDictionary *body = [NSMutableDictionary
                          dictionaryWithObjectsAndKeys: dateString, @"date", self.purpose, @"purpose",
                          self.manuelentryremark, @"manuelentryremark", @(self.didstarthome), @"didstarthome",
                          @(self.didendhome), @"didendhome", [self.route transformToDictionary], @"route", nil];
    
    return body;
}

@end