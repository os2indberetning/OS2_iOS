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
#import "UIView+Toast.h"
#import "UserInfo.h"

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
    UserInfo* info = [UserInfo sharedManager];
    Token * token =info.token;
    eMobilityHTTPSClient* client =  [eMobilityHTTPSClient sharedeMobilityHTTPSClient];
    [client postSavedDriveReport:_reportToShow forToken:token withBlock:^(NSURLSessionDataTask *task, id resonseObject) {
            //worked, remove from list and refresh
        [Settings removeSavedReport:self.reportToShow];
        [self removeAnimate];
    } failBlock:^(NSURLSessionDataTask *task, NSError *error) {
        [self removeAnimate];
        [self.view.superview makeToast:@"Kunne ikke sende rapporten, prøv igen senere"];
        NSLog(@"failed resending %@", error.localizedDescription);
    }];
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
