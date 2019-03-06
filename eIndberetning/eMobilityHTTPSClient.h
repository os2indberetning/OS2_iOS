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
#import "SavedReport.h"
#import "Authorization.h"

enum ErrorCodes : NSInteger
{
    //TODO: Change enum Names to reflect guId instead of Token
    UnknownError = 600,
    SaveError = 640,
    BadPassword = 650,
    UserNotFound = 660
};

@protocol WeatherHTTPClientDelegate;


@interface eMobilityHTTPSClient : NSObject

@property (nonatomic, strong) AFHTTPSessionManager* sessionManager;

+ (eMobilityHTTPSClient *)sharedeMobilityHTTPSClient;

- (void)setBaseUrl:(NSURL *)url;

-(void)getUserInfoForGuId:(Authorization *) auth withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))success failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

-(void)credentialsLogin:(NSString*)username password:(NSString*)password withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))success failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

- (void)postDriveReport:(DriveReport *)report forAuthorization:(Authorization*)auth withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

-(void)postSavedDriveReport:(SavedReport *)report forAuthorization:(Authorization*)auth withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

@end
