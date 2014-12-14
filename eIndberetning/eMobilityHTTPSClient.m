//
//  eMobilityHTTPSClient.m
//  eIndberetning
//
//  Created by Jacob Hansen on 28/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "eMobilityHTTPSClient.h"


static NSString * const baseURL = @"https://ework.favrskov.dk/FavrskovMobilityAPI/api/";

@implementation eMobilityHTTPSClient



+ (eMobilityHTTPSClient *)sharedeMobilityHTTPSClient 
{
    static eMobilityHTTPSClient *_eMobilityHTTPSClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _eMobilityHTTPSClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
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

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [JSONResponseSerializerWithData serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

-(void)syncWithToken:(NSString*)token withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"Token"] = token;
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"dic: %@", myString);
    
    [self POST:@"syncWithToken" parameters:parameters success:succes failure:failure];
}

-(void)getUserDataForGuid:(NSString*)guid withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"guid"] = guid;
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"dic: %@", myString);
    
    [self POST:@"UserData" parameters:parameters success:succes failure:failure];
}

- (void)postDriveReport:(DriveReport *)report forGuid:(NSString*)guid withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure
{
    NSMutableDictionary* dic = [[report transformToDictionary] mutableCopy];
    
    [dic setObject:guid forKey:@"guid"];
    
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"dic: %@", myString);
    
    [self POST:@"SubmitDrive" parameters:dic success:succes failure:failure];
}
@end
