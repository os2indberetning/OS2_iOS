/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  ManualEntryViewController.m
//  eIndberetning
//

#import "ManualEntryViewController.h"
#import "UIViewController+BackButton.h"

@interface ManualEntryViewController ()

@end

@implementation ManualEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AddBackButton];

    //Add save button
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"comments_view_save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    
    self.navigationItem.title = NSLocalizedString(@"comments_view_title", nil);
    self.textView.text = self.report.manuelentryremark;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)save
{
    self.report.manuelentryremark = self.textView.text;
    [self.navigationController popViewControllerAnimated:true];
}

@end
