//
//  QuestionDialogViewController.h
//  OS2Indberetning
//
//  Created by kasper on 9/29/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
//

#import "PopupBaseViewController.h"

@interface QuestionDialogViewController : PopupBaseViewController
+(QuestionDialogViewController * ) setTextsWithTitle:(NSString * ) title withMessage:(NSString *) message withNoButtonText:(NSString * )noText withNoCallback:(void (^)())noCallback withYesText:(NSString * )yesText withYesCallback:(void (^)())yesCallback inView:(UIView *)toShowIn;
@end
