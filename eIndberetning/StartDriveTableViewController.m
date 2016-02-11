/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  StartDriveTableViewController.m
//  eIndberetning
//

#import "StartDriveTableViewController.h"
#import "UIColor+CustomColor.h"
#import "SelectListTableViewController.h"
#import "ErrorMsgViewController.h"
#import "UserInfo.h"
#import "Employment.h"
#import "Rate.h"
#import "ManualEntryViewController.h"
#import "DriveViewController.h"
#import "Profile.h"
#import "Rate.h"
#import "CoreDataManager.h"
#import "SelectPurposeListTableViewController.h"
#import "DriveReport.h"
#import "AppDelegate.h"
#import "CheckMarkImageView.h"
#import "Settings.h"

#import "ConfirmDeleteViewController.h"
#import "SyncHelper.h"

@interface StartDriveTableViewController ()
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *taskTextField;
@property (weak, nonatomic) IBOutlet UILabel *purposeTextField;
@property (weak, nonatomic) IBOutlet UILabel *organisationalPlaceTextField;
@property (weak, nonatomic) IBOutlet CheckMarkImageView *startAtHomeCheckbox;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *startDriveButton;

@property (strong, nonatomic) ErrorMsgViewController* errorMsg;
@property (strong, nonatomic) NSArray *rates;
@property (strong, nonatomic) NSArray *employments;


@property (strong,nonatomic) DriveReport* report;

@property (strong,nonatomic) UserInfo* info;

@property (nonatomic) BOOL shouldSync;
@property (nonatomic, strong) GPSManager* gpsManager;
@property (nonatomic,strong) CoreDataManager* CDManager;
@end

@implementation StartDriveTableViewController

-(CoreDataManager*)CDManager
{
    return [CoreDataManager sharedeCoreDataManager];
}

-(void)setupVisuals
{
    UserInfo* info = [UserInfo sharedManager];
    [info loadInfo];
    
    [self.startDriveButton setBackgroundColor:info.appInfo.SecondaryColor];
    [self.startDriveButton setTitleColor:info.appInfo.TextColor forState:UIControlStateNormal];
    self.startDriveButton.layer.cornerRadius = 1.5f;
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:info.appInfo.PrimaryColor];
    [self.navigationController.navigationBar setTintColor:info.appInfo.SecondaryColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : info.appInfo.TextColor}];
    
    /*   self.refreshControl.backgroundColor = info.appInfo.SecondaryColor;
     self.refreshControl.tintColor = info.appInfo.PrimaryColor;*/
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Compare last sync date and current date, to see if we should sync, or simply load from coredata
    self.info = [UserInfo sharedManager];
    [self.info loadInfo];
    
    if([self.info isLastSyncDateNotToday])
    {
        self.shouldSync = true;
    }
    else
    {
        [self loadReport];
    }
    
    self.gpsManager = [GPSManager sharedGPSManager];
    
    self.tableView.rowHeight = 44;
    
    /*  self.refreshControl = [[UIRefreshControl alloc] init];
     [self.refreshControl addTarget:self
     action:@selector(manualRefresh)
     forControlEvents:UIControlEventValueChanged];
     
     */
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setupVisuals];
    self.shouldSync = false;
    __block UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center =self.view.center;
    indicator.frame = [self.navigationController view].frame;
    indicator.backgroundColor = [UIColor colorWithRed:0.6667 green:0.6667 blue:0.6667 alpha:0.50];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    [SyncHelper doSync:^(Profile * profile, NSArray * rates) {
        [indicator removeFromSuperview];
        [self didFinishSyncWithProfile:profile AndRate:rates];
    } withErrorCallback:^(NSInteger errorCode) {
        [indicator removeFromSuperview];
        if(errorCode==0){
            return;
        }
        [self tokenNotFound];
    }];

}
/*
 -(void)manualRefresh
 {
 //Stop gps, and remove delegate (cause we need to refresh with the new information)
 [self.gpsManager stopGPS];
 self.gpsManager.delegate = nil;
 
 [self performSegueWithIdentifier:@"ShowSyncSegue" sender:self];
 [self.refreshControl endRefreshing];
 }*/

-(void)loadReport
{
    self.rates = [self.CDManager fetchRates];
    self.employments = [self.CDManager fetchEmployments];
    
    //Create new drive report
    self.report = [[DriveReport alloc] init];
    
    Route *route = [[Route alloc] init];
    self.report.route = route;
    
    self.report.profileId = self.info.profileId;
    
  //  NSArray* purposes = [self.CDManager fetchPurposes];
    
    //Load default report settings
//    if([purposes containsObject:self.info.last_purpose])
//        self.report.purpose = self.info.last_purpose;
    
    if([self.employments containsObject:self.info.last_employment])
        self.report.employment = self.info.last_employment;
    
    if([self.rates containsObject:self.info.last_rate])
        self.report.rate = self.info.last_rate;
    
    self.report.date = [NSDate date];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM-YY"];
    self.dateLabel.text = [@"Dato: " stringByAppendingString:[formatter stringFromDate:self.report.date]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.report.shouldReset){
        [self loadReport];
    }
    
    if(self.report.purpose){
        self.purposeTextField.text = self.report.purpose.purpose;
    }else{
        self.purposeTextField.text = @"Vælg Formål";
    }
    if(self.report.rate){
        self.taskTextField.text = self.report.rate.rateDescription;
    }else{
        self.taskTextField.text = @"Vælg Takst";
    }
    if(self.report.manuelentryremark){
        self.commentTextView.text = self.report.manuelentryremark;
    } else {
        self.commentTextView.text = @"Indtast Bemærkning";
    }
    if(self.report.employment){
        self.organisationalPlaceTextField.text = self.report.employment.employmentPosition;
    }else{
        self.organisationalPlaceTextField.text  = @"Vælg Placering";
    }
    [self.startAtHomeCheckbox setCheckMarkState:self.report.didstarthome];
    
    //Setup number for saved reports if any
    NSMutableArray *savedReports = [Settings getAllSavedReports];
    if(savedReports){
        if(savedReports.count > 0){
            [_MissingReportsLabel setHidden:NO];
            _MissingReportsLabel.clipsToBounds = YES;
            _MissingReportsLabel.layer.cornerRadius = _MissingReportsLabel.frame.size.width/2;
            _MissingReportsLabel.backgroundColor = [UIColor whiteColor];
            _MissingReportsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)savedReports.count];
        }else{
            [_MissingReportsLabel setHidden:YES];
        }
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!self.info.token)
    {
        if(self.gpsManager)
        {
            [self.gpsManager stopGPS];
            self.gpsManager.delegate = nil;
        }
        
        AppDelegate* del =  [[UIApplication sharedApplication] delegate];
        [del changeToLoginView];
        return;
    }
    
     //If we are not syncing, check home address - but only if we are not the delegate yet
    if(![self.gpsManager.delegate isEqual:self])
    {
        self.gpsManager.delegate = self;
        [self.gpsManager startGPS];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startDrivingButton:(id)sender {
    
    BOOL permission = [self.gpsManager requestAuthorization];
    
    if(!self.report.purpose)
    {
        self.errorMsg = [[ErrorMsgViewController alloc] initWithNibName:@"ErrorMsgViewController" bundle:nil];
        [self.errorMsg showErrorMsg: @"Du mangler at vælge\net formål"];
    }
    else if(!permission){
        [self showGPSPermissionDenied];
    }else{
        [self performSegueWithIdentifier:@"DriveViewSegue" sender:self];
    }
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
                break;
            }
            case 3:
            {
                vc.listType = RateList;
                vc.items = self.rates;
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
    else if(indexPath.row == 5)
    {
        self.report.didstarthome = !self.report.didstarthome;
        [self.startAtHomeCheckbox setCheckMarkState:self.report.didstarthome];
    }
    
}

#pragma mark Sync

-(void)tokenNotFound
{
    [self.info resetInfo];
    [self.info saveInfo];
    //ViewWillAppear takes care of the rest
}

-(void)didFinishSyncWithProfile:(Profile*)profile AndRate:(NSArray*)rates;
{
    //Insert into coredata
    [self.CDManager deleteAllObjects:@"CDRate"];
    [self.CDManager deleteAllObjects:@"CDEmployment"];
    
    [self.CDManager insertEmployments:profile.employments];
    [self.CDManager insertRates:rates];
    
    //Transfer userdata to local userinfo object
    self.info.last_sync_date = [NSDate date];
    self.info.name = [NSString stringWithFormat:@"%@ %@", profile.FirstName, profile.LastName];
    self.info.home_loc = profile.homeCoordinate;
    self.info.profileId = profile.profileId;
    
    for (Token* tkn in profile.tokens) {
        if([tkn.guid isEqualToString:self.info.token.guid])
        {
            if(![tkn.status isEqualToString:@"1"])
            {
                self.info.token = nil;
            }
            
            break;
        }
    }
    
    [self.info saveInfo];
    
    // [self loadReport];
}

#pragma mark GPSUpdateDelegate

-(void)showGPSPermissionDenied
{
    NSString* title = @"Lokation er ikke tilgængelig";
    NSString *message = @"For at bruge appen, skal lokation gøres tilgængelig";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Afbryd"
                                              otherButtonTitles:@"Indstillinger", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:true];
    }
}

-(void)gotNewGPSCoordinate:(CLLocation *)location
{
    if (location.horizontalAccuracy < 200)
    {
        NSLog(@"Accuracy %f", location.horizontalAccuracy);
        
        if([location distanceFromLocation:self.info.home_loc] < 500)
        {
            self.report.didstarthome = true;
            [self.startAtHomeCheckbox setCheckMarkState:self.report.didstarthome];
            
            NSLog(@"Is close to home");
        }
        else
        {
            NSLog(@"Is not close to home");
        }
        
        [self.gpsManager stopGPS];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"DriveViewSegue"])
    {
        DriveViewController *vc = [segue destinationViewController];
        vc.report = self.report;
        
    }
    else if ([[segue identifier] isEqualToString:@"ShowSyncSegue"])
    {
        SyncViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
    //
}

- (IBAction)unwindToStartDriveVC:(UIStoryboardSegue *)segue{
    BOOL shouldReset = self.report.shouldReset;
    NSLog(@"Should reset: %d", shouldReset);
    NSLog(@"UnwindToStartDrive");
}


@end
