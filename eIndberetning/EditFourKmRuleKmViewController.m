//
//  EditFourKmRuleKmViewController.m
//  OS2Indberetning
//
//  Created by Jonas Lauritsen on 10/06/16.
//  Copyright © 2016 IT-Minds. All rights reserved.
//

#import "EditFourKmRuleKmViewController.h"
#import "UIViewController+BackButton.h"
#import "UserInfo.h"

@interface EditFourKmRuleKmViewController ()

@property (weak, nonatomic) IBOutlet UILabel *measuredKMLabel;
@property (weak, nonatomic) IBOutlet UITextField *kmTextField;
@property (weak, nonatomic) IBOutlet UILabel *hometoborderdistanceDescriptionLabel;

@end

@implementation EditFourKmRuleKmViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self AddBackButton];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"hometoborderdistance_view_save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.kmTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.hometoborderdistanceDescriptionLabel.text = NSLocalizedString(@"hometoborderdistance_view_description", nil);
    
    self.measuredKMLabel.text = [NSString stringWithFormat:@"Afmålte km: %.01f Km", [self.report.homeToBorderDistance floatValue]];
    
    [self.kmTextField becomeFirstResponder];
        
    self.kmTextField.text = @"";
    
}

- (void)save
{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *distance = [f numberFromString:self.kmTextField.text];
    
    NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
    UserInfo* info = [UserInfo sharedManager];
    [userdefaults setObject:distance forKey:[NSString stringWithFormat:@"hometoborderdistance-%@", info.authorization.guId]];
    [userdefaults synchronize];
    
    NSLog(@"HomeToBorderDistance = %@", [userdefaults objectForKey:[NSString stringWithFormat:@"hometoborderdistance-%@", info.authorization.guId]]);
    
    [self.navigationController popViewControllerAnimated:true];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
