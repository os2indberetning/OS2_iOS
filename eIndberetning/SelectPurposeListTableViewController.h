//
//  SelectPurposeListTableViewController.h
//  eIndberetning
//
//  Created by Jacob Hansen on 04/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriveReport.h"

@interface SelectPurposeListTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) DriveReport* report;

@end
