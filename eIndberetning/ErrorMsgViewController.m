//
//  PopupViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "ErrorMsgViewController.h"

@interface ErrorMsgViewController ()

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation ErrorMsgViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.okButton.layer.cornerRadius = 2;
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
    self.errorLabel.text = error;
    self.titleLabel.text = @"Fejl";
    
    [self showInView:[UIApplication sharedApplication].keyWindow  animated:YES];
}

@end
