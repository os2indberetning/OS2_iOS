//
//  ConfirmEndDriveViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 09/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "ConfirmEndDriveViewController.h"
#import "UserInfo.h"

@interface ConfirmEndDriveViewController ()

@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkButtonImage;
@end

@implementation ConfirmEndDriveViewController

-(void)setupVisuals
{
    UserInfo* info = [UserInfo sharedManager];
    [info loadInfo];
    
    [self.okButton setBackgroundColor:info.appInfo.ButtonColor];
    [self.okButton setTitleColor:info.appInfo.ButtonTextColor forState:UIControlStateNormal];
    self.okButton.layer.cornerRadius = 2.0f;
    
    [self.cancelButton setBackgroundColor:info.appInfo.ButtonTextColor];
    [self.cancelButton setTitleColor:info.appInfo.ButtonColor forState:UIControlStateNormal];
    self.cancelButton.layer.cornerRadius = 2.0f;
    
    self.titleLabel.textColor = info.appInfo.HeaderTextColor;
    self.headerView.backgroundColor = info.appInfo.HeaderColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.text = @"Afslut Kørsel?";
    
    [self checkImage];
    [self setupVisuals];
}

- (void)checkImage
{
    if(self.isSelected)
        self.checkButtonImage.image = [UIImage imageNamed:@"checkBox_checked"];
    else
        self.checkButtonImage.image = [UIImage imageNamed:@"checkBox_unchecked"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectButtonPressed:(id)sender {
    self.isSelected = !self.isSelected;
    
    [self.delegate changeSelectedState:self.isSelected];
    [self checkImage];
}

- (IBAction)okButtonPressed:(id)sender {
    [self.delegate endDrive];
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
