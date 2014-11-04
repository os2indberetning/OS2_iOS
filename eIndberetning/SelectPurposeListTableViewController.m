//
//  SelectPurposeListTableViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 04/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
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
    Purpose *p = [self.items objectAtIndex:indexPath.row-self.isAddingPurpose];
    p.lastusedate = [NSDate date];
    [self.CDManager updatePurpose:p];
    
    UserInfo* info = [UserInfo sharedManager];
    self.report.purpose = p;
    info.last_purpose = p;
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
    return self.items.count + self.isAddingPurpose;
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