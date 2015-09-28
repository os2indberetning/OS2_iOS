//
//  Settings.h
//  OS2Indberetning
//
//  Created by kasper on 9/28/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SavedReport.h"

@interface Settings : NSObject
+(void) addSavedReport:(SavedReport * )savedReport;

+(void)removeSavedReport:(SavedReport * )savedReport;

+(NSMutableArray *) getAllSavedReports;
@end
