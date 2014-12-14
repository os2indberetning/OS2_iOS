//
//  eMobilityHTTPSClient.h
//  eIndberetning
//
//  Created by Jacob Hansen on 28/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <CoreLocation/CoreLocation.h>
#import "DriveReport.h"
#import "JSONResponseSerializerWithData.h"

enum ErrorCodes : NSInteger {
    UnknownError = 600,
    TokenNotFound = 601,
    TokenAllreadyActivated = 602,
    SaveError = 603
};

@protocol WeatherHTTPClientDelegate;


@interface eMobilityHTTPSClient : AFHTTPSessionManager

+ (eMobilityHTTPSClient *)sharedeMobilityHTTPSClient;
+ (NSString*)getErrorString:(NSInteger)errorcode;

- (instancetype)initWithBaseURL:(NSURL *)url;
-(void)getUserDataForGuid:(NSString*)guid withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;
-(void)syncWithToken:(NSString*)token withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;
- (void)postDriveReport:(DriveReport *)report forGuid:(NSString*)guid withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

@end