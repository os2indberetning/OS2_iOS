//
//  FinishDriveTableViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 05/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "FinishDriveTableViewController.h"
#import "SelectListTableViewController.h"
#import "ErrorMsgViewController.h"
#import "ManualEntryViewController.h"
#import "EditKmViewController.h"
#import "eMobilityHTTPSClient.h"
#import "SelectPurposeListTableViewController.h"
#import "UserInfo.h"
#import "UIColor+CustomColor.h"
#import "CoreDataManager.h"
#import "ErrorMsgViewController.h"


@interface FinishDriveTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *purposeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *organisationalPlaceTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *startAtHomeCheckbox;
@property (weak, nonatomic) IBOutlet UIImageView *endAtHomeCheckbox;
@property (weak, nonatomic) IBOutlet UILabel *kmDrivenLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;


@property (strong, nonatomic) NSArray *rates;
@property (strong, nonatomic) NSArray *employments;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong,nonatomic) UserInfo* info;
@property (strong,nonatomic) Profile* profile;

@property (nonatomic,strong) CoreDataManager* CDManager;

@property (strong, nonatomic) ErrorMsgViewController* errorMsg;
@property (strong, nonatomic) ConfirmDeleteViewController* confirmPopup;
@end

@implementation FinishDriveTableViewController

-(CoreDataManager*)CDManager
{
    return [CoreDataManager sharedeCoreDataManager];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.info = [UserInfo sharedManager];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:YES];
    self.tableView.rowHeight = 44;
    
    self.deleteButton.layer.cornerRadius = 1.5f;
    self.uploadButton.layer.cornerRadius = 1.5f;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor favrOrangeColor];
    self.refreshControl.tintColor = [UIColor favrGreenColor];
    [self.refreshControl addTarget:self
                            action:@selector(manualRefresh)
                  forControlEvents:UIControlEventValueChanged];
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.rates = [self.CDManager fetchRates];
    self.employments = [self.CDManager fetchEmployments];
}

-(void)manualRefresh
{
    [self performSegueWithIdentifier:@"ShowSyncSegue" sender:self];
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.info.guid)
    {
        AppDelegate* del =  [[UIApplication sharedApplication] delegate];
        [del changeToLoginView];
    }
    
    //Fill in the selected data in the forms
    self.userTextLabel.text = [NSString stringWithFormat:@"Bruger: %@", self.info.name];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    self.kmDrivenLabel.text = [[f stringFromNumber:self.report.route.totalDistanceEdit] stringByAppendingString:@" km"];;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM-YY"];
    self.dateLabel.text = [@"Dato: " stringByAppendingString:[formatter stringFromDate:self.report.date]];
    
    NSString *checkState = (self.report.didstarthome) ? @"checkBox_checked" : @"checkBox_unchecked";
    self.startAtHomeCheckbox.image = [UIImage imageNamed:checkState];
    
    NSString *checkState2 = (self.report.didendhome) ? @"checkBox_checked" : @"checkBox_unchecked";
    self.endAtHomeCheckbox.image = [UIImage imageNamed:checkState2];
    
    //Set selected or default values
    self.purposeTextLabel.text = self.report.purpose.purpose;
    
    if(self.report.rate)
        self.rateTextLabel.text = self.report.rate.type;
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
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
        NSString *checkState = (self.report.didstarthome) ? @"checkBox_checked" : @"checkBox_unchecked";
        self.startAtHomeCheckbox.image = [UIImage imageNamed:checkState];
    }
    else if(indexPath.row == 7)
    {
        self.report.didendhome = !self.report.didendhome;
        NSString *checkState = (self.report.didendhome) ? @"checkBox_checked" : @"checkBox_unchecked";
        self.endAtHomeCheckbox.image = [UIImage imageNamed:checkState];
    }
    
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
    
    if([self.info isLastSyncDateNotToday])
    {
        [self performSegueWithIdentifier:@"ShowSyncSegue" sender:self];
    }
    else
    {
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
}

#pragma mark - Finish Upload

-(void)didFinishUpload
{
    self.report.shouldReset = true;
    [self.navigationController popToRootViewControllerAnimated:true];
}

#pragma mark - Sync

-(void)tokenNotFound
{
    [self.info resetInfo];
    [self.info saveInfo];
    //ViewWillAppear takes care of the rest
}

-(void)didFinishSyncWithProfile:(Profile*)profile AndRate:(NSArray*)rates;
{
    self.rates = rates;
    self.profile = profile;
    self.employments = profile.employments;
    
    //Insert into coredate
    [self.CDManager deleteAllObjects:@"CDRate"];
    [self.CDManager deleteAllObjects:@"CDEmployment"];
    
    [self.CDManager insertEmployments:self.employments];
    [self.CDManager insertRates:self.rates];
    
    //Transfer userdata to local userinfo object
    self.info.last_sync_date = [NSDate date];
    self.info.name = [NSString stringWithFormat:@"%@ %@", profile.FirstName, profile.LastName];
    self.info.home_loc = profile.homeCoordinate;

    for (Token* tkn in profile.tokens) {
        if([tkn.guid isEqualToString:self.info.guid])
        {
            if(![tkn.status isEqualToString:@"1"])
            {
                self.info.guid = nil;
            }
            
            break;
        }
    }
    
    [self.info saveInfo];
    [self reloadReport];
}

-(void)reloadReport
{
    //Confirm employments and rates ares till the same
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
    else if ([[segue identifier] isEqualToString:@"ShowSyncSegue"])
    {
        SyncViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"UploadDriveSegue"])
    {
        UploadDriveViewController *vc = [segue destinationViewController];
        vc.report = self.report;
        vc.delegate = self;
    }
}


@end
