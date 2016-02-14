//
//  UserLoginViewController.h
//  OS2Indberetning
//
//  Created by Marc le Fevre Johansen on 14/02/16.
//  Copyright © 2016 IT-Minds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppInfo.h"

@interface UserLoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) AppInfo *appInfo;

@end
