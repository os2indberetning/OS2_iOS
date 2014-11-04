//
//  DriveReport.h
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rate.h"
#import "Employment.h"
#import "Route.h"
#import "Purpose.h"

@interface DriveReport : NSObject
@property (nonatomic,strong) NSDate *date;
@property (nonatomic, strong) Purpose* purpose;
@property (nonatomic, strong) NSString* manuelentryremark;

@property (nonatomic) BOOL didstarthome;
@property (nonatomic) BOOL didendhome;
@property (nonatomic) BOOL shouldReset;

@property (nonatomic, strong) Rate* rate;
@property (nonatomic, strong) Employment* employment;
@property (nonatomic, strong) Route* route;

- (NSDictionary *) transformToDictionary;

@end
