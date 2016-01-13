/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Settings.h
//  OS2Indberetning
//

#import <Foundation/Foundation.h>
#import "SavedReport.h"

@interface Settings : NSObject
+(void) addSavedReport:(SavedReport * )savedReport;

+(void)removeSavedReport:(SavedReport * )savedReport;

+(NSMutableArray *) getAllSavedReports;
@end
