//
//  QuestionDialogViewController.m
//  OS2Indberetning
//
//  Created by kasper on 9/29/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
//

#import "QuestionDialogViewController.h"

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
