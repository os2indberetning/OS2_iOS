//
//  DriveViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 05/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "DriveViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FinishDriveTableViewController.h"
#import "GpsCoordinates.h"
#import "UserInfo.h"


@interface DriveViewController ()  <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UILabel *distanceDrivenLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;

@property (nonatomic, strong) GPSManager* gpsManager;
@property (nonatomic, strong) UserInfo* ui;

@property (strong, nonatomic)  CLLocation *locA;
@property (weak, nonatomic) IBOutlet UILabel *gpsAccuaryLabel;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property (nonatomic) BOOL isCloseToHome;
@property (nonatomic) float totalDistance;

@property (strong, nonatomic) ConfirmEndDriveViewController* confirmPopup;
@end

@implementation DriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.finishButton.layer.cornerRadius = 1.5f;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    self.gpsManager = [GPSManager sharedGPSManager];
    self.gpsManager.delegate = self;
    [self.gpsManager startGPS];
    
    self.distanceDrivenLabel.text = @"- km";
    self.lastUpdatedLabel.text = @"Venter på gyldigt GPS signal";
    self.totalDistance = 0;
    self.isCloseToHome = false;
    
    self.timeFormatter = [[NSDateFormatter alloc] init];
    [self.timeFormatter setDateFormat:@"HH.mm.ss"];
    
    self.ui = [UserInfo sharedManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishButtonPressed:(id)sender {
    
    self.confirmPopup = [[ConfirmEndDriveViewController alloc] initWithNibName:@"ConfirmEndDriveViewController" bundle:nil];
    self.confirmPopup.delegate = self;
    
    //Set this value based on user home coordinaets, and the current location
    self.report.didendhome = false;
    self.confirmPopup.isSelected = self.report.didendhome;
    
    [self.confirmPopup showPopup];
}

#pragma mark - EndDrivePopupDelegate

-(void)endDrive
{
    [self.gpsManager stopGPS];
    [self performSegueWithIdentifier:@"EndDriveSegue" sender:self];
}

-(void)changeSelectedState:(BOOL)selectedState
{
    self.report.didendhome = selectedState;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"EndDriveSegue"])
    {
        self.report.route.totalDistanceEdit = @(ceil(self.totalDistance/1000.0f));
        self.report.route.totalDistanceMeasure = @(ceil(self.totalDistance/1000.0f));
        
        FinishDriveTableViewController *vc = [segue destinationViewController];
        vc.report = self.report;
    }
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

-(void)didUpdatePrecision:(float)precision
{
    self.gpsAccuaryLabel.text = [NSString stringWithFormat:@"GPS nøjagtighed: %.2f m", precision];
}

-(void)gotNewGPSCoordinate:(CLLocation *)location
{
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (abs(howRecent) < 15.0 && location.horizontalAccuracy < 50)
    {
        CLLocationDegrees lat = location.coordinate.latitude;
        CLLocationDegrees lng = location.coordinate.longitude;
        
        if(!self.locA)
        {
            self.locA = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
        }
        else
        {
            CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
            CLLocationDistance distance = [self.locA distanceFromLocation:locB];
            
            
            self.locA = locB;
            
            self.totalDistance += distance;
            
            NSLog(@"Distance: %f", self.totalDistance );
            
            self.distanceDrivenLabel.text = [NSString stringWithFormat:@"%.2f Km", self.totalDistance/1000.0f];
        }
        
        NSString* timeString = [self.timeFormatter stringFromDate:self.locA.timestamp];
        self.lastUpdatedLabel.text = [NSString stringWithFormat:@"Sidst opdateret kl: %@", timeString];
        
        GpsCoordinates *cor = [[GpsCoordinates alloc] init];
        cor.loc = self.locA;
        
        [self.report.route.coordinates insertObject:cor atIndex:0];
        
        //Set if we are currently close to home
        self.isCloseToHome = ([self.locA distanceFromLocation:self.ui.home_loc] < 500);
    }
}

@end
