/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  PopupSendDeleteViewController.m
//  OS2Indberetning
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
@property (weak, nonatomic) IBOutlet UIView *topContainer;

@property (strong, nonatomic) SavedReport *  reportToShow;
@end

@implementation PopupSendDeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVisuals];
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
    
    //TODO: Handle resend with guId
    
//    Token * token =info.token;
//    eMobilityHTTPSClient* client =  [eMobilityHTTPSClient sharedeMobilityHTTPSClient];
//    [client postSavedDriveReport:_reportToShow forToken:token withBlock:^(NSURLSessionDataTask *task, id resonseObject) {
//            //worked, remove from list and refresh
//        [Settings removeSavedReport:self.reportToShow];
//        [self removeAnimate];
//    } failBlock:^(NSURLSessionDataTask *task, NSError *error) {
//        [self removeAnimate];
//        [self.view.superview makeToast:@"Kunne ikke sende rapporten, prøv igen senere"];
//        NSLog(@"failed resending %@", error.localizedDescription);
//    }];
}
-(void) setReport:(SavedReport *)report{
    self.reportToShow = report;
}

-(void)setupVisuals
{
    UserInfo* info = [UserInfo sharedManager];
    [info loadInfo];
    
    [self.cancelButton setBackgroundColor:info.appInfo.SecondaryColor];
    [self.cancelButton setTitleColor:info.appInfo.TextColor forState:UIControlStateNormal];
    self.cancelButton.layer.cornerRadius = 2.0f;
    
    [self.deleteButton setBackgroundColor:info.appInfo.TextColor];
    [self.deleteButton setTitleColor:info.appInfo.SecondaryColor forState:UIControlStateNormal];
    self.deleteButton.layer.cornerRadius = 2.0f;
    
    [self.resendButton setBackgroundColor:info.appInfo.SecondaryColor];
    [self.resendButton setTitleColor:info.appInfo.TextColor forState:UIControlStateNormal];
    self.resendButton.layer.cornerRadius = 2.0f;
    

    
    self.titleLabel.textColor = info.appInfo.TextColor;
    self.topContainer.backgroundColor = info.appInfo.PrimaryColor;
    
}


-(void)removeAnimate{
    [super removeAnimate];
    if(self.onClosed){
        self.onClosed();
        self.onClosed = nil;
    }
}

@end
