//
//  PopupSendDeleteViewController.m
//  OS2Indberetning
//
//  Created by kasper on 9/28/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
//

#import "PopupSendDeleteViewController.h"
#import "SavedReport.h"
#import "Settings.h"
#import "eMobilityHTTPSClient.h"

@interface PopupSendDeleteViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;

@property (strong, nonatomic) SavedReport *  reportToShow;
@end

@implementation PopupSendDeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onCancelClicked:(id)sender {
    [self removeAnimate];
}
- (IBAction)onDeleteClicked:(id)sender {
    [Settings removeSavedReport:self.reportToShow];
    [self removeAnimate];
}
- (IBAction)onResendClicked:(id)sender {
    [eMobilityHTTPSClient sharedeMobilityHTTPSClient];
}
-(void) setReport:(SavedReport *)report{
    self.reportToShow = report;
}

-(void)removeAnimate{
    [super removeAnimate];
    if(self.onClosed){
        self.onClosed();
        self.onClosed = nil;
    }
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
