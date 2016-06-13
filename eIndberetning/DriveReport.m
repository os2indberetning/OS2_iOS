/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  DriveReport.m
//  eIndberetning
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
                          dictionaryWithObjectsAndKeys:
                          self.uuid, @"Uuid",
                          dateString, @"Date",
                          self.purpose.purpose, @"Purpose",
                          self.manuelentryremark, @"ManualEntryRemark",
                          @(self.didstarthome), @"StartsAtHome",
                          @(self.didendhome), @"EndsAtHome",
                          @(self.fourKmRule), @"FourKmRule",
                          self.fourKmRuleDistance, @"FourKmRuleDistance",
                          [self.route transformToDictionary], @"Route",
                          self.employment.employmentId, @"EmploymentId",
                          self.profileId, @"ProfileId",
                          self.rate.rateid, @"RateId",
                          nil];
    
    return body;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.purpose forKey:@"purpose"];
    [encoder encodeObject:self.manuelentryremark forKey:@"manuelentryremark"];
    [encoder encodeObject:@(self.didstarthome) forKey:@"didstarthome"];
    
    [encoder encodeObject:@(self.didendhome) forKey:@"didendhome"];
    [encoder encodeObject:@(self.fourKmRule) forKey:@"fourkmrule"];
    [encoder encodeObject:self.fourKmRuleDistance forKey:@"fourkmruledistance"];
    [encoder encodeObject:@(self.shouldReset) forKey:@"shouldReset"];
    [encoder encodeObject:self.profileId forKey:@"profileId"];
    
    [encoder encodeObject:self.rate forKey:@"rate"];
    [encoder encodeObject:self.employment forKey:@"employment"];
    [encoder encodeObject:self.route forKey:@"route"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        
        self.date = [decoder decodeObjectForKey:@"date"];
        self.purpose = [decoder decodeObjectForKey:@"purpose"];
        self.manuelentryremark = [decoder decodeObjectForKey:@"manuelentryremark"];
        self.didstarthome = [[decoder decodeObjectForKey:@"didstarthome"] boolValue];
        
        self.didendhome = [[decoder decodeObjectForKey:@"didendhome"] boolValue];
        self.fourKmRule = [[decoder decodeObjectForKey:@"fourkmrule"] boolValue];
        self.fourKmRuleDistance = [decoder decodeObjectForKey:@"fourkmruledistance"];
        self.shouldReset = [[decoder decodeObjectForKey:@"shouldReset"] boolValue];
        self.profileId = [decoder decodeObjectForKey:@"profileId"];
        
        self.rate = [decoder decodeObjectForKey:@"rate"];
        self.employment = [decoder decodeObjectForKey:@"employment"];
        self.route = [decoder decodeObjectForKey:@"route"];
    }
    return self;
}

@end