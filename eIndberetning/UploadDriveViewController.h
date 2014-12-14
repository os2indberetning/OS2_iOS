//
//  UploadDriveViewController.h
//  eIndberetning
//
//  Created by Jacob Hansen on 09/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriveReport.h"

@protocol DidUploadDelegate
-(void)didFinishUpload;
-(void)tokenNotFound;
@end

@interface UploadDriveViewController : UIViewController
@property (nonatomic,strong) DriveReport* report;
@property (strong,nonatomic) id <DidUploadDelegate> delegate;
@end
