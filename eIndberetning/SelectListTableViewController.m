/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  SelectListTableViewController.m
//  eIndberetning
//

#import "SelectListTableViewController.h"
#import "SelectListTableViewCell.h"
#import "Rate.h"
#import "Employment.h"
#import "UIViewController+BackButton.h"
#import "UserInfo.h"

@interface SelectListTableViewController ()
@end

@implementation SelectListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AddBackButton];
    
    switch (self.listType ) {
        case RateList:
        {
            self.navigationItem.title = NSLocalizedString(@"rate_view_title", nil);
            break;
        }
        case EmploymentList:
        {
            self.navigationItem.title = NSLocalizedString(@"organisationalplace_view_title", nil);
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfo* info = [UserInfo sharedManager];
    
    switch (self.listType ) {
        case RateList:
        {
            Rate *r = self.items[indexPath.row];
            self.report.rate = r;
            info.last_rate = r;
            break;
        }
        case EmploymentList:
        {
            Employment *e = self.items[indexPath.row];
            self.report.employment = e;
            info.last_employment = e;
            break;
        }
        default:
            break;
    }
    
    [info saveInfo];
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectListTableViewCell"];
 
    if (cell == nil){
        NSLog(@"New Cell Made");
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SelectListTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
 
    NSString* str = @"";
    NSString* detailText = @"";
    
    switch (self.listType ) {
        case RateList:
        {
            Rate *r = self.items[indexPath.row];
            str = r.rateDescription;
            
            if([r.rateDescription isEqualToString:self.report.rate.rateDescription])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
            break;
        }
        case EmploymentList:
        {
            Employment *e = self.items[indexPath.row];
            str = e.employmentPosition;
            detailText = e.manNr;
            
            if([e.employmentPosition isEqualToString:self.report.employment.employmentPosition])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
            break;
        }
        default:
            break;
    }
    
    cell.detailTextLabel.text = detailText;
    cell.textLabel.text = str;
    return cell;
    
}

@end
