//
//  PopupViewController.h
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PopupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *popUpView;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@end
