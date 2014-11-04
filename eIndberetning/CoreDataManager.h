//
//  CoreDataManader.h
//  eIndberetning
//
//  Created by Jacob Hansen on 04/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CDEmployment.h"
#import "CDRate.h"
#import "Employment.h"
#import "Rate.h"
#import "CDPurpose.h"
#import "Purpose.h"

@interface CoreDataManager : NSObject

+ (CoreDataManager *)sharedeCoreDataManager;
- (void) deleteAllObjects: (NSString *) entityDescription;
- (void) insertEmployments: (NSArray*)employments;
- (void) insertRates: (NSArray*) rates;
- (void) insertPurpose: (Purpose*)purpose;
- (void) updatePurpose:(Purpose*)purpose;

-( void)saveContext;

- (NSArray *) fetchEmployments;
- (NSArray *) fetchRates;
- (NSArray *) fetchPurposes;

@end
