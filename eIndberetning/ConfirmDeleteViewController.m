//
//  ConfirmDeleteViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 09/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "ConfirmDeleteViewController.h"

@interface ConfirmDeleteViewController ()

@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@end

@implementation ConfirmDeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.errorLabel.text = @"Kørslen vil ikke blive gemt";
    self.titleLabel.text = @"Bekræft Sletning";
    self.errorLabel.numberOfLines = 2;
    self.okButton.layer.cornerRadius = 2;
    self.cancelButton.layer.cornerRadius = 2;
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
