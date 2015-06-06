//
//  ViewController.h
//  eIndberetning
//
//  Created by Jacob Hansen on 24/09/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppInfo.h"

@interface InitialViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) AppInfo* appInfo;
@end

