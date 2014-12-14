//
//  JSONResponseSerializerWithData.m
//  eIndberetning
//
//  Created by Jacob Hansen on 13/12/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
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