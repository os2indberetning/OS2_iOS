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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
