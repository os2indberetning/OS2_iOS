//
//  SavedReportTableCellView.h
//  OS2Indberetning
//
//  Created by kasper on 9/28/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedReportTableCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purposeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@end
