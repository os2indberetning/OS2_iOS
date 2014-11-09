//
//  ConfirmDeleteViewController.h
//  eIndberetning
//
//  Created by Jacob Hansen on 09/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "PopupBaseViewController.h"

@protocol ConfirmDeletePopupDelegate
-(void)confirmDelete;
@end

@interface ConfirmDeleteViewController : PopupBaseViewController

-(void)showPopup;
@property (nonatomic, strong) id<ConfirmDeletePopupDelegate> delegate;
@end
