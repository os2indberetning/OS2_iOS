/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  PopupViewController.m
//  eIndberetning
//

#import "ErrorMsgViewController.h"
#import "UserInfo.h"

@interface ErrorMsgViewController ()

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* errorString;
@end

@implementation ErrorMsgViewController

-(void)setupVisuals
{
    UserInfo* info = [UserInfo sharedManager];
    [info loadInfo];
    
    [self.okButton setBackgroundColor:info.appInfo.SecondaryColor];
    [self.okButton setTitleColor:info.appInfo.TextColor forState:UIControlStateNormal];
    self.okButton.layer.cornerRadius = 2.0f;
    
    self.titleLabel.textColor = info.appInfo.TextColor;
    self.headerView.backgroundColor = info.appInfo.PrimaryColor;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.title){
        self.titleLabel.text = self.title;
    }else{
        self.titleLabel.text = @"Fejl";
    }
    
    self.errorLabel.text = self.errorString;
    
    [self setupVisuals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    [self removeAnimate];
    if(self.delegate){
        [self.delegate errorMessageButtonClicked];
    }
}

-(void)showErrorMsg:(NSString*)error
{
    self.errorString= error;
    [self showInView:[UIApplication sharedApplication].keyWindow  animated:YES];
}

-(void)showErrorMsg:(NSString*)error errorString:(NSString *) error
{
    self.
    self.errorString= error;
    [self showInView:[UIApplication sharedApplication].keyWindow  animated:YES];
}

@end
