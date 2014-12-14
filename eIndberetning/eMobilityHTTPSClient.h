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
#import "Token.h"

enum ErrorCodes : NSInteger
{
    UnknownError = 600,
    TokenNotFound = 610,
    TokenAllreadyActivated = 620,
    TokenAllreadyExists = 630,
    SaveError = 640,
    BadPassword = 650,
    UserNotFound = 660
};

@protocol WeatherHTTPClientDelegate;


@interface eMobilityHTTPSClient : AFHTTPSessionManager

+ (eMobilityHTTPSClient *)sharedeMobilityHTTPSClient;
+ (NSString*)getErrorString:(NSInteger)errorcode;

- (instancetype)initWithBaseURL:(NSURL *)url;
-(void)getUserDataForToken:(Token*)token withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;
-(void)syncWithTokenString:(NSString*)tokenString withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;
- (void)postDriveReport:(DriveReport *)report forToken:(Token*)token withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

@end