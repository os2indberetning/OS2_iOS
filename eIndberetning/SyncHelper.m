//
//  SyncHelper.m
//  OS2Indberetning
//
//  Created by kasper on 9/28/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
//

#import "SyncHelper.h"
#import "UserInfo.h"
#import "eMobilityHTTPSClient.h"
#import "Profile.h"
#import "Rate.h"

@interface SyncHelper ()

@end

@implementation SyncHelper

+(void) doSync :(void(^)(Profile *, NSArray * ))successCallback withErrorCallback:(void(^)(NSInteger))errorCallback
{
    UserInfo* info = [UserInfo sharedManager];
    eMobilityHTTPSClient*  client = [eMobilityHTTPSClient sharedeMobilityHTTPSClient];

    [client getUserDataForToken:info.token withBlock:^(NSURLSessionTask *task, id resonseObject)
     {
         NSLog(@"%@", resonseObject);
         
         NSDictionary *profileDic = [resonseObject objectForKey:@"profile"];
         NSDictionary *rateDic = [resonseObject objectForKey:@"rates"];
         
         successCallback([Profile initFromJsonDic:profileDic], [Rate initFromJsonDic:rateDic]);
       /*  safeSelf.profile = [Profile initFromJsonDic:profileDic];
         safeSelf.rates = [Rate initFromJsonDic:rateDic];
         
         if([[NSDate date] timeIntervalSinceDate:safeSelf.syncStartTime] > MIN_WAIT_TIME_S)
         {
             [safeSelf succesSync];
         }
         else
         {
             [NSTimer scheduledTimerWithTimeInterval:MIN_WAIT_TIME_S-[[NSDate date] timeIntervalSinceDate:safeSelf.syncStartTime]  target:safeSelf selector:@selector(succesSync) userInfo:nil repeats:NO];
         }*/
         
     } failBlock:^(NSURLSessionTask * task, NSError *Error) {
         NSLog(@"%@", Error);
         
         NSInteger errorCode = [Error.userInfo[ErrorCodeKey] intValue];
         errorCallback(errorCode);
      //   [safeSelf failSyncWithErrorCode:(NSInteger)errorCode];
         
     }];
}

@end
