//
//  EditFourKmRuleKmViewController.m
//  OS2Indberetning
//
//  Created by Jonas Lauritsen on 10/06/16.
//  Copyright © 2016 IT-Minds. All rights reserved.
//

#import "EditFourKmRuleKmViewController.h"
#import "UIViewController+BackButton.h"

@interface EditFourKmRuleKmViewController ()

@property (weak, nonatomic) IBOutlet UILabel *measuredKMLabel;
@property (weak, nonatomic) IBOutlet UITextField *kmTextField;

@end

@implementation EditFourKmRuleKmViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self AddBackButton];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.kmTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.measuredKMLabel.text = [NSString stringWithFormat:@"Afmålte km: %.01f Km", [self.report.fourKmRuleKmDistance floatValue]];
    
    [self.kmTextField becomeFirstResponder];
    
    //    self.kmTextField.text = [NSString stringWithFormat:@"%.01f", [self.route.totalDistanceEdit floatValue]];
    
    self.kmTextField.text = @"";
    
}

- (IBAction)saveBtnPressed:(id)sender {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.report.fourKmRuleKmDistance = [f numberFromString:self.kmTextField.text];
    
    [self.navigationController popViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
