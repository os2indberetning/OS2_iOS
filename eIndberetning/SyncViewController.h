/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  SyncViewController.h
//  eIndberetning
//

#import <UIKit/UIKit.h>
#import "eMobilityHTTPSClient.h"
#import "Profile.h"
#import "Rate.h"

@protocol DidSyncDelegate
-(void)didFinishSyncWithProfile:(Profile*)profile AndRate:(NSArray*)rates;
-(void)tokenNotFound;
@end

@interface SyncViewController : UIViewController

@property (strong, nonatomic) NSArray *rates;
@property (strong,nonatomic) Profile* profile;

@property (strong,nonatomic) id <DidSyncDelegate> delegate;
@end
