//
//  ConfirmEndDriveViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 09/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "ConfirmEndDriveViewController.h"

@interface ConfirmEndDriveViewController ()

@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkButtonImage;
@end

@implementation ConfirmEndDriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.okButton.layer.cornerRadius = 2;
    self.cancelButton.layer.cornerRadius = 2;
    
    self.titleLabel.text = @"Afslut Kørsel?";
    
    [self checkImage];
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
