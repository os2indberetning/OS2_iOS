//
//  StartDriveTableViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 04/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
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

@interface StartDriveTableViewController ()
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *taskTextField;
@property (weak, nonatomic) IBOutlet UILabel *purposeTextField;
@property (weak, nonatomic) IBOutlet UILabel *organisationalPlaceTextField;
@property (strong, nonatomic) ErrorMsgViewController *errorMsg;
@property (weak, nonatomic) IBOutlet UIImageView *startAtHomeCheckbox;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) NSArray *rates;
@property (strong, nonatomic) NSArray *employments;
@property (strong, nonatomic) NSMutableArray *purposes;

@property (strong,nonatomic) DriveReport* report;
@property (strong,nonatomic) Profile* profile;

@property (strong,nonatomic) UserInfo* info;

@property (nonatomic) BOOL shouldSync;
@property (nonatomic,strong) CoreDataManager* CDManager;
@end

@implementation StartDriveTableViewController

-(CoreDataManager*)CDManager
{
    return [CoreDataManager sharedeCoreDataManager];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor favrGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor favrOrangeColor]];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    //Compare last sync date and current date, to see if we should sync, or simply load from coredata
    self.info = [UserInfo sharedManager];
    [self.info loadInfo];
    
    NSDate *lastSync = [self.info.last_sync_date copy];
    NSDate *curDate = [NSDate date];
    
    if(lastSync != nil)
    {
        float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
        if(sysVer >= 8.0)
        {
            [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&lastSync interval:NULL forDate:lastSync];
            [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&curDate interval:NULL forDate:curDate];
        }
        else
        {
            [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&lastSync interval:NULL forDate:lastSync];
            [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&curDate interval:NULL forDate:curDate];
        }
        
        NSComparisonResult result = [lastSync compare:curDate];
        if (result == NSOrderedSame) {
            //Did sync today - so load from coredata
            
            self.rates = [self.CDManager fetchRates];
            self.employments = [self.CDManager fetchEmployments];
            [self loadReport];
            
        } else
        {
            //Did not sync today
            self.shouldSync = true;
        }
    }
    else
    {
        //Sync first time
        self.shouldSync = true;
    }
    
    //[client postDriveReport:self.report forToken:@"Token" ];
}

-(void)loadReport
{
    //Create new drive report
    self.report = [[DriveReport alloc] init];
    
    Route *route = [[Route alloc] init];
    route.totalDistanceEdit = @200;
    route.totalDistanceMeasure = @200;
    self.report.route = route;
    
    self.purposes = [[self.CDManager fetchPurposes] mutableCopy];
    
    //TODO: Load default report setttings
    if([self.purposes containsObject:self.info.last_purpose])
        self.report.purpose = self.info.last_purpose;

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
    
    if(self.report.shouldReset)
        [self loadReport];
    
    if(self.report.purpose)
        self.purposeTextField.text = self.report.purpose.purpose;
    else
        self.purposeTextField.text = @"Vælg Formål";
    
    if(self.report.rate)
        self.taskTextField.text = self.report.rate.type;
    else
        self.taskTextField.text = @"Vælg Takst";

    if(self.report.manuelentryremark)
        self.commentTextView.text = self.report.manuelentryremark;
    else
        self.commentTextView.text = @"Indtast Bemærkning";

    if(self.report.employment)
        self.organisationalPlaceTextField.text = self.report.employment.employmentPosition;
    else
        self.organisationalPlaceTextField.text  = @"Vælg Placering";
    
    
    NSString *checkState = (self.report.didstarthome) ? @"checkBox_checked" : @"checkBox_unchecked";
    self.startAtHomeCheckbox.image = [UIImage imageNamed:checkState];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.shouldSync)
    {
        self.shouldSync = false;
        [self performSegueWithIdentifier:@"ShowSyncSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startDrivingButton:(id)sender {
    /*self.errorMsg = [[ErrorMsgViewController alloc] initWithNibName:@"ErrorMsgViewController" bundle:nil];
     [self.errorMsg setTitle:@"Du mangler at udfylde"];
     [self.errorMsg setError:@"Test"];
     self.errorMsg.view.frame = [UIApplication sharedApplication].keyWindow.frame;
     [self.errorMsg showInView:[UIApplication sharedApplication].keyWindow  animated:YES];*/
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
                vc.items = [self.employments mutableCopy];
                break;
            }
            case 3:
            {
                vc.listType = RateList;
                vc.items = [self.rates mutableCopy];
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
        NSString *checkState = (self.report.didstarthome) ? @"checkBox_checked" : @"checkBox_unchecked";
        self.startAtHomeCheckbox.image = [UIImage imageNamed:checkState];
    }

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
    self.info.token = profile.token.token;
    [self.info saveInfo];
    
    [self loadReport];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"DriveViewSegue"])
    {
        // Get reference to the destination view controller
        DriveViewController *vc = [segue destinationViewController];
        vc.report = self.report;
    }
    else if ([[segue identifier] isEqualToString:@"ShowSyncSegue"])
    {
        // Get reference to the destination view controller
        SyncViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        // Pass any objects to the view controller here, like...
        //[vc setMyObjectHere:object];
    }
    //
}


@end
