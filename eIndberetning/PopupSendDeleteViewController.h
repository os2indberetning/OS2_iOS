//
//  PopupSendDeleteViewController.h
//  OS2Indberetning
//
//  Created by kasper on 9/28/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
//

#import "PopupBaseViewController.h"
#import "SavedReport.h"

@interface PopupSendDeleteViewController : PopupBaseViewController
@property (nonatomic, copy) void (^onClosed)();
-(void) setReport:(SavedReport *)report;
@end
