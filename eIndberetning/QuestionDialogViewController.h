/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  QuestionDialogViewController.h
//  OS2Indberetning
//

#import "PopupBaseViewController.h"

@interface QuestionDialogViewController : PopupBaseViewController
+(QuestionDialogViewController * ) setTextsWithTitle:(NSString * ) title withMessage:(NSString *) message withNoButtonText:(NSString * )noText withNoCallback:(void (^)())noCallback withYesText:(NSString * )yesText withYesCallback:(void (^)())yesCallback inView:(UIView *)toShowIn;
@end
