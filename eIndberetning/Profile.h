//
//  Profile.h
//  eIndberetning
//
//  Created by Jacob Hansen on 03/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Token.h"

@interface Profile : NSObject

@property (nonatomic, strong) NSString* FirstName;
@property (nonatomic, strong) NSString* LastName;

@property (nonatomic, strong) CLLocation* homeCoordinate;
@property (nonatomic, strong) Token* token;
@property (nonatomic, strong) NSArray* employments;
@property (nonatomic, strong) NSNumber* profileId;

+ (Profile *) initFromJsonDic:(NSDictionary*)dic;

@end
