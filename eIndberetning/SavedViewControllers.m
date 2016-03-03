/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  SavedViewControllers.m
//  OS2Indberetning
//

#import "SavedViewControllers.h"
#import "UIViewController+BackButton.h"
#import "SavedReportTableCellView.h"
#import "Settings.h"
#import "PopupSendDeleteViewController.h"

@interface SavedViewControllers ()

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (strong) PopupSendDeleteViewController * popup;

@property NSArray* reports;
@end
@implementation SavedViewControllers


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    [self AddBackButton];
}

-(void)reloadTable{
    _reports = [Settings getAllSavedReports];
    [_mainTable reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SavedReportTableCellView *  cell = [tableView dequeueReusableCellWithIdentifier:@"savedReportsCelles"];
    SavedReport * rep = [_reports objectAtIndex:indexPath.row];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =  @"dd/MM - YYYY";
    
    
    NSString * date =[NSString stringWithFormat:@"Rapporteret den %@", [formatter stringFromDate:rep.createdAt]];
    NSString * distanceText = [NSString stringWithFormat:@"Distance : %@ km", rep.totalDistance];
    NSString * purpose = [NSString stringWithFormat:@"Formål : %@", rep.purpose];
    
    NSString * rateText = [NSString stringWithFormat:@"Takst : %@", rep.rate];

    
    cell.dateLabel.text = date;
    cell.distanceLabel.text = distanceText;
    cell.purposeLabel.text = purpose;
    cell.rateLabel.text = rateText;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row> [_reports count]){
        return;
    }
    SavedReport * rep = [_reports objectAtIndex:indexPath.row];
    _popup = [PopupSendDeleteViewController new];
    [_popup setReport:rep];
    __weak SavedViewControllers * tempSelf = self;
    [_popup setOnClosed:^{
        tempSelf.popup.onClosed = nil;
        [tempSelf reloadTable];
    } ];

    [_popup showInView:self.view.superview animated:YES];
   }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_reports==nil){
        return 0;
    }
    return [_reports count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadTable];
}

@end
