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
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIImageView *municipalityLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoText;

@property (strong, nonatomic) NSArray *rates;
@property (strong,nonatomic) Profile* profile;
@end

@implementation UploadDriveViewController

const double WAIT_TIME_S = 1.5;

-(void)setupVisuals
{
    UserInfo* info = [UserInfo sharedManager];
    [info loadInfo];
    
    [self.cancelButton setBackgroundColor:info.appInfo.TextColor];
    [self.cancelButton setTitleColor:info.appInfo.SecondaryColor forState:UIControlStateNormal];
    self.cancelButton.layer.cornerRadius = 1.5f;
    
    [self.tryAgianButton setBackgroundColor:info.appInfo.SecondaryColor];
    [self.tryAgianButton setTitleColor:info.appInfo.TextColor forState:UIControlStateNormal];
    self.tryAgianButton.layer.cornerRadius = 1.5f;
    
    [self.municipalityLogoImageView setImage:info.appInfo.ImgData];
    
    [self.spinner setColor:info.appInfo.SecondaryColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.infoText.numberOfLines = 2;
    
    [self setupVisuals];
    [self doSync];
}

-(void)doSync
{
    UserInfo* info = [UserInfo sharedManager];
    eMobilityHTTPSClient* client = [eMobilityHTTPSClient sharedeMobilityHTTPSClient];
    
    [client postDriveReport:self.report forToken:info.token withBlock:^(NSURLSessionTask *task, id resonseObject)
     {
         //Optional: also sync userdata on succesfull submit
         NSDictionary *profileDic = [resonseObject objectForKey:@"profile"];
         NSDictionary *rateDic = [resonseObject objectForKey:@"rates"];
         
         self.profile = [Profile initFromJsonDic:profileDic];
         self.rates = [Rate initFromJsonDic:rateDic];
         //Optional
         
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
    //Optional: also sync userdata on succesfull submit
    [self.delegate didFinishSyncWithProfile:self.profile AndRate:self.rates];
    //Optional
    [self dismissViewControllerAnimated:true completion:nil];
    [self.delegate didFinishUpload];
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
        self.infoText.text = @"Noget gik galt i synkroniseringen med serveren. Prøve igen?";
        self.spinner.hidden = true;
        self.tryAgianButton.hidden = false;
        self.cancelButton.hidden = false;
    }
}

- (IBAction)tryAgianButtonPressed:(id)sender {
    self.spinner.hidden = false;
    self.tryAgianButton.hidden = true;
    self.cancelButton.hidden = true;
    
    self.infoText.text = @"Uploader kørselsdata";
    [self doSync];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
