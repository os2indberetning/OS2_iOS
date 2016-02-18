/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  UserInfo.m
//  eIndberetning
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

-(void)resetInfo
{
    self.name = nil;
    self.home_loc = nil;
    self.profileId = nil;
    self.appInfo = nil;
    
    self.last_purpose = nil;
    self.last_employment = nil;
    self.last_rate = nil;
    self.last_sync_date = nil;
    
    self.authorization = nil;
    [self saveInfo];
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
    
    self.name = object.name;
    self.home_loc = object.home_loc;
    self.profileId = object.profileId;
    
    self.appInfo = object.appInfo;
    
    self.last_purpose = object.last_purpose;
    self.last_employment = object.last_employment;
    self.last_rate = object.last_rate;
    
    self.last_sync_date = object.last_sync_date;
    
    self.authorization = object.authorization;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.home_loc forKey:@"home_loc"];
    [encoder encodeObject:self.profileId forKey:@"profile_id"];
    [encoder encodeObject:self.appInfo forKey:@"appinfo"];
    
    [encoder encodeObject:self.last_purpose forKey:@"last_purpose"];
    [encoder encodeObject:self.last_employment forKey:@"last_employment"];
    [encoder encodeObject:self.last_rate forKey:@"last_rate"];
    
    [encoder encodeObject:self.last_sync_date forKey:@"last_sync_date"];
    
    [encoder encodeObject:self.authorization forKey:@"authorization"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"name"];
        self.home_loc = [decoder decodeObjectForKey:@"home_loc"];
        self.profileId = [decoder decodeObjectForKey:@"profile_id"];
        self.appInfo = [decoder decodeObjectForKey:@"appinfo"];
        
        self.last_purpose = [decoder decodeObjectForKey:@"last_purpose"];
        self.last_employment = [decoder decodeObjectForKey:@"last_employment"];
        self.last_rate = [decoder decodeObjectForKey:@"last_rate"];
        
        self.last_sync_date = [decoder decodeObjectForKey:@"last_sync_date"];
        
        self.authorization = [decoder decodeObjectForKey:@"authorization"];
    }
    return self;
}

@end
