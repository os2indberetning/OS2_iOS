/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  ViewController+helper.m
//  dynamic web app
//

#import "ViewController+helper.h"

@implementation UIViewController(Helper)

-(void) presentNewViewController :(UIViewController *)controller
{
    [self presentViewController:controller animated:YES completion:NULL];
}


+ (UIViewController*)topmostViewController
{
    UIViewController* vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while(vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

+ (void)returnToRootViewController
{
    UIViewController* vc = [UIViewController topmostViewController];
    while (vc) {
        if([vc isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController*)vc popToRootViewControllerAnimated:YES];
        }
        if(vc.presentingViewController) {
            [vc dismissViewControllerAnimated:NO completion:^{}];
        }
        vc = vc.presentingViewController;
    }
}

@end
