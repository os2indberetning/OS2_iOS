//
//  SyncViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 03/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "SyncViewController.h"


@implementation SyncViewController



-(void)viewDidLoad
{
    [super viewDidLoad];
    
    eMobilityHTTPSClient* client = [eMobilityHTTPSClient sharedeMobilityHTTPSClient];
    
    [client getUserDataWithBlock:^(NSURLSessionTask *task, id resonseObject){
        
        NSLog(@"%@", resonseObject);
        
        NSDictionary *profileDic = [resonseObject objectForKey:@"profile"];
        NSDictionary *rateDic = [resonseObject objectForKey:@"rates"];
        
        self.profile = [Profile initFromJsonDic:profileDic];
        self.rates = [Rate initFromJsonDic:rateDic];
        self.employments = self.profile.employments;
        
    }
    failBlock:^(NSURLSessionTask * task, NSError *Error)
     {
         NSLog(@"%@", Error);
     }];
}

@end
