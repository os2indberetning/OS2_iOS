/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  FinishDriveTableViewController.h
//  eIndberetning
//

#import <UIKit/UIKit.h>
#import "DriveReport.h"
#import "ConfirmDeleteViewController.h"
#import "UploadDriveViewController.h"

@interface FinishDriveTableViewController : UITableViewController <ConfirmDeletePopupDelegate,DidUploadDelegate>
@property (nonatomic,strong) DriveReport* report;
@property BOOL shouldShowInAccuracyWarning;
@end
