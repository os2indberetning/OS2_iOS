/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  JSONResponseSerializerWithData.m
//  eIndberetning
//

#import "JSONResponseSerializerWithData.h"
#import "eMobilityHTTPSClient.h"

@implementation JSONResponseSerializerWithData

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    id JSONObject = [super responseObjectForResponse:response data:data error:error];
    if (*error != nil) {
        NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
        if (data == nil) {

            userInfo[ErrorCodeKey] = [NSString stringWithFormat:@"%i", (int)UnknownError];

        } else {

            NSError *e;
            NSDictionary *JSON =
            [NSJSONSerialization JSONObjectWithData: data
                                            options: NSJSONReadingMutableContainers
                                              error: &e];
            
            if(e == nil && JSON[@"ErrorCode"] != nil)
            {
                userInfo[ErrorCodeKey] = JSON[@"ErrorCode"];
            }
            else
            {
                userInfo[ErrorCodeKey] = [NSString stringWithFormat:@"%i", (int)UnknownError];
            }
        }
        NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
        (*error) = newError;
    }
    
    return (JSONObject);
}
@end