/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  PairViewController.m
//  eIndberetning
//

#import "PairViewController.h"
#import "eMobilityHTTPSClient.h"
#import "Profile.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "ErrorMsgViewController.h"
#import "CoreDataManager.h"
#import "CheckMarkImageView.h"

@interface PairViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *couplePhoneButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) eMobilityHTTPSClient *client;
@property (nonatomic, strong) ErrorMsgViewController* errorMsg;
@property (nonatomic,strong) CoreDataManager* CDManager;
@end


@implementation PairViewController

-(CoreDataManager*)CDManager
{
    return [CoreDataManager sharedeCoreDataManager];
}

-(void)setupVisuals
{
    UserInfo* info = [UserInfo sharedManager];
    [info loadInfo];
    
    [self.couplePhoneButton setBackgroundColor:info.appInfo.SecondaryColor];
    [self.couplePhoneButton setTitleColor:info.appInfo.TextColor forState:UIControlStateNormal];
    self.couplePhoneButton.layer.cornerRadius = 1.5f;
    
    self.headerLabel.textColor = info.appInfo.TextColor;
    self.headerView.backgroundColor = info.appInfo.PrimaryColor;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController setNavigationBarHidden:YES];
    self.textField.delegate = self;
    
    self.client = [eMobilityHTTPSClient sharedeMobilityHTTPSClient];
    [self.client setBaseUrl:[NSURL URLWithString:self.appInfo.APIUrl]];
    [self.appInfo getImageDataIfNotPresent];
    
    UserInfo* info = [UserInfo sharedManager];
    info.appInfo = self.appInfo;
    [info saveInfo];
    
    [self setupVisuals];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:true];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)okButtonPressed:(id)sender {
//    [self fakeLogin];
  
//    
//    [self.client syncWithTokenString:self.textField.text withBlock:^(NSURLSessionTask *task, id resonseObject)
//     {
//         NSLog(@"%@", resonseObject);
//         
//         UserInfo* info = [UserInfo sharedManager];
//         
//         NSDictionary *profileDic = [resonseObject objectForKey:@"profile"];
//         NSDictionary *rateDic = [resonseObject objectForKey:@"rates"];
//         
//         Profile* profile = [Profile initFromJsonDic:profileDic];
//         NSArray* rates = [Rate initFromJsonDic:rateDic];
//         
//         
//         [self.CDManager deleteAllObjects:@"CDRate"];
//         [self.CDManager deleteAllObjects:@"CDEmployment"];
//         
//         [self.CDManager insertEmployments:profile.employments];
//         [self.CDManager insertRates:rates];
//         
//         //Transfer userdata to local userinfo object
//         info.last_sync_date = [NSDate date];
//         info.name = [NSString stringWithFormat:@"%@ %@", profile.FirstName, profile.LastName];
//         info.home_loc = profile.homeCoordinate;
//         info.profileId = profile.profileId;
//         
//         
//         //Search through the tokens
//         for (Token* token in profile.tokens) {
//             if([token.tokenString isEqualToString: self.textField.text])
//             {
//                 info.token = token;
//                 break;
//             }
//         }
//         
//         [info saveInfo];
//         
//         if(info.token)
//         {
//             AppDelegate* del =  [[UIApplication sharedApplication] delegate];
//             [del changeToStartView];
//             //[self performSegueWithIdentifier:@"ShowStartViewSegue" sender:self];
//         }
//         else
//         {
//             //Print error message
//         }
//     }
//     failBlock:^(NSURLSessionTask * task, NSError *Error)
//     {
//         NSInteger errorCode = [Error.userInfo[ErrorCodeKey] intValue];
//         NSString* errorString = [eMobilityHTTPSClient getErrorString:errorCode];
//         
//         self.errorMsg = [[ErrorMsgViewController alloc] initWithNibName:@"ErrorMsgViewController" bundle:nil];
//         [self.errorMsg showErrorMsg: errorString];
//         
//         CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
//         anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
//         anim.autoreverses = YES ;
//         anim.repeatCount = 2.0f ;
//         anim.duration = 0.07f ;
//         
//         [ self.textField.layer addAnimation:anim forKey:nil ] ;
//         NSLog(@"%@", Error);
//     }];
    
}

/*
-(void) fakeLogin {
    
    
    
    UserInfo* info = [UserInfo sharedManager];
    
    Profile* profile = [[Profile alloc] init];
    profile.LastName =@"";
    profile.FirstName = @"";
    profile.employments  = @[];
    Token * tok = [[Token alloc] init];
    tok.guid = @"8e26dc40-2f80-4b61-98ef-ab5ff4074347";
    tok.status = @"";
    tok.tokenString = @"8353707760";
    profile.tokens = @[tok];
    NSArray* rates = @[];
    
    [self.CDManager deleteAllObjects:@"CDRate"];
    [self.CDManager deleteAllObjects:@"CDEmployment"];
    
    [self.CDManager insertEmployments:profile.employments];
    [self.CDManager insertRates:rates];
    
    //Transfer userdata to local userinfo object
    info.last_sync_date = [NSDate date];
    info.name = [NSString stringWithFormat:@"%@ %@", profile.FirstName, profile.LastName];
    info.home_loc = profile.homeCoordinate;
    info.profileId = profile.profileId;
    
    
    //Search through the tokens
    for (Token* token in profile.tokens) {
        if([token.tokenString isEqualToString: self.textField.text])
        {
            info.token = token;
            break;
        }
    }
    
    [info saveInfo];
    
    if(info.token)
    {
        AppDelegate* del =  [[UIApplication sharedApplication] delegate];
        [del changeToStartView];
        //[self performSegueWithIdentifier:@"ShowStartViewSegue" sender:self];
    }

}*/ //use in case of debugging and the neeed of a backdoor.. since this is a valid GUID; we can just login locally, and then restart the app and it will fetch the real content , authenticated...

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
