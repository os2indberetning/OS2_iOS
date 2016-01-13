/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  eMobilityHTTPSClient.m
//  eIndberetning
//

#import "eMobilityHTTPSClient.h"
#import "SavedReport.h"

//#define MOCK

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
    
#if !defined(MOCK)
    [self.sessionManager POST:@"syncWithToken" parameters:parameters success:succes failure:failure];
#else
    succes(nil,[self getMockItem]);
#endif
}



-(void)getUserDataForToken:(Token*)token withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"guid"] = token.guid;
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"dic: %@", myString);
    
#if !defined(MOCK)
    [self.sessionManager POST:@"UserData" parameters:parameters success:succes failure:failure];
#else
    succes(nil,[self getMockItem]);
#endif
}
#pragma mark Post drive reports
- (void)postDriveReport:(DriveReport *)report forToken:(Token*)token withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure
{
    NSDictionary* dic = @{
                          @"DriveReport" :[[report transformToDictionary] mutableCopy] ,
                          @"Token" :[[token transformToDictionary] mutableCopy]
                          };
    
    [self postDriveReport:dic withBlock:succes failBlock:failure];
}


-(void)postSavedDriveReport:(SavedReport *)report forToken:(Token*)token withBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure{
    NSData *data = [report.jsonToSend dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *arrayJson = [[[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] allValues] firstObject];
    NSDictionary* dic = @{
                          @"DriveReport" :arrayJson,
                          @"Token" :[[token transformToDictionary] mutableCopy]
                          };
    
    [self postDriveReport:dic withBlock:succes failBlock:failure];
}

-(void)postDriveReport:(NSDictionary *) data withBlock:(void (^)(NSURLSessionDataTask *, id))succes failBlock:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"dic: %@", myString);
#if !defined(MOCK)
    [self.sessionManager POST:@"SubmitDrive" parameters:data success:succes failure:failure];
#else
    succes(nil,[self getMockItem]);
#endif
    
}
#pragma mark mock

-(NSDictionary*)getMockItem
{
    return      @{
                  @"profile":
                      @{
                          @"Firstname":@"Jacob",
                          @"Lastname":@"Hansen",
                          @"HomeLongitude":@"51.1",
                          @"HomeLatitude":@"52.2",
                          @"Tokens":
                              @[
                                  @{
                                      @"TokenString":@"1111",
                                      @"Status":@"1",
                                      @"GuId":@"12345678912345"
                                      }
                                  ],
                          @"Employments":
                              @[
                                  @{
                                      @"EmploymentPosition":@"Janitor",
                                      @"Id":@"202"
                                      },
                                  @{
                                      @"EmploymentPosition":@"Major",
                                      @"Id":@"203"
                                      }
                                  ],
                          @"Id":@"200"
                          },
                  @"rates":
                      @[
                          @{
                              @"Id":@"209",
                              @"Description":@"Bil",
                              @"Year":@"2015"
                              },
                          @{
                              @"Id":@"219",
                              @"Description":@"Cykel",
                              @"Year":@"2015"
                              },
                          @{
                              @"Id":@"211",
                              @"Description":@"Rulleskøjter",
                              @"Year":@"2015"
                              }
                          ]
                  };
}
@end
