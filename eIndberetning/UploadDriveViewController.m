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
    
    [client postDriveReport:self.report forToken:info.token withBlock:^(NSURLSessionTask *task, id resonseObject)
     {
        self.infoText.text = @"Din indberetning er modtaget.";
        [NSTimer scheduledTimerWithTimeInterval:WAIT_TIME_S target:self selector:@selector(succesSync) userInfo:nil repeats:NO];
     }
     failBlock:^(NSURLSessionTask * task, NSError *Error)
     {
         NSLog(@"%@", Error);
         [self failSync];
     }];
}

-(void) succesSync
{
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void) failSync
{
    self.infoText.text = @"Noget gik galt i synkroniseringen med serveren. Prøve igen";
    self.spinner.hidden = true;
    self.tryAgianButton.hidden = false;
    //Change text, hide spinner, show button
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
