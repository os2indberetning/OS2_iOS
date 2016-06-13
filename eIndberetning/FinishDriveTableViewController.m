/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  FinishDriveTableViewController.m
//  eIndberetning
//

#import "FinishDriveTableViewController.h"
#import "SelectListTableViewController.h"
#import "ErrorMsgViewController.h"
#import "ManualEntryViewController.h"
#import "EditKmViewController.h"
#import "EditFourKmRuleKmViewController.h"
#import "eMobilityHTTPSClient.h"
#import "SelectPurposeListTableViewController.h"
#import "UserInfo.h"
#import "UIColor+CustomColor.h"
#import "CoreDataManager.h"
#import "ErrorMsgViewController.h"
#import "CheckMarkImageView.h"
#import "Settings.h"
#import "SavedReport.h"

@interface FinishDriveTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *purposeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *organisationalPlaceTextLabel;
@property (weak, nonatomic) IBOutlet CheckMarkImageView *startAtHomeCheckbox;
@property (weak, nonatomic) IBOutlet CheckMarkImageView *endAtHomeCheckbox;
@property (weak, nonatomic) IBOutlet UILabel *kmDrivenLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UITableView *FourKmTableView;


@property (strong, nonatomic) NSArray *rates;
@property (strong, nonatomic) NSArray *employments;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong,nonatomic) UserInfo* info;

@property (nonatomic,strong) CoreDataManager* CDManager;

@property (strong, nonatomic) ErrorMsgViewController* errorMsg;
@property (strong, nonatomic) ConfirmDeleteViewController* confirmPopup;

@property (strong, nonatomic) CheckMarkImageView *fourKmCheckbox;
@property (strong, nonatomic) UILabel *fourKmRuleKmLabel;

@property (strong, nonatomic) NSNumber *tempFourKmRuleDistance;

@end


@implementation FinishDriveTableViewController

-(CoreDataManager*)CDManager
{
    return [CoreDataManager sharedeCoreDataManager];
}

-(void)setupVisuals
{
    UserInfo* info = [UserInfo sharedManager];
    [info loadInfo];
    
    [self.deleteButton setBackgroundColor:info.appInfo.TextColor];
    [self.deleteButton setTitleColor:info.appInfo.SecondaryColor forState:UIControlStateNormal];
    self.deleteButton.layer.cornerRadius = 1.5f;
    
    [self.uploadButton setBackgroundColor:info.appInfo.SecondaryColor];
    [self.uploadButton setTitleColor:info.appInfo.TextColor forState:UIControlStateNormal];
    self.uploadButton.layer.cornerRadius = 1.5f;
    
  /*  self.refreshControl.backgroundColor = info.appInfo.SecondaryColor;
    self.refreshControl.tintColor = info.appInfo.PrimaryColor;
*/
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.info = [UserInfo sharedManager];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:YES];
    self.tableView.rowHeight = 44;
    
 /*   self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(manualRefresh)
                  forControlEvents:UIControlEventValueChanged];
    
    */
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //Load employments and rates
    self.rates = [self.CDManager fetchRates];
    self.employments = [self.CDManager fetchEmployments];
    [self setupVisuals];
    
    if(_shouldShowInAccuracyWarning){
        self.errorMsg = [[ErrorMsgViewController alloc] initWithNibName:@"ErrorMsgViewController" bundle:nil];
        [self.errorMsg showErrorMsg:@"OBS!" errorString:@"Under turen har der været et eller flere udfald i GPS forbindelsen. Vær derfor særligt opmærksom på, om afstanden og ruten passer med det forventede."];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Fill in the selected data in the forms
    self.userTextLabel.text = [NSString stringWithFormat:@"Bruger: %@", self.info.name];

    self.kmDrivenLabel.text = [NSString stringWithFormat:@"%.01f Km", [self.report.route.totalDistanceEdit floatValue]];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM-YY"];
    self.dateLabel.text = [@"Dato: " stringByAppendingString:[formatter stringFromDate:self.report.date]];
    
    [self.startAtHomeCheckbox setCheckMarkState:self.report.didstarthome];
    [self.endAtHomeCheckbox setCheckMarkState:self.report.didendhome];
    
    //Set selected or default values
    self.purposeTextLabel.text = self.report.purpose.purpose;
    
    if(self.report.rate)
        self.rateTextLabel.text = self.report.rate.rateDescription;
    else
        self.rateTextLabel.text = @"Vælg Takst";
    
    if(self.report.manuelentryremark)
        self.commentTextLabel.text = self.report.manuelentryremark;
    else
        self.commentTextLabel.text = @"Indtast Bemærkning";
    
    if(self.report.employment)
        self.organisationalPlaceTextLabel.text = self.report.employment.employmentPosition;
    else
        self.organisationalPlaceTextLabel.text  = @"Vælg Placering";
    
    if (self.fourKmRuleKmLabel)
    {
        [self.fourKmRuleKmLabel setText:[NSString stringWithFormat:@"%.01f Km", [self.report.fourKmRuleDistance floatValue]]];
    }
    
    NSIndexPath *indexPath = self.FourKmTableView.indexPathForSelectedRow;
    if (indexPath)
    {
        [self.FourKmTableView deselectRowAtIndexPath:indexPath animated:animated];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView.restorationIdentifier isEqualToString:@"FourKmRuleTableView"])
    {
        return 2;
    }
    else
    {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView.restorationIdentifier isEqualToString:@"FourKmRuleTableView"])
    {
        UITableViewCell *cell;
        if (indexPath.row == 0)
        {
            NSString *identifier = @"FourKmRuleCheckCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            self.fourKmCheckbox = (CheckMarkImageView *)[cell viewWithTag:101];
            
            [self.fourKmCheckbox setCheckMarkState:self.report.fourKmRule];
        }
        else
        {
            NSString *identifier = @"FourKmRuleDistanceCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            self.fourKmRuleKmLabel = (UILabel *)[cell viewWithTag:201];
            
            [self.fourKmRuleKmLabel setText:[NSString stringWithFormat:@"%.01f Km", [self.report.fourKmRuleDistance floatValue]]];
        }
        return cell;
    }
    else
    {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView.restorationIdentifier isEqualToString:@"TableView"])
    {
        if(indexPath.row == 1)
        {
            SelectPurposeListTableViewController *vc=[[SelectPurposeListTableViewController alloc]initWithNibName:@"SelectPurposeListTableViewController" bundle:nil];
            vc.report = self.report;
            [self.navigationController pushViewController:vc animated:true];
        }
        else if(indexPath.row < 4)
        {
            SelectListTableViewController *vc=[[SelectListTableViewController alloc]initWithNibName:@"SelectListTableViewController" bundle:nil];
            vc.report = self.report;
            
            switch (indexPath.row) {
                case 2:
                {
                    vc.listType = EmploymentList;
                    vc.items = self.employments;
                    vc.report = self.report;
                    break;
                }
                case 3:
                {
                    vc.listType = RateList;
                    vc.items = self.rates;
                    vc.report = self.report;
                    break;
                }
                default:
                    break;
            }
            
            [self.navigationController pushViewController:vc animated:true];
        }
        else if(indexPath.row == 4)
        {
            ManualEntryViewController *vc=[[ManualEntryViewController alloc]initWithNibName:@"ManualEntryViewController" bundle:nil];
            vc.report = self.report;
            [self.navigationController pushViewController:vc animated:true];
        }
        else if(indexPath.row == 6)
        {
            self.report.didstarthome = !self.report.didstarthome;
            [self.startAtHomeCheckbox setCheckMarkState:self.report.didstarthome];
        }
        else if(indexPath.row == 7)
        {
            self.report.didendhome = !self.report.didendhome;
            [self.endAtHomeCheckbox setCheckMarkState:self.report.didendhome];
        } else if(indexPath.row == 8)
        {
        
        }
    }
    else if([tableView.restorationIdentifier isEqualToString:@"FourKmRuleTableView"])
    {
        if (indexPath.row == 0)
        {
            self.report.fourKmRule = !self.report.fourKmRule;
            [self.fourKmCheckbox setCheckMarkState:self.report.fourKmRule];
            if (self.report.fourKmRule)
            {
                self.report.fourKmRuleDistance = self.tempFourKmRuleDistance;
                [self.fourKmRuleKmLabel setText:[NSString stringWithFormat:@"%.01f Km", [self.report.fourKmRuleDistance floatValue]]];
                
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
            }
            else if (!self.report.fourKmRule)
            {
                self.tempFourKmRuleDistance = self.report.fourKmRuleDistance;

                self.report.fourKmRuleDistance = 0;
                [self.fourKmRuleKmLabel setText:[NSString stringWithFormat:@"%.01f Km", [self.report.fourKmRuleDistance floatValue]]];
                
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
            }
        }
        else if (indexPath.row == 1)
        {
            EditFourKmRuleKmViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditFourKmRuleViewController"];
            vc.report = self.report;
            
            [self.navigationController pushViewController:vc animated:true];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView.restorationIdentifier isEqualToString:@"TableView"])
    {
        if (indexPath.row == 8)
        {
            if (self.report.fourKmRule)
            {
                return 105.0f;
            }
            else
            {
                return 50.0f;
            }
        }
    }
    else if([tableView.restorationIdentifier isEqualToString:@"FourKmRuleTableView"])
    {
        if (indexPath.row == 0)
        {
            return 50.0;
        }
        else
        {
            return 55.0;
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (IBAction)cancelAndDeleteButton:(id)sender
{
    self.confirmPopup = [[ConfirmDeleteViewController alloc] initWithNibName:@"ConfirmDeleteViewController" bundle:nil];
    self.confirmPopup.delegate = self;
    [self.confirmPopup showPopup];
}

- (void)confirmDelete
{
    self.report.shouldReset = true;
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (IBAction)submitButton:(id)sender {

    if(!self.report.purpose)
    {
        self.errorMsg = [[ErrorMsgViewController alloc] initWithNibName:@"ErrorMsgViewController" bundle:nil];
        [self.errorMsg showErrorMsg: @"Du mangler at vælge\net formål"];
    }
    else if(!self.report.rate)
    {
        self.errorMsg = [[ErrorMsgViewController alloc] initWithNibName:@"ErrorMsgViewController" bundle:nil];
        [self.errorMsg showErrorMsg: @"Du mangler at vælge\nen takst"];
    }
    else if(!self.report.employment)
    {
        self.errorMsg = [[ErrorMsgViewController alloc] initWithNibName:@"ErrorMsgViewController" bundle:nil];
        [self.errorMsg showErrorMsg: @"Du mangler at vælge\nen stilling"];
    }
    else
    {
        [self performSegueWithIdentifier:@"UploadDriveSegue" sender:self];
    }
}

#pragma mark - Finish Upload

-(void)didFinishUpload
{
    self.report.shouldReset = true;
    [self.navigationController popToRootViewControllerAnimated:true];
}

-(void)authorizationNotFound
{
    [self.info resetInfo];
    [self.info saveInfo];
}

-(void)reloadReport
{
    //Reload employments and rates
    self.rates = [self.CDManager fetchRates];
    self.employments = [self.CDManager fetchEmployments];
    
    //Confirm employments and rates ares still the same
    if([self.employments containsObject:self.info.last_employment])
        self.report.employment = self.info.last_employment;
    else
        self.report.employment = nil;
    
    if([self.rates containsObject:self.info.last_rate])
        self.report.rate = self.info.last_rate;
    else
        self.report.rate = nil;
    
    self.report.date = [NSDate date];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM-YY"];
    
    self.dateLabel.text = [@"Dato: " stringByAppendingString:[formatter stringFromDate:self.report.date]];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"EditKmSegue"])
    {
        EditKmViewController *vc = [segue destinationViewController];
        vc.route = self.report.route;
    }
    else if ([[segue identifier] isEqualToString:@"UploadDriveSegue"])
    {
        UploadDriveViewController *vc = [segue destinationViewController];
        vc.report = self.report;
        vc.delegate = self;
    }
    else if([[segue identifier] isEqualToString:@"EditFourKmRuleKmSegue"])
    {
        EditFourKmRuleKmViewController *vc = [segue destinationViewController];
        vc.report = self.report;
    }
}
#pragma mark State Preservation
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.report forKey:@"DriveReport"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    self.report = [coder decodeObjectForKey:@"DriveReport"];
}
@end
