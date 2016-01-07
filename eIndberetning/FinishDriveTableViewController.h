//
//  FinishDriveTableViewController.h
//  eIndberetning
//
//  Created by Jacob Hansen on 05/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriveReport.h"
#import "SyncViewController.h"
#import "ConfirmDeleteViewController.h"
#import "UploadDriveViewController.h"

@interface FinishDriveTableViewController : UITableViewController <DidSyncDelegate,ConfirmDeletePopupDelegate,DidUploadDelegate>
@property (nonatomic,strong) DriveReport* report;
@property BOOL shouldShowInAccuracyWarning;
@end
