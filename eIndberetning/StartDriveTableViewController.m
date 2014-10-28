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
#import "eMobilityHTTPSClient.h"

#import "DriveReport.h"

@interface StartDriveTableViewController ()
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *taskTextField;
@property (weak, nonatomic) IBOutlet UILabel *purposeTextField;
@property (weak, nonatomic) IBOutlet UILabel *organisationalPlaceTextField;
@property (strong, nonatomic) ErrorMsgViewController *errorMsg;
@property (weak, nonatomic) IBOutlet UIImageView *startAtHomeCheckbox;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) NSMutableArray *rates;
@property (strong, nonatomic) NSMutableArray *employments;
@property (strong, nonatomic) NSMutableArray *purposes;
@property (strong,nonatomic) DriveReport* report;

@end

@implementation StartDriveTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //This information should be fetched from coredata or the webservice
    Rate* r1 = [[Rate alloc] init];
    r1.type = @"Cykel";
    
    Rate* r2 = [[Rate alloc] init];
    r2.type = @"Bil, Høj Takst";
    
    Rate* r3 = [[Rate alloc] init];
    r3.type = @"Bil, Lav Takst";

    self.rates = [@[r1, r2, r3] mutableCopy];
    
    Employment *e1 = [[Employment alloc] init];
    e1.title = @"Byrådsmedlem";
    e1.employmentNumber = @1;
    
    Employment *e2 = [[Employment alloc] init];
    e2.title = @"Borgmester";
    e2.employmentNumber = @2;
    
    Employment *e3 = [[Employment alloc] init];
    e3.title = @"Hjemmehjælper";
    e3.employmentNumber = @3;
    self.employments = [@[e1, e2, e3] mutableCopy];
    
    self.purposes = [@[@"Et eller andet", @"Noget tredje"] mutableCopy];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor favrGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor favrOrangeColor]];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    /*eMobilityHTTPSClient* client = [eMobilityHTTPSClient sharedWeatherHTTPClient];
    client
    API *api = [[API alloc] init];
    [api getWeatherData];*/
    
    [self loadReport];
    
    /*UserInfo* info = [UserInfo sharedManager];
    [info loadInfo];
    [info saveInfo];*/
}

-(void)loadReport
{
    //Create new drive report
    self.report = [[DriveReport alloc] init];
    
    Route *route = [[Route alloc] init];
    route.totalDistanceEdit = @200;
    route.totalDistanceMeasure = @200;
    self.report.route = route;
    
    //Load default report setttings
    self.report.rate = self.rates[0];
    self.report.employment = self.employments[0];
    self.report.purpose = self.purposes[0];
    self.report.manuelentryremark = @"Test Description";
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
    
    self.purposeTextField.text = self.report.purpose;
    self.taskTextField.text = self.report.rate.type;
    self.commentTextView.text = self.report.manuelentryremark;
    self.organisationalPlaceTextField.text = self.report.employment.title;
    
    NSString *checkState = (self.report.didstarthome) ? @"checkBox_checked" : @"checkBox_unchecked";
    self.startAtHomeCheckbox.image = [UIImage imageNamed:checkState];
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

    if(indexPath.row < 4)
    {
        SelectListTableViewController *vc=[[SelectListTableViewController alloc]initWithNibName:@"SelectListTableViewController" bundle:nil];
        vc.report = self.report;
        
        switch (indexPath.row) {
            case 1:
            {
                vc.listType = PurposeList;
                vc.items = self.purposes;
                break;
            }
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
        NSString *checkState = (self.report.didstarthome) ? @"checkBox_checked" : @"checkBox_unchecked";
        self.startAtHomeCheckbox.image = [UIImage imageNamed:checkState];
    }

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DriveViewController *vc = [segue destinationViewController];
    vc.report = self.report;
}


@end
