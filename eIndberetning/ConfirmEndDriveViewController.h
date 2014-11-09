//
//  ConfirmEndDriveViewController.h
//  eIndberetning
//
//  Created by Jacob Hansen on 09/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "PopupBaseViewController.h"

@protocol EndDrivePopupDelegate
-(void)endDrive;
-(void)changeSelectedState:(BOOL)selectedState;
@end

@interface ConfirmEndDriveViewController : PopupBaseViewController

-(void)showPopup;
@property (nonatomic, strong) id<EndDrivePopupDelegate> delegate;
@property (nonatomic) BOOL isSelected;
@end
