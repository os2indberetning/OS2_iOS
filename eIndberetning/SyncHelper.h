//
//  SyncHelper.h
//  OS2Indberetning
//
//  Created by kasper on 9/28/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"

@interface SyncHelper : NSObject
+(void) doSync :(void(^)(Profile *, NSArray * ))successCallback withErrorCallback:(void(^)(NSInteger))errorCallback;
@end
