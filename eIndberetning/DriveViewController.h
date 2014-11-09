//
//  DriveViewController.h
//  eIndberetning
//
//  Created by Jacob Hansen on 05/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriveReport.h"
#import "ConfirmEndDriveViewController.h"

@interface DriveViewController : UIViewController <EndDrivePopupDelegate>
@property (nonatomic,strong) DriveReport* report;
@end
