//
//  UserInfo.m
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (id)sharedManager {
    static UserInfo *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

-(void)saveInfo
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"userinfo"];
    [defaults synchronize];
}

-(void)loadInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"userinfo"];
    UserInfo *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    self.token = object.token;
    self.name = object.name;
    self.home_loc = object.home_loc;
    self.profileId = object.profileId;
    
    self.last_purpose = object.last_purpose;
    self.last_employment = object.last_employment;
    self.last_rate = object.last_rate;
    
    self.last_sync_date = object.last_sync_date;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.home_loc forKey:@"home_loc"];
    [encoder encodeObject:self.profileId forKey:@"profile_id"];
    
    [encoder encodeObject:self.last_purpose forKey:@"last_purpose"];
    [encoder encodeObject:self.last_employment forKey:@"last_employment"];
    [encoder encodeObject:self.last_rate forKey:@"last_rate"];
    
    [encoder encodeObject:self.last_sync_date forKey:@"last_sync_date"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.token = [decoder decodeObjectForKey:@"token"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.home_loc = [decoder decodeObjectForKey:@"home_loc"];
        self.profileId = [decoder decodeObjectForKey:@"profile_id"];
        
        self.last_purpose = [decoder decodeObjectForKey:@"last_purpose"];
        self.last_employment = [decoder decodeObjectForKey:@"last_employment"];
        self.last_rate = [decoder decodeObjectForKey:@"last_rate"];
        
        self.last_sync_date = [decoder decodeObjectForKey:@"last_sync_date"];
    }
    return self;
}

-(BOOL)isLastSyncDateNotToday
{
    NSDate *lastSync = [self.last_sync_date copy];
    NSDate *curDate = [NSDate date];
    
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&lastSync interval:NULL forDate:lastSync];
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&curDate interval:NULL forDate:curDate];
    
    if(!lastSync)
        return true;
    
    NSComparisonResult result = [lastSync compare:curDate];
    if (result == NSOrderedSame) {
        return false;
    } else
    {
        return true;
    }

}

@end
