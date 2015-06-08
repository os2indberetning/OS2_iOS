//
//  PopupViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "ErrorMsgViewController.h"
#import "UserInfo.h"

@interface ErrorMsgViewController ()

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
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
    self.titleLabel.text = @"Fejl";
    self.errorLabel.text = self.errorString;
    self.errorLabel.numberOfLines = 2;
    
    [self setupVisuals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    [self removeAnimate];
}

-(void)showErrorMsg:(NSString*)error
{
    self.errorString= error;
    [self showInView:[UIApplication sharedApplication].keyWindow  animated:YES];
}

@end
