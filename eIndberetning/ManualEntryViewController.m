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
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Bemærkning";
    self.textView.text = self.report.manuelentryremark;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save
{
    self.report.manuelentryremark = self.textView.text;
    [self.navigationController popViewControllerAnimated:true];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
