/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  ConfirmDeleteViewController.m
//  eIndberetning
//

#import "ConfirmDeleteViewController.h"
#import "UserInfo.h"

@interface ConfirmDeleteViewController ()

@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@end

@implementation ConfirmDeleteViewController

-(void)setupVisuals
{
    UserInfo* info = [UserInfo sharedManager];
    [info loadInfo];
    
    [self.okButton setBackgroundColor:info.appInfo.SecondaryColor];
    [self.okButton setTitleColor:info.appInfo.TextColor forState:UIControlStateNormal];
    self.okButton.layer.cornerRadius = 2.0f;
    
    [self.cancelButton setBackgroundColor:info.appInfo.TextColor];
    [self.cancelButton setTitleColor:info.appInfo.SecondaryColor forState:UIControlStateNormal];
    self.cancelButton.layer.cornerRadius = 2.0f;
    
    self.titleLabel.textColor = info.appInfo.TextColor;
    self.headerView.backgroundColor = info.appInfo.PrimaryColor;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.errorLabel.text = NSLocalizedString(@"confirmation_delete_drivereport_description", nil);
    self.titleLabel.text = NSLocalizedString(@"confirmation_delete_drivereport_title", nil);
    self.okButton.titleLabel.text = NSLocalizedString(@"confirmation_delete_drivereport_accept", nil);
    self.cancelButton.titleLabel.text = NSLocalizedString(@"confirmation_delete_drivereport_cancel", nil);
    
    self.errorLabel.numberOfLines = 2;
    [self setupVisuals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okButtonPressed:(id)sender {
    [self.delegate confirmDelete];
    [self removeAnimate];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self removeAnimate];
}

-(void)showPopup
{
    [self showInView:[UIApplication sharedApplication].keyWindow  animated:YES];
}
@end
