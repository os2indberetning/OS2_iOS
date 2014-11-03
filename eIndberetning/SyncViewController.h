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

@interface SyncViewController : UIViewController

@property (strong, nonatomic) NSArray *rates;
@property (strong, nonatomic) NSArray *employments;
@property (strong,nonatomic) Profile* profile;

@end
