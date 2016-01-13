/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  Settings.m
//  OS2Indberetning
//

#import "Settings.h"
#import "SavedReport.h"

#define kSAVED_REPORTS_INDEX @"kSAVED_REPORTS_INDEX"

@implementation Settings




+(void) addSavedReport:(SavedReport * )report{
    NSMutableArray * arr =  [Settings getAllSavedReports];
    [arr addObject:report];
    NSUserDefaults * instance = [NSUserDefaults standardUserDefaults];
    [instance setValue:[SavedReport saveArrayToJson:arr] forKey:kSAVED_REPORTS_INDEX];
}

+(void)removeSavedReport:(SavedReport * )report{
    NSMutableArray * arr = [Settings getAllSavedReports];
    [arr removeObject:report];
    NSUserDefaults * instance = [NSUserDefaults standardUserDefaults];
    [instance setValue:[SavedReport saveArrayToJson:arr] forKey:kSAVED_REPORTS_INDEX];
}

+(NSMutableArray *) getAllSavedReports{
    NSUserDefaults * instance = [NSUserDefaults standardUserDefaults];
    NSString* json = [instance stringForKey:kSAVED_REPORTS_INDEX];
    NSMutableArray * arr =  [SavedReport parseAllFromJson:json];
    if(arr==nil){
        return [NSMutableArray new];
    }else{
        return arr;
    }
}

@end
