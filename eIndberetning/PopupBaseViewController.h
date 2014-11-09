//
//  PopupBaseViewController.h
//  eIndberetning
//
//  Created by Jacob Hansen on 09/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PopupBaseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic)NSString *titelString;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)removeAnimate;
@end
