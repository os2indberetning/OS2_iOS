//
//  ManualEntryViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
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
