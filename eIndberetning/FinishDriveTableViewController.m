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

@interface FinishDriveTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *purposeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *organisationalPlaceTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *startAtHomeCheckbox;
@property (weak, nonatomic) IBOutlet UIImageView *endAtHomeCheckbox;
@property (weak, nonatomic) IBOutlet UILabel *kmDrivenLabel;

@property (strong, nonatomic) NSMutableArray *rates;
@property (strong, nonatomic) NSMutableArray *employments;
@property (strong, nonatomic) NSMutableArray *purposes;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation FinishDriveTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.purposeTextLabel.text = self.report.purpose;
    self.rateTextLabel.text = self.report.rate.type;
    self.commentTextLabel.text = self.report.manuelentryremark;
    self.organisationalPlaceTextLabel.text = self.report.employment.title;
    
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
- (IBAction)cancelAndDeleteButton:(id)sender {
    self.report.shouldReset = true;
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (IBAction)submitButton:(id)sender {
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"EditKmSegue"])
    {
        EditKmViewController *vc = [segue destinationViewController];
        vc.route = self.report.route;
    }
}


@end
