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
-(void)getUserDataWithBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;
- (void)updateWeatherAtLocation:(CLLocation *)location forNumberOfDays:(NSUInteger)number;
- (void)postDriveReport:(DriveReport *)report forToken:(NSString*)token withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;
@end

@protocol WeatherHTTPClientDelegate <NSObject>
@optional
-(void)weatherHTTPClient:(eMobilityHTTPSClient *)client didUpdateWithWeather:(id)weather;
-(void)weatherHTTPClient:(eMobilityHTTPSClient *)client didFailWithError:(NSError *)error;
@end
