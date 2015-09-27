//
//  SavedViewControllers.m
//  OS2Indberetning
//
//  Created by kasper on 9/28/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
//

#import "SavedViewControllers.h"
#import "SavedReportTableCellView.h"
@interface SavedViewControllers ()

@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@end
@implementation SavedViewControllers


-(void)viewDidLoad{
    [super viewDidLoad];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SavedReportTableCellView *  cell = [tableView dequeueReusableCellWithIdentifier:@"savedReportsCelles"];
    
    NSString * date =@"24/9 - 2015";
    NSString * distanceText = @"0,03km";
    NSString * purpose = @"Itminds test";
    NSString * rateText = @"kørsel..";
    
    cell.dateLabel.text = date;
    cell.distanceLabel.text = distanceText;
    cell.purposeLabel.text = purpose;
    cell.rateLabel.text = rateText;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


@end
