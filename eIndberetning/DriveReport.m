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
    
    if(self.manuelentryremark == nil)
        self.manuelentryremark = @"";
    
    NSDictionary *body = [NSMutableDictionary
                          dictionaryWithObjectsAndKeys: dateString, @"Date", self.purpose.purpose, @"Purpose",
                          self.manuelentryremark, @"ManualEntryRemark", @(self.didstarthome), @"didstarthome",
                          @(self.didendhome), @"didendhome", [self.route transformToDictionary], @"route",
                          self.employment.employmentId, @"EmploymentId", self.profileId, @"ProfileId",
                          self.rate.rateid, @"RateId", nil];
    
    return body;
}

@end