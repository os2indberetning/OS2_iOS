/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  SyncHelper.m
//  OS2Indberetning
//

#import "SyncHelper.h"
#import "UserInfo.h"
#import "eMobilityHTTPSClient.h"
#import "Profile.h"
#import "Rate.h"

@interface SyncHelper ()

@end

@implementation SyncHelper

+(void) doSync :(void(^)(Profile *, NSArray * ))successCallback withErrorCallback:(void(^)(NSError*))errorCallback
{
    UserInfo* info = [UserInfo sharedManager];
    eMobilityHTTPSClient*  client = [eMobilityHTTPSClient sharedeMobilityHTTPSClient];

    [client getUserInfoForGuId:info.authorization withBlock:^(NSURLSessionTask *task, id resonseObject)
      {
          NSLog(@"Sync userInfo response: %@", resonseObject);
 
          NSDictionary *profileDic = [resonseObject objectForKey:@"profile"];
          NSDictionary *rateDic = [resonseObject objectForKey:@"rates"];
 
          successCallback([Profile initFromJsonDic:profileDic], [Rate initFromJsonDic:rateDic]);
      } failBlock:^(NSURLSessionTask * task, NSError *error) {
          errorCallback(error);
      }];
}

@end
