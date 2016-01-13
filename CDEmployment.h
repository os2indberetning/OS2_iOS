/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  CDEmployment.h
//  eIndberetning
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDEmployment : NSManagedObject

@property (nonatomic, retain) NSString * employmentposition;
@property (nonatomic, retain) NSNumber * employmentid;

@end
