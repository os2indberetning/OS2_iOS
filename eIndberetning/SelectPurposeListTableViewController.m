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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *labelWrapper;

@end

@implementation SelectPurposeListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AddBackButton];
    
    self.isAddingPurpose = false;
    
    self.navigationItem.title = @"Vælg Formål";
    
    self.CDManager = [CoreDataManager sharedeCoreDataManager];
    self.items = [self.CDManager fetchPurposes];
    
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddPurpose)];
    self.navigationItem.rightBarButtonItem = btn;
    
    //Setup shadow for labelWrapper
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.labelWrapper.bounds];
    self.labelWrapper.layer.masksToBounds = NO;
    self.labelWrapper.layer.shadowColor = [UIColor blackColor].CGColor;
    self.labelWrapper.layer.shadowOffset = CGSizeMake(0.0f, -0.1f);
    self.labelWrapper.layer.shadowOpacity = 0.2f;
    self.labelWrapper.layer.shadowPath = shadowPath.CGPath;
    
}

// Used for adding a purpose
-(void) showAddPurpose
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

    [self addPurposeFromTextField:textField];
    
    return NO;
}

- (void) addPurposeFromTextField:(UITextField *)textField {
    if(textField.text.length > 0)
    {
        self.isAddingPurpose = false;
        
        Purpose *p = [[Purpose alloc] init];
        p.purpose = textField.text;
        
        [self usePurpose:p];
    }
}

- (void) usePurpose:(Purpose *)p{
    p.lastusedate = [NSDate date];
    
    if([self.items containsObject:p])
    {
        for (Purpose *p1 in self.items) {
            if([p1.purpose isEqualToString:p.purpose])
            {
                p = p1;
                p.lastusedate = [NSDate date];
                [self.CDManager updatePurpose:p];
                break;
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) useNewPurposeButtonPressed {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    AddPurposeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    
    if(cell != nil){
        [self addPurposeFromTextField:cell.purposeTextField];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 && self.isAddingPurpose){
        return;
    }
    if(!self.wasEmpty){
        Purpose *p = [self.items objectAtIndex:indexPath.row-self.isAddingPurpose];
        [self usePurpose:p];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((self.isAddingPurpose || self.wasEmpty) && indexPath.row == 0) {
        return UITableViewCellEditingStyleNone;
    }
    
    return UITableViewCellEditingStyleDelete;
}

-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Slet";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfo* info = [UserInfo sharedManager];

    Purpose *p = [self.items objectAtIndex:indexPath.row-self.isAddingPurpose];
    
    if([info.last_purpose isEqual:p]){
        self.report.purpose = nil;
        info.last_purpose = nil;
        [info saveInfo];
    }
    
    [self.CDManager deletePurpose:p];
    self.items = [self.CDManager fetchPurposes];
    [tableView reloadData];
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
    //Check if we have any items stored locally
    if(self.items.count == 0){
        //Check if we just pressed the add button
        if(self.isAddingPurpose){
            //Check if we just removed the empty label
            if (self.wasEmpty) {
                //This needs to be here to keep the tableView consistent with how many views there actually is
                //It is zero now, since we just removed the empty view and there were no other views.
                rows = 0;
            }
        }else{
            //If not, then set flag to show empty label
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
        
        UserInfo* info = [UserInfo sharedManager];
        
        cell.addNewPurpose.backgroundColor = info.appInfo.PrimaryColor;
        [cell.addNewPurpose setTitleColor:info.appInfo.TextColor forState:UIControlStateNormal];
        
        [cell.addNewPurpose addTarget:self action:@selector(useNewPurposeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
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
        
        cell.detailTextLabel.text = nil;
        cell.textLabel.text = @"Tryk på '+' for at tilføje et nyt formål";
        cell.accessoryType = UITableViewCellAccessoryNone;
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
        NSInteger row = indexPath.row;
        Purpose* p = self.items[row-self.isAddingPurpose];
        
        if([p isEqual:self.report.purpose])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.detailTextLabel.text = nil;
        cell.textLabel.text = p.purpose;
        return cell;
    }
}

@end