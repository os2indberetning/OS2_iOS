//
//  SelectListTableViewController.h
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriveReport.h"

enum ListTypes {PurposeList, RateList, EmploymentList};

@interface SelectListTableViewController : UITableViewController <UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, strong) DriveReport* report;
@property (nonatomic) enum ListTypes listType;
@end
