/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  CoreDataManader.h
//  eIndberetning
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

- (void) deletePurpose:(Purpose *)purpose;

@end
