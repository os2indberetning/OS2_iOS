//
//  SyncViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 03/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "SyncViewController.h"
#import "UserInfo.h"
#import "JSONResponseSerializerWithData.h"

@interface SyncViewController()

@property (strong, nonatomic) NSDate *syncStartTime;
@property (weak, nonatomic) IBOutlet UIButton *tryAgianButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *infoText;
@property (weak, nonatomic) IBOutlet UIImageView *municipalityLogoImageView;
@property (strong, nonatomic) eMobilityHTTPSClient *client;
@end

@implementation SyncViewController

const double MIN_WAIT_TIME_S = 2;

-(void)setupVisuals
{
    UserInfo* info = [UserInfo sharedManager];
    [info loadInfo];
    
    [self.tryAgianButton setBackgroundColor:info.appInfo.SecondaryColor];
    [self.tryAgianButton setTitleColor:info.appInfo.TextColor forState:UIControlStateNormal];
    self.tryAgianButton.layer.cornerRadius = 1.5f;
    
    [self.municipalityLogoImageView setImage:info.appInfo.ImgData];
    
    [self.spinner setColor:info.appInfo.SecondaryColor];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.infoText.numberOfLines = 2;
    
    self.client = [eMobilityHTTPSClient sharedeMobilityHTTPSClient];
    [self setupVisuals];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self doSync];
}

-(void) doSync
{
    UserInfo* info = [UserInfo sharedManager];
    self.syncStartTime = [NSDate date];
    
    __weak SyncViewController *safeSelf = self;
    
    [self.client getUserDataForToken:info.token withBlock:^(NSURLSessionTask *task, id resonseObject)
    {
        NSLog(@"%@", resonseObject);
        
        NSDictionary *profileDic = [resonseObject objectForKey:@"profile"];
        NSDictionary *rateDic = [resonseObject objectForKey:@"rates"];
        
        safeSelf.profile = [Profile initFromJsonDic:profileDic];
        safeSelf.rates = [Rate initFromJsonDic:rateDic];
        
        if([[NSDate date] timeIntervalSinceDate:safeSelf.syncStartTime] > MIN_WAIT_TIME_S)
        {
            [safeSelf succesSync];
        }
        else
        {
            [NSTimer scheduledTimerWithTimeInterval:MIN_WAIT_TIME_S-[[NSDate date] timeIntervalSinceDate:safeSelf.syncStartTime]  target:safeSelf selector:@selector(succesSync) userInfo:nil repeats:NO];
        }
        
    }
    failBlock:^(NSURLSessionTask * task, NSError *Error)
    {
        NSLog(@"%@", Error);
        
        NSInteger errorCode = [Error.userInfo[ErrorCodeKey] intValue];
        [safeSelf failSyncWithErrorCode:(NSInteger)errorCode];
         
    }];
}

-(void) succesSync
{
    [self.delegate didFinishSyncWithProfile:self.profile AndRate:self.rates];
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) failSyncWithErrorCode:(NSInteger)errorCode
{
    if(errorCode == UnknownError)
    {
        //Change text, hide spinner, show retry-button
        self.infoText.text = @"Noget gik galt i synkroniseringen med serveren. Prøve igen?";
        self.spinner.hidden = true;
        self.tryAgianButton.hidden = false;
    }
    else if(errorCode == TokenNotFound)
    {
        [self.delegate tokenNotFound];
        [self dismissViewControllerAnimated:false completion:nil];
    }
}

- (IBAction)tryAgianButtonPressed:(id)sender {
    self.spinner.hidden = false;
    self.tryAgianButton.hidden = true;
    self.infoText.text = @"Synkroniserer stamdata";
    [self doSync];
}
@end
