//
//  Settings.m
//  OS2Indberetning
//
//  Created by kasper on 9/28/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
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
