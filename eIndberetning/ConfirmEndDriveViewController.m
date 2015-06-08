//
//  ConfirmEndDriveViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 09/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "ConfirmEndDriveViewController.h"
#import "UserInfo.h"
#import "CheckMarkImageView.h"

@interface ConfirmEndDriveViewController ()

@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet CheckMarkImageView *checkButtonImage;
@end

@implementation ConfirmEndDriveViewController

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
    
    self.titleLabel.text = @"Afslut Kørsel?";
    
    [self setupVisuals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectButtonPressed:(id)sender {
    self.isSelected = !self.isSelected;
    
    [self.delegate changeSelectedState:self.isSelected];
    [self.checkButtonImage setCheckMarkState:self.isSelected];
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
