//
//  ViewController+helper.h
//  dynamic web app
//
//  Created by kasper on 30/05/15.
//  Copyright (c) 2015 dynamicweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(Helper)

-(void) presentNewViewController :(UIViewController *)controller;

+ (void)returnToRootViewController;

+ (UIViewController*)topmostViewController;
@end
