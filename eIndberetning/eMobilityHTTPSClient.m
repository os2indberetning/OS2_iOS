//
//  eMobilityHTTPSClient.m
//  eIndberetning
//
//  Created by Jacob Hansen on 28/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "eMobilityHTTPSClient.h"





@implementation eMobilityHTTPSClient

+ (eMobilityHTTPSClient *)sharedeMobilityHTTPSClient 
{
    static eMobilityHTTPSClient *_eMobilityHTTPSClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _eMobilityHTTPSClient = [[self alloc] init];
    });
    
    return _eMobilityHTTPSClient;
}

+ (NSString*)getErrorString:(NSInteger)errorcode
{
    switch (errorcode) {
        case TokenNotFound:
        {
            return @"Dit token blev ikke fundet på serveren";
            break;
        }
        case TokenAllreadyActivated:
        {
            return @"Dit token er allerede aktiveret";
            break;
        }
            
        default:
            return @"Der opstod en ukendt fejl";
            break;
    }
}

- (void)setBaseUrl:(NSURL *)url
{
    self.sessionManager = [[AFHTTPSessionManager manager] initWithBaseURL:url];
    self.sessionManager.responseSerializer = [JSONResponseSerializerWithData serializer];
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
}

-(void)syncWithTokenString:(NSString*)tokenString withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"TokenString"] = tokenString;
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"dic: %@", myString);
    
    [self.sessionManager POST:@"syncWithToken" parameters:parameters success:succes failure:failure];
}



-(void)getUserDataForToken:(Token*)token withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"guid"] = token.guid;
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"dic: %@", myString);
    
    [self.sessionManager POST:@"UserData" parameters:parameters success:succes failure:failure];
}

- (void)postDriveReport:(DriveReport *)report forToken:(Token*)token withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:[[report transformToDictionary] mutableCopy] forKey:@"DriveReport"];
    [dic setObject:[[token transformToDictionary] mutableCopy] forKey:@"Token"];
    
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"dic: %@", myString);
    
    [self.sessionManager POST:@"SubmitDrive" parameters:dic success:succes failure:failure];
}
@end
