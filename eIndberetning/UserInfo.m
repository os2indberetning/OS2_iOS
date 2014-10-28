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
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.home_loc forKey:@"home_loc"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.token = [decoder decodeObjectForKey:@"token"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.home_loc = [decoder decodeObjectForKey:@"home_loc"];
    }
    return self;
}

@end
