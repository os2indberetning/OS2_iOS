//
//  ManualEntryViewController.h
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriveReport.h"

@interface ManualEntryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) DriveReport* report;
@end
