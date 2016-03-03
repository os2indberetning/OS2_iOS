/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  AddPurposeTableViewCell.h
//  eIndberetning
//

#import <UIKit/UIKit.h>

@interface AddPurposeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *purposeTextField;
@property (weak, nonatomic) IBOutlet UIButton *addNewPurpose;

@end
