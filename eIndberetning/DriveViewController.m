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


@property BOOL validateResume;

@property BOOL isShowingDialogForValidation;

@end

@implementation DriveViewController

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
    // Do any additional setup after loading the view.
    self.gpsManager = [GPSManager sharedGPSManager];
    self.gpsManager.delegate = self;
    
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
        [self.gpsManager startGPS];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishButtonPressed:(id)sender {
    //TODO should pause gps ?
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
    if(_isShowingDialogForValidation|| (location.coordinate.latitude == _locA.coordinate.latitude &&
                                         location.coordinate.longitude == _locA.coordinate.longitude)){
        return;
    }

    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    //distances in meteres.
    if (fabs(howRecent) < 15.0 && location.horizontalAccuracy < 50)
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
            
            if(self.validateResume){
                if(distance>200){
                                      _isShowingDialogForValidation = YES;
                    //alert and pause and discard point
                    [self togglePauseResume];
                    [self showInvalidLocationResume];
                    return;
                }else{
                    self.validateResume = NO;
                }
            }
            
            
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
    self.distanceDrivenLabel.text = [NSString stringWithFormat:@"%.2f Km", self.totalDistance/1000.0f];
    self.lastUpdatedLabel.text = @"Venter på gyldigt GPS signal";
    self.isCloseToHome = self.report.didendhome;
}
-(GpsCoordinates * ) getLastCoordinate{
    if(_report!=nil && _report.route.coordinates!= nil && [_report.route.coordinates count]>0){
        return [_report.route.coordinates objectAtIndex:0];
    }
    return nil;
}

@end
