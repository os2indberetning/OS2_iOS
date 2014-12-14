//
//  JSONResponseSerializerWithData.h
//  eIndberetning
//
//  Created by Jacob Hansen on 13/12/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "AFURLResponseSerialization.h"

/// NSError userInfo key that will contain response data
static NSString * const ErrorCodeKey = @"ErrorCodeKey";

@interface JSONResponseSerializerWithData : AFJSONResponseSerializer
@end