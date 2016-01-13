/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  PopupSendDeleteViewController.h
//  OS2Indberetning
//

#import "PopupBaseViewController.h"
#import "SavedReport.h"

@interface PopupSendDeleteViewController : PopupBaseViewController
@property (nonatomic, copy) void (^onClosed)();
-(void) setReport:(SavedReport *)report;
@end
