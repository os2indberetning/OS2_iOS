//
//  UserInfo.h
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UserInfo : NSObject
@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) CLLocation* home_loc;

+ (id)sharedManager;
-(void)saveInfo;
-(void)loadInfo;
@end
