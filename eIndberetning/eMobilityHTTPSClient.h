//
//  eMobilityHTTPSClient.h
//  eIndberetning
//
//  Created by Jacob Hansen on 28/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <CoreLocation/CoreLocation.h>

@protocol WeatherHTTPClientDelegate;


@interface eMobilityHTTPSClient : AFHTTPSessionManager
@property (nonatomic, weak) id<WeatherHTTPClientDelegate>delegate;

+ (eMobilityHTTPSClient *)sharedWeatherHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)updateWeatherAtLocation:(CLLocation *)location forNumberOfDays:(NSUInteger)number;

@end

@protocol WeatherHTTPClientDelegate <NSObject>
@optional
-(void)weatherHTTPClient:(eMobilityHTTPSClient *)client didUpdateWithWeather:(id)weather;
-(void)weatherHTTPClient:(eMobilityHTTPSClient *)client didFailWithError:(NSError *)error;
@end
