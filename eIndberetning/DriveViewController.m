/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  DriveViewController.m
//  eIndberetning
//

#import "DriveViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FinishDriveTableViewController.h"
#import "GpsCoordinates.h"
#import "UserInfo.h"
#import "QuestionDialogViewController.h"

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
@property (strong, nonatomic) QuestionDialogViewController* resumePopup;

@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (nonatomic) BOOL isPaused;

@property (nonatomic) BOOL shouldWaitForGPSSettle;

@property BOOL shouldWarnUserOfInaccuracy;

@property BOOL validateResume;

@property BOOL isShowingDialogForValidation;

@end

@implementation DriveViewController

const double SETTLE_TIME_S = 5;

-(void)setupVisuals
{
    UserInfo* info = [UserInfo sharedManager];
    [info loadInfo];
    
    [self.finishButton setBackgroundColor:info.appInfo.SecondaryColor];
    [self.finishButton setTitleColor:info.appInfo.TextColor forState:UIControlStateNormal];
    self.finishButton.layer.cornerRadius = 1.5f;
    
    [self.pauseButton setBackgroundColor:info.appInfo.SecondaryColor];
    [self.pauseButton setTitleColor:info.appInfo.TextColor forState:UIControlStateNormal];
    self.pauseButton.layer.cornerRadius = 1.5f;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _validateResume = NO;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.shouldWaitForGPSSettle = true;
    
    // Do any additional setup after loading the view.
    self.gpsManager = [GPSManager sharedGPSManager];
    self.gpsManager.delegate = self;
    
    //Set default value here
    _shouldWarnUserOfInaccuracy = NO;
    
    self.timeFormatter = [[NSDateFormatter alloc] init];
    [self.timeFormatter setDateFormat:@"HH.mm.ss"];
    
    self.ui = [UserInfo sharedManager];
    self.isPaused = false;
    
    self.lastUpdatedLabel.text = @"Venter på gyldigt GPS signal";
    self.totalDistance = 0;
    self.distanceDrivenLabel.text = @"- km";
    [self setupVisuals];
}

-(void)viewWillAppear:(BOOL)animated
{
    //Primarily used to load from state restore
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    if(!self.isPaused)
    {
        [self startGPSSettleTimer];
        [self.gpsManager startGPS];
    }
}

-(void) startGPSSettleTimer{
    [NSTimer scheduledTimerWithTimeInterval:SETTLE_TIME_S target:self selector:@selector(toggleShouldWaitForGPSSettle) userInfo:nil repeats:NO];
}

-(void) toggleShouldWaitForGPSSettle{
    self.shouldWaitForGPSSettle = !self.shouldWaitForGPSSettle;
    NSLog(@"Toggle wait for gps to: %@", self.shouldWaitForGPSSettle ? @"TRUE" : @"FALSE");
    [self.gpsManager startGPS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishButtonPressed:(id)sender {
    self.confirmPopup = [[ConfirmEndDriveViewController alloc] initWithNibName:@"ConfirmEndDriveViewController" bundle:nil];
    self.confirmPopup.delegate = self;
    
    //Set this value based on user home coordinaets, and the current location
    self.report.didendhome = self.isCloseToHome;
    self.confirmPopup.isSelected = self.report.didendhome;
    
    [self.confirmPopup showPopup];
}

- (IBAction)pauseButtonPressed:(id)sender {
    
    [self togglePauseResume];
}

-(void) togglePauseResume{
    if(self.isPaused == true)
    {
        self.validateResume = YES;
        [self.gpsManager startGPS];
        [self.pauseButton setTitle:@"Pause Kørsel" forState:UIControlStateNormal];
    }
    else
    {
        [self markLastAsIsViaPoint];
        //self.locA = nil;
        [self.gpsManager stopGPS];
        self.gpsAccuaryLabel.text = @"GPS sat på pause";
        [self.pauseButton setTitle:@"Genoptag Kørsel" forState:UIControlStateNormal];
    }
    
    self.isPaused = !self.isPaused;
}

-(void) markLastAsIsViaPoint{
    GpsCoordinates * last = [self getLastCoordinate];
    if(last!=nil){
        last.isViaPoint = YES;
    }
}

-(GpsCoordinates * ) getLastCoordinate{
    if(_report!=nil && _report.route.coordinates!= nil && [_report.route.coordinates count]>0){
        return [_report.route.coordinates lastObject];
    }
    return nil;
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"EndDriveSegue"])
    {
        self.report.route.totalDistanceEdit = @(roundf(self.totalDistance/100.0f)/10);
        self.report.route.totalDistanceMeasure = @(roundf(self.totalDistance/100.0f)/10);
        
        FinishDriveTableViewController *vc = [segue destinationViewController];
        vc.report = self.report;
        vc.shouldShowInAccuracyWarning = self.shouldWarnUserOfInaccuracy;
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
    if(!self.shouldWaitForGPSSettle){
        NSLog(@"Updating accuracy label with: %f", precision);
        self.gpsAccuaryLabel.text = [NSString stringWithFormat:@"GPS nøjagtighed: %.2f m", precision];
        
        NSLog(@"Precision update triggered driven label update");
        self.distanceDrivenLabel.text = [NSString stringWithFormat:@"%.01f Km", self.totalDistance/1000.0f];
        
        [self updateLastUpdatedLabel];
    }else{
        NSLog(@"Received precision update - but waiting for GPS to settle");
    }
    
}

-(void)gotNewGPSCoordinate:(CLLocation *)location
{
    if(_isShowingDialogForValidation|| (location.coordinate.latitude == _locA.coordinate.latitude &&
                                         location.coordinate.longitude == _locA.coordinate.longitude)){
        return;
    }

    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    //distances in meters.
    
    //If location is older than 15 seconds - discard it
    if(!self.shouldWaitForGPSSettle){
        if (fabs(howRecent) < 15.0 || location.horizontalAccuracy < accuracyThreshold)
        {
            CLLocationDegrees lat = location.coordinate.latitude;
            CLLocationDegrees lng = location.coordinate.longitude;
            if(!self.locA)
            {
                self.locA = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
                NSLog(@"Logged first location | Accuracy: %f", location.horizontalAccuracy);
            }
            else
            {
                NSLog(@"Not first coordinate");
                CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
                CLLocationDistance distance = [self.locA distanceFromLocation:locB];
                if (!_shouldWarnUserOfInaccuracy && distance > maxDistanceBetweenLocations) {
                    _shouldWarnUserOfInaccuracy = YES;
                }
                
                //If distance is smaller than accuracy, ignore point
                if (distance < location.horizontalAccuracy) {
                    NSLog(@"Distance < accuracy | %f < %f", distance, location.horizontalAccuracy);
                    return;
                }else{
                    NSLog(@"Distance > accuracy | %f > %f", distance, location.horizontalAccuracy);
                    if(self.validateResume){
                        NSLog(@"Validating resume");
                        if(distance>200){
                            _isShowingDialogForValidation = YES;
                            //alert and pause and discard point
                            [self togglePauseResume];
                            [self showInvalidLocationResume];
                            NSLog(@"Failed: Distance was over 200...");
                            return;
                        }else{
                            NSLog(@"Succes: could resumse");
                            self.validateResume = NO;
                        }
                    }
                    
                    self.locA = locB;
                    
                    NSLog(@"Old distance: %f", self.totalDistance);
                    self.totalDistance += distance;
                    NSLog(@"New distance: %f", self.totalDistance );
                }
            }
            NSLog(@"Updating total distance (meters): %f", self.totalDistance);
            NSLog(@"Updating total distance (km): %f", self.totalDistance/1000.0f);
            self.distanceDrivenLabel.text = [NSString stringWithFormat:@"%.01f Km", self.totalDistance/1000.0f];
            
            GpsCoordinates *cor = [[GpsCoordinates alloc] init];
            cor.loc = self.locA;
            
            [self.report.route.coordinates addObject:cor];
            
            //Set if we are currently close to home
            self.isCloseToHome = ([self.locA distanceFromLocation:self.ui.home_loc] < 500);
        }else{
            NSLog(@"Location age: %f | LocationAccuracy: %f", howRecent, location.horizontalAccuracy);
        }
        
        //No matter what, update label to show that system hasn't stalled.
        [self updateLastUpdatedLabel];
        
    }else{
        NSLog(@"Waiting for GPS to settle");
    }
    
}

-(void)updateLastUpdatedLabel{
    NSString* timeString = [self.timeFormatter stringFromDate:self.locA.timestamp];
    self.lastUpdatedLabel.text = [NSString stringWithFormat:@"Sidst opdateret kl: %@", timeString];
}


-(void)showInvalidLocationResume{
    self.validateResume = YES;
    _resumePopup =  [QuestionDialogViewController setTextsWithTitle:@"Fejl" withMessage:@"Du er for langt væk fra din position da du pauserede kørslen. Vend tilbage til den position, eller afslut den nuværende kørsel og start en ny." withNoButtonText:@"Afslut nuværende" withNoCallback:^{
        [_resumePopup removeAnimate];
        [self endDrive];
        
    } withYesText:@"Prøv igen" withYesCallback:^{
        [_resumePopup removeAnimate];
        [self togglePauseResume];
        _isShowingDialogForValidation = NO;
        self.validateResume = YES;
        
    } inView:self.view];
}

#pragma mark State Preservation
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:@(self.totalDistance) forKey:@"TotalDistance"];
    [coder encodeObject:self.report forKey:@"DriveReport"];
    [coder encodeObject:@(YES) forKey:@"isPaused"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    self.totalDistance = [[coder decodeObjectForKey:@"TotalDistance"] floatValue];
    self.report = [coder decodeObjectForKey:@"DriveReport"];
    self.isPaused = [[coder decodeObjectForKey:@"isPaused"] boolValue];
    [super decodeRestorableStateWithCoder:coder];
    
    self.gpsAccuaryLabel.text = @"GPS sat på pause";
    [self.pauseButton setTitle:@"Genoptag Kørsel" forState:UIControlStateNormal];
    self.distanceDrivenLabel.text = [NSString stringWithFormat:@"%.01f Km", self.totalDistance/1000.0f];
    self.lastUpdatedLabel.text = @"Venter på gyldigt GPS signal";
    self.isCloseToHome = self.report.didendhome;
}


@end