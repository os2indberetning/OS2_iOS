/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  SyncHelper.h
//  OS2Indberetning
//

#import <Foundation/Foundation.h>
#import "Profile.h"

@interface SyncHelper : NSObject
+(void) doSync :(void(^)(Profile *, NSArray * ))successCallback withErrorCallback:(void(^)(NSInteger))errorCallback;
@end
