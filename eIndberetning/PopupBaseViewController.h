/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  PopupBaseViewController.h
//  eIndberetning
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PopupBaseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic)NSString *titelString;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)removeAnimate;
@end
