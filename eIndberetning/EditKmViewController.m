/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  EditKmViewController.m
//  eIndberetning
//

#import "EditKmViewController.h"
#import "UIViewController+BackButton.h"

@interface EditKmViewController ()
@property (weak, nonatomic) IBOutlet UILabel *measuredKMLabel;
@property (weak, nonatomic) IBOutlet UITextField *kmTextField;

@end

@implementation EditKmViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self AddBackButton];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.kmTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.measuredKMLabel.text = [NSString stringWithFormat:@"Afmålte km: %.01f Km", [self.route.totalDistanceMeasure floatValue]];
    
    [self.kmTextField becomeFirstResponder];
    
//    self.kmTextField.text = [NSString stringWithFormat:@"%.01f", [self.route.totalDistanceEdit floatValue]];
    
    self.kmTextField.text = @"";
    
}

- (IBAction)saveBtnPressed:(id)sender {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.route.totalDistanceEdit = [f numberFromString:self.kmTextField.text];
    self.route.distanceWasEdited = YES;
    
    [self.navigationController popViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
