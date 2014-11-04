//
//  SyncViewController.h
//  eIndberetning
//
//  Created by Jacob Hansen on 03/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eMobilityHTTPSClient.h"
#import "Profile.h"
#import "Rate.h"

@protocol DidSyncDelegate
-(void)didFinishSyncWithProfile:(Profile*)profile AndRate:(NSArray*)rates;
@end

@interface SyncViewController : UIViewController

@property (strong, nonatomic) NSArray *rates;
@property (strong,nonatomic) Profile* profile;

@property (strong,nonatomic) id <DidSyncDelegate> delegate;

@end
