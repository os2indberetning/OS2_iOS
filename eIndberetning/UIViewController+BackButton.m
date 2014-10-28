//
//  UIViewController+BackButton.m
//  eIndberetning
//
//  Created by Jacob Hansen on 28/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
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
