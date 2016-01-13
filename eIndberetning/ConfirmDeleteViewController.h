/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  ConfirmDeleteViewController.h
//  eIndberetning
//

#import "PopupBaseViewController.h"

@protocol ConfirmDeletePopupDelegate
-(void)confirmDelete;
@end

@interface ConfirmDeleteViewController : PopupBaseViewController

-(void)showPopup;
@property (nonatomic, strong) id<ConfirmDeletePopupDelegate> delegate;
@end
