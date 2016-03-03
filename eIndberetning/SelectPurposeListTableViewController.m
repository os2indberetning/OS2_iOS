/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  SelectPurposeListTableViewController.m
//  eIndberetning
//

#import "SelectPurposeListTableViewController.h"
#import "UIViewController+BackButton.h"
#import "AddPurposeTableViewCell.h"
#import "SelectListTableViewCell.h"
#import "UserInfo.h"
#import "CoreDataManager.h"

@interface SelectPurposeListTableViewController ()
@property (nonatomic, strong) NSArray* items;
@property (nonatomic, strong) CoreDataManager* CDManager;
@property (nonatomic) BOOL isAddingPurpose;
@property (nonatomic) BOOL wasEmpty;
@end

@implementation SelectPurposeListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AddBackButton];
    
    self.isAddingPurpose = false;
    
    self.navigationItem.title = @"Vælg Formål";
    
    self.CDManager = [CoreDataManager sharedeCoreDataManager];
    self.items = [self.CDManager fetchPurposes];
    
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = btn;
}

// Used for adding a purpose
-(void) add
{
    NSLog(@"Add");
    
    self.isAddingPurpose = true;
    
    self.navigationItem.rightBarButtonItem.enabled = false;
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    if(self.wasEmpty){
        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        self.wasEmpty = NO;
    }
    
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationTop)];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.isAddingPurpose = false;
    
    if(textField.text.length > 0)
    {
        Purpose *p = [[Purpose alloc] init];
        p.purpose = textField.text;
        
     
        if([self.items containsObject:p])
        {
            for (Purpose *p1 in self.items) {
                if([p1.purpose isEqualToString:p.purpose])
                {
                    p = p1;
                }
            }
        }
        else
        {
            [self.CDManager insertPurpose:p];
        }
        
        UserInfo* info = [UserInfo sharedManager];
        self.report.purpose = p;
        info.last_purpose = p;
        [info saveInfo];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.wasEmpty){
        Purpose *p = [self.items objectAtIndex:indexPath.row-self.isAddingPurpose];
        p.lastusedate = [NSDate date];
        [self.CDManager updatePurpose:p];
        
        UserInfo* info = [UserInfo sharedManager];
        self.report.purpose = p;
        info.last_purpose = p;
        [info saveInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    NSInteger rows = self.items.count + self.isAddingPurpose;
    
    self.tableView.allowsSelection = YES;
    if(self.items.count == 0){
        if(self.isAddingPurpose){
            if (self.wasEmpty) {
                rows = 0;
            }
//            else{
//                rows = 1;
//            }
        }else{
            rows = 1;
            self.wasEmpty = YES;
            self.tableView.allowsSelection = NO;
        }
    }else{
        self.wasEmpty = NO;
    }
    // Return the number of rows in the section.
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.isAddingPurpose && indexPath.row == 0)
    {
        AddPurposeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPurposeTableViewCell"];
        
        if (cell == nil){
            NSLog(@"New Cell Made");
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AddPurposeTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        cell.purposeTextField.text = @"";
        [cell.purposeTextField becomeFirstResponder];
        cell.purposeTextField.delegate = self;
        return cell;
    }
    else if(self.wasEmpty){
        //Add informative row about how to add new purposes
        SelectListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectListTableViewCell"];
        
        if (cell == nil){
            NSLog(@"New Cell Made");
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SelectListTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        cell.textLabel.text = @"Tryk på '+' for at tilføje et nyt formål";
        
        return cell;
    }
    else
    {
        SelectListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectListTableViewCell"];
        
        if (cell == nil){
            NSLog(@"New Cell Made");
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SelectListTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        Purpose* p = self.items[indexPath.row+self.isAddingPurpose];
        
        if([p isEqual:self.report.purpose])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        cell.textLabel.text = p.purpose;
        return cell;
    }
}

@end