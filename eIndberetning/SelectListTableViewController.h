/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  SelectListTableViewController.h
//  eIndberetning
//

#import <UIKit/UIKit.h>
#import "DriveReport.h"

enum ListTypes {RateList, EmploymentList};

@interface SelectListTableViewController : UITableViewController
@property (nonatomic, strong) NSArray* items;
@property (nonatomic, strong) DriveReport* report;
@property (nonatomic) enum ListTypes listType;
@end
