/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  CDPurpose.h
//  eIndberetning
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDPurpose : NSManagedObject

@property (nonatomic, retain) NSDate * lastusedate;
@property (nonatomic, retain) NSString * purpose;

@end
