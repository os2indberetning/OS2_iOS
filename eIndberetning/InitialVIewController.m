//
//  InitialVIewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 24/09/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "InitialVIewController.h"
#import "eMobilityHTTPSClient.h"
#import "Profile.h"
#import "UserInfo.h"
#import "AppDelegate.h"

@interface InitialVIewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *couplePhoneButton;
@property (strong, nonatomic) eMobilityHTTPSClient *client;
@end

@implementation InitialVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.couplePhoneButton.layer.cornerRadius = 1.5f;
    
    self.textField.delegate = self;
    self.client = [eMobilityHTTPSClient sharedeMobilityHTTPSClient];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (IBAction)okButtonPressed:(id)sender {
    
    [self.client syncWithToken:self.textField.text withBlock:^(NSURLSessionTask *task, id resonseObject)
     {
         NSLog(@"%@", resonseObject);
         
         NSDictionary *profileDic = resonseObject;
         
         Profile* profile = [Profile initFromJsonDic:profileDic];
         UserInfo* info = [UserInfo sharedManager];
         
         //Search through the tokens
         for (Token* token in profile.tokens) {
             if([token.tokenString isEqualToString: self.textField.text]) //And something with status!
             {
                 info.guid = token.guid;
                 break;
             }
         }
         
         [info saveInfo];
         
         if(info.guid)
         {
             [self performSegueWithIdentifier:@"ShowStartViewSegue" sender:self];
         }
         else
         {
             //Print error message
         }
     }
     failBlock:^(NSURLSessionTask * task, NSError *Error)
     {
         CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
         anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
         anim.autoreverses = YES ;
         anim.repeatCount = 2.0f ;
         anim.duration = 0.07f ;
         
         [ self.textField.layer addAnimation:anim forKey:nil ] ;
         NSLog(@"%@", Error);
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
