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

@protocol WeatherHTTPClientDelegate;


@interface eMobilityHTTPSClient : AFHTTPSessionManager
@property (nonatomic, weak) id<WeatherHTTPClientDelegate>delegate;

+ (eMobilityHTTPSClient *)sharedeMobilityHTTPSClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
-(void)getUserDataForGuid:(NSString*)guid withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;
-(void)syncWithToken:(NSString*)token withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;
- (void)postDriveReport:(DriveReport *)report forToken:(NSString*)token withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;
@end