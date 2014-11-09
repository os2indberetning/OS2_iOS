//
//  ErrorMsgViewController.h
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupBaseViewController.h"

@interface ErrorMsgViewController : PopupBaseViewController

-(void)showErrorMsg:(NSString*)error;
@end
