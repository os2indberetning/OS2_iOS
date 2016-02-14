/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  eMobilityHTTPSClient.h
//  eIndberetning
//

#import "AFHTTPSessionManager.h"
#import <CoreLocation/CoreLocation.h>
#import "DriveReport.h"
#import "JSONResponseSerializerWithData.h"
#import "Token.h"
#import "SavedReport.h"

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


@interface eMobilityHTTPSClient : NSObject

@property (nonatomic, strong) AFHTTPSessionManager* sessionManager;

+ (eMobilityHTTPSClient *)sharedeMobilityHTTPSClient;
+ (NSString*)getErrorString:(NSInteger)errorcode;

- (void)setBaseUrl:(NSURL *)url;

-(void)getUserDataForToken:(Token*)token withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;
-(void)syncWithTokenString:(NSString*)tokenString withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

-(void)credentialsLogin:(NSString*)username password:(NSString*)password withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))success failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

- (void)postDriveReport:(DriveReport *)report forToken:(Token*)token withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

-(void)postSavedDriveReport:(SavedReport *)report forToken:(Token*)token withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

@end