//
//  UploadDriveViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 09/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "UploadDriveViewController.h"
#import "eMobilityHTTPSClient.h"
#import "UserInfo.h"

@interface UploadDriveViewController ()
@property (weak, nonatomic) IBOutlet UIButton *tryAgianButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *infoText;
@end

@implementation UploadDriveViewController

const double WAIT_TIME_S = 1.5;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self doSync];
}

-(void)doSync
{
    UserInfo* info = [UserInfo sharedManager];
    eMobilityHTTPSClient* client = [eMobilityHTTPSClient sharedeMobilityHTTPSClient];
    
    [client postDriveReport:self.report forGuid:info.guid withBlock:^(NSURLSessionTask *task, id resonseObject)
     {
        self.infoText.text = @"Din indberetning er modtaget.";
        [NSTimer scheduledTimerWithTimeInterval:WAIT_TIME_S target:self selector:@selector(succesSync) userInfo:nil repeats:NO];
     }
     failBlock:^(NSURLSessionTask * task, NSError *Error)
     {
         NSLog(@"%@", Error);
         
         NSInteger errorCode = [Error.userInfo[ErrorCodeKey] intValue];
         [self failSyncWithErrorCode:(NSInteger)errorCode];
     }];
}

-(void) succesSync
{
    [self.delegate didFinishUpload];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void) failSyncWithErrorCode:(NSInteger)errorCode
{
    if(errorCode == TokenNotFound)
    {
        [self.delegate tokenNotFound];
        [self dismissViewControllerAnimated:true completion:nil];
    }
    else
    {
        //Change text, hide spinner, show button
        self.infoText.text = @"Noget gik galt i synkroniseringen med serveren. Prøve igen";
        self.spinner.hidden = true;
        self.tryAgianButton.hidden = false;
    
    }
}

- (IBAction)tryAgianButtonPressed:(id)sender {
    self.spinner.hidden = false;
    self.tryAgianButton.hidden = true;
    self.infoText.text = @"Uploader kørselsdata";
    [self doSync];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
