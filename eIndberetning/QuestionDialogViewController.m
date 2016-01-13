/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  QuestionDialogViewController.m
//  OS2Indberetning
//

#import "QuestionDialogViewController.h"
#import "UserInfo.h"

@interface QuestionDialogViewController ()
@property (nonatomic, copy) void (^noCallback)();
@property (nonatomic, copy) void (^yesCallback)();
@property (weak, nonatomic) IBOutlet UILabel *titleLabelQuestion;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *topContainer;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property NSString * titleText;
@property NSString * noText;
@property NSString * yesText;
@property NSString * messageText;

@end

@implementation QuestionDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _titleLabelQuestion.text = _titleText;
    [_yesButton setTitle:_yesText forState:UIControlStateNormal];
    [_yesButton setTitle:_yesText forState:UIControlStateHighlighted];
    [_noButton setTitle:_noText forState:UIControlStateNormal];
    [_noButton setTitle:_noText forState:UIControlStateHighlighted];
    _messageLabel.text = _messageText;

    //handle color scheme here.
    [self setupVisuals];

}

-(void)setupVisuals
{
    UserInfo* info = [UserInfo sharedManager];
    [info loadInfo];
    
    [self.yesButton setBackgroundColor:info.appInfo.SecondaryColor];
    [self.yesButton setTitleColor:info.appInfo.TextColor forState:UIControlStateNormal];
    self.yesButton.layer.cornerRadius = 2.0f;
    
    [self.noButton setBackgroundColor:info.appInfo.TextColor];
    [self.noButton setTitleColor:info.appInfo.SecondaryColor forState:UIControlStateNormal];
    self.noButton.layer.cornerRadius = 2.0f;
    
    self.titleLabelQuestion.textColor = info.appInfo.TextColor;
    self.topContainer.backgroundColor = info.appInfo.PrimaryColor;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

+(QuestionDialogViewController * ) setTextsWithTitle:(NSString * ) title withMessage:(NSString *) message withNoButtonText:(NSString * )noText withNoCallback:(void (^)())noCallback withYesText:(NSString * )yesText withYesCallback:(void (^)())yesCallback inView:(UIView *)toShowIn{
    
    QuestionDialogViewController * dialog = [QuestionDialogViewController new];
    dialog.noCallback = noCallback;
    dialog.yesCallback = yesCallback;
    dialog.yesText = yesText;
    dialog.noText = noText;
    dialog.messageText = message;
    dialog.titleText = title;
    [dialog showInView:toShowIn animated:YES];
    return dialog;
}
- (IBAction)onYesClicked:(id)sender {
    if(self.yesCallback!=nil){
        self.yesCallback();
    }
}

- (IBAction)onNoClicked:(id)sender {
    if(self.noCallback!=nil){
        self.noCallback();
    }
}
@end
