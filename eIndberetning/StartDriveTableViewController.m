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
#import "QuestionDialogViewController.h"

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

@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (strong, nonatomic) QuestionDialogViewController *logoutPopup;
@property (strong, nonatomic) QuestionDialogViewController *syncFailedPopup;

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
    
    [self.logoutButton setTitleTextAttributes:@{NSForegroundColorAttributeName:info.appInfo.SecondaryColor} forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.info = [UserInfo sharedManager];
    [self.info loadInfo];
    
    if(!self.info.authorization){
        if(self.gpsManager){
            [self.gpsManager stopGPS];
            self.gpsManager = nil;
        }
        AppDelegate* del =  [[UIApplication sharedApplication] delegate];
        [del changeToLoginView];
        return;
    }
    
    //Add listeners for sync
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncUserInfo) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setForceSync) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    self.gpsManager = [GPSManager sharedGPSManager];
    
    self.tableView.rowHeight = 44;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setupVisuals];

    [self setForceSync];
}

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
    
    [self syncUserInfo];
}

-(void)fillViewWithData{
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
    else if(indexPath.row > 1 && indexPath.row < 4)
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

-(void)setForceSync{
    self.shouldSync = YES;
}

-(void)syncUserInfo{
    if(self.shouldSync && self.navigationController.topViewController == self){
        NSLog(@"Syncing userInfo from StartDriveVC");
        __block UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center =self.view.center;
        indicator.frame = [self.navigationController view].frame;
        indicator.backgroundColor = [UIColor colorWithRed:0.6667 green:0.6667 blue:0.6667 alpha:0.50];
        [self.view addSubview:indicator];
        [indicator startAnimating];
        
        //Sync user
        [SyncHelper doSync:^(Profile * profile, NSArray * rates) {
            [indicator removeFromSuperview];
            [self didFinishSyncWithProfile:profile AndRate:rates];
            
            //Waiting till after sync has completed to fill in data
            [self fillViewWithData];
        } withErrorCallback:^(NSError *error) {
            [self setForceSync];
            [indicator removeFromSuperview];
            
            
            NSString *title = @"title";
            NSString *description = @"Description";
            NSString *negativeButtonText = @"Forsøg igen";
            NSString *positiveButtonText = @"Log ind igen";
            
            NSInteger errorCode = [error.userInfo[ErrorCodeKey] intValue];
            
            if(errorCode == 0){
                title = @"Ingen internetforbindelse!";
                description = @"Tjek din internetforbindelse og prøv igen.";
            }else if(errorCode == 610 || errorCode == 401){
                title = @"Kunne ikke synkronisere bruger info med serveren!";
                description = @"Der er sket en ændring i din bruger info på serveren - du skal logge ind igen.";
            }else{
                title = @"Kunne ikke synkronisere bruger info med serveren!";
                description = @"Der opstod en uventet fejl ved synkronisering af bruger info - vi beklager.";
            }
            
            _syncFailedPopup = [QuestionDialogViewController setTextsWithTitle:title withMessage:description
                withNoButtonText:negativeButtonText withNoCallback:^{
                    [_syncFailedPopup removeAnimate];
                    [self syncUserInfo];
                }
                withYesText:positiveButtonText withYesCallback:^{
                    [_syncFailedPopup removeAnimate];
                    [self logoutButtonPressed:nil];
                } inView:self.navigationController.view];
            [self fillViewWithData];
            
        }];
    }else{
        //If we shouldn't sync, just fill in data already
        NSLog(@"Skipped sync - filling view with data");
        [self fillViewWithData];
    }
    
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
    
    self.info.authorization = profile.authorization;
    
    [self.info saveInfo];
    
    self.shouldSync = NO;
    
    [self loadReport];
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
    
    //Force sync next time this view is shown
    [self setForceSync];
    
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
}

- (IBAction)unwindToStartDriveVC:(UIStoryboardSegue *)segue{
    BOOL shouldReset = self.report.shouldReset;
    [self setForceSync];
    [self syncUserInfo];
    NSLog(@"Should reset: %d", shouldReset);
    NSLog(@"UnwindToStartDrive");
}

- (IBAction)logoutButtonPressed:(id)sender {
    _logoutButton.enabled = NO;
    _logoutPopup = [QuestionDialogViewController setTextsWithTitle:@"Du er ved at logge ud" withMessage:@"Eventuelle indtastninger og gemte rapporter vil blive slettet, er du sikker?"
      withNoButtonText:@"Nej" withNoCallback:^{
          _logoutButton.enabled = YES;
          [_logoutPopup removeAnimate];
          
          if(_shouldSync){
              [self syncUserInfo];
          }
    } withYesText:@"Ok" withYesCallback:^{
            _logoutButton.enabled = YES;
        [_logoutPopup removeAnimate];
        [self completeLogout];
        
    } inView:self.navigationController.view];
}

-(void)completeLogout{
    //Clear saved reports
    NSMutableArray *savedReports = [Settings getAllSavedReports];
    for (SavedReport *report in savedReports) {
        [Settings removeSavedReport:report];
    }
    
    //Clear userInfo
    [self.info resetInfo];
    
    [self.info loadInfo];
    
    //Clear CoreData
    [self.CDManager deleteAllObjects:@"CDRate"];
    [self.CDManager deleteAllObjects:@"CDEmployment"];
    
    //Stop GPS if active
    if(self.gpsManager){
        [self.gpsManager stopGPS];
        self.gpsManager = nil;
    }
    
    AppDelegate* del =  [[UIApplication sharedApplication] delegate];
    [del changeToLoginView];
}



@end
