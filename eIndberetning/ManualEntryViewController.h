/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  ManualEntryViewController.h
//  eIndberetning
//

#import <UIKit/UIKit.h>
#import "DriveReport.h"

@interface ManualEntryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) DriveReport* report;
@end
