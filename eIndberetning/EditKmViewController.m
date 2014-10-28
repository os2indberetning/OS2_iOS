//
//  EditKmViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 28/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "EditKmViewController.h"
#import "UIViewController+BackButton.h"

@interface EditKmViewController ()
@property (weak, nonatomic) IBOutlet UILabel *measuredKMLabel;
@property (weak, nonatomic) IBOutlet UITextField *kmTextField;

@end

@implementation EditKmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self AddBackButton];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.kmTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.measuredKMLabel.text = [@"Afmålte km: " stringByAppendingString:[f stringFromNumber:self.route.totalDistanceMeasure]];
    self.kmTextField.text = [f stringFromNumber:self.route.totalDistanceEdit];
    
    // Do any additional setup after loading the view.
    [self.kmTextField becomeFirstResponder];
}

- (IBAction)saveBtnPressed:(id)sender {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.route.totalDistanceEdit = [f numberFromString:self.kmTextField.text];
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
