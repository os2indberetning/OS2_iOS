/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  ErrorMsgViewController.h
//  eIndberetning
//

#import <UIKit/UIKit.h>
#import "PopupBaseViewController.h"

@protocol ErrorMessageDelegate
-(void) errorMessageButtonClicked;
@end

@interface ErrorMsgViewController : PopupBaseViewController

-(void)showErrorMsg:(NSString*)error;

-(void)showErrorMsg:(NSString*)title errorString:(NSString *) error;

@property (nonatomic, strong) id<ErrorMessageDelegate> delegate;

@end
