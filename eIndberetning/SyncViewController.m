//
//  SyncViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 03/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "SyncViewController.h"

@interface SyncViewController()

@property (strong, nonatomic) NSDate *syncStartTime;
@property (weak, nonatomic) IBOutlet UIButton *tryAgianButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *infoText;
@property (strong, nonatomic) eMobilityHTTPSClient *client;
@end

@implementation SyncViewController

const double MIN_WAIT_TIME_S = 3;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.client = [eMobilityHTTPSClient sharedeMobilityHTTPSClient];
    [self doSync];
}

-(void) doSync
{
    self.syncStartTime = [NSDate date];
    [self.client getUserDataWithBlock:^(NSURLSessionTask *task, id resonseObject)
    {
        NSLog(@"%@", resonseObject);
        
        NSDictionary *profileDic = [resonseObject objectForKey:@"profile"];
        NSDictionary *rateDic = [resonseObject objectForKey:@"rates"];
        
        self.profile = [Profile initFromJsonDic:profileDic];
        self.rates = [Rate initFromJsonDic:rateDic];
        
        if([[NSDate date] timeIntervalSinceDate:self.syncStartTime] > MIN_WAIT_TIME_S)
        {
            [self succesSync];
        }
        else
        {
            [NSTimer scheduledTimerWithTimeInterval:MIN_WAIT_TIME_S-[[NSDate date] timeIntervalSinceDate:self.syncStartTime]  target:self selector:@selector(succesSync) userInfo:nil repeats:NO];
        }
        
    }
    failBlock:^(NSURLSessionTask * task, NSError *Error)
    {
        NSLog(@"%@", Error);
        [self failSync];
         
    }];
}

-(void) succesSync
{
    [self.delegate didFinishSyncWithProfile:self.profile AndRate:self.rates];
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) failSync
{
    self.infoText.text = @"Noget gik galt i synkroniseringen med serveren. Prøve igen";
    self.spinner.hidden = true;
    self.tryAgianButton.hidden = false;
    //Change text, hide spinner, show button
}

- (IBAction)tryAgianButtonPressed:(id)sender {
    self.spinner.hidden = false;
    self.tryAgianButton.hidden = true;
    self.infoText.text = @"Synkroniserer stamdata";
    [self doSync];
}
@end
