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

@interface DriveViewController ()  <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UILabel *distanceDrivenLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic)  CLLocation *locA;
@property (weak, nonatomic) IBOutlet UILabel *gpsAccuaryLabel;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;

@property (nonatomic) float totalDistance;

@property (strong, nonatomic) ConfirmEndDriveViewController* confirmPopup;
@end

@implementation DriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.finishButton.layer.cornerRadius = 1.5f;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [self startGPS];
    
    self.distanceDrivenLabel.text = @"- km";
    self.lastUpdatedLabel.text = @"Venter på gyldigt GPS signal";
    self.totalDistance = 0;
    
    self.timeFormatter = [[NSDateFormatter alloc] init];
    [self.timeFormatter setDateFormat:@"HH.mm.ss"];
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
    [self stopGPS];
    [self performSegueWithIdentifier:@"EndDriveSegue" sender:self];
}

-(void)changeSelectedState:(BOOL)selectedState
{
    self.report.didendhome = selectedState;
}

#pragma mark - GPS Handling
- (void)startGPS
{
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    [self requestAuthorization];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 50; // meters
    
    [self.locationManager startUpdatingLocation];
}

- (void)stopGPS
{
    [self.locationManager stopUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    self.gpsAccuaryLabel.text = [NSString stringWithFormat:@"GPS nøjagtighed: %.2f m", location.horizontalAccuracy];
    
    if (abs(howRecent) < 15.0 && location.horizontalAccuracy < 50) {
        
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
        
        // If the event is recent, do something with it.
        /*NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);*/
    }
    else
    {
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
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

#pragma mark - GPS Permission
- (void)requestAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied display an alert
    if (status == kCLAuthorizationStatusDenied) {
        NSString *title;
        
        title = @"Lokation er ikke tilgængelig";
        NSString *message = @"For at bruge appen, skal lokation gøres tilgængelig";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Afbryd"
                                                  otherButtonTitles:@"Indstillinger", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
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
@end
