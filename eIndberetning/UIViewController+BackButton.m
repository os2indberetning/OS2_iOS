/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  UIViewController+BackButton.m
//  eIndberetning
//

#import "UIViewController+BackButton.h"

@implementation UIViewController (BackButton)

-(void)AddBackButton
{
    UIImage *temp = [UIImage imageNamed:@"BackButton"];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:temp style:UIBarButtonItemStyleDone target:self action:@selector(popCurrentViewController)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
