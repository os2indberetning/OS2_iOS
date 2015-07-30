//
//  ViewController+helper.m
//  dynamic web app
//
//  Created by kasper on 30/05/15.
//  Copyright (c) 2015 dynamicweb. All rights reserved.
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
