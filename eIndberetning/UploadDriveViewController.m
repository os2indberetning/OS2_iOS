/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  UploadDriveViewController.m
//  eIndberetning
//

#import "UploadDriveViewController.h"
#import "eMobilityHTTPSClient.h"
#import "UserInfo.h"
#import "Settings.h"

#import "GpsCoordinates.h"

@interface UploadDriveViewController ()
@property (weak, nonatomic) IBOutlet UIButton *tryAgianButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIImageView *municipalityLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoText;

@property (strong, nonatomic) SavedReport * savedReport;
@property (strong, nonatomic) NSArray *rates;
@property (strong,nonatomic) Profile* profile;
@end

@implementation UploadDriveViewController

const double WAIT_TIME_S = 1.5;

-(void)setupVisuals
{
    UserInfo* info = [UserInfo sharedManager];
    [info loadInfo];
    
    [self.cancelButton setBackgroundColor:info.appInfo.TextColor];
    [self.cancelButton setTitleColor:info.appInfo.SecondaryColor forState:UIControlStateNormal];
    self.cancelButton.layer.cornerRadius = 1.5f;
    
    [self.tryAgianButton setBackgroundColor:info.appInfo.SecondaryColor];
    [self.tryAgianButton setTitleColor:info.appInfo.TextColor forState:UIControlStateNormal];
    self.tryAgianButton.layer.cornerRadius = 1.5f;
    
    [self.municipalityLogoImageView setImage:info.appInfo.ImgData];
    
    [self.spinner setColor:info.appInfo.SecondaryColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupVisuals];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    
    //Check report for needed changes before upload
    [self checkReportForNilOrEmpty:self.report];
    
    [dic setObject:[[self.report transformToDictionary] mutableCopy] forKey:@"DriveReport"];
    
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    _savedReport =  [SavedReport new];
    _savedReport.jsonToSend = myString;
    _savedReport.rate = _report.rate.rateDescription;
    _savedReport.purpose = _report.purpose.purpose;
    _savedReport.totalDistance = _report.route.totalDistanceEdit;
    _savedReport.createdAt = [NSDate new];
    [Settings addSavedReport:_savedReport];
    NSLog(@"dic: %@", myString);
    [self uploadReport];
}

// MARK: Reportcontent checker methods

-(void)checkReportForNilOrEmpty: (DriveReport*)report {
    if (report.manuelentryremark == nil || [report.manuelentryremark  isEqual: @""]) {
        //If there is no manual remark, change to default remark
        NSLog(@"UploadDriveViewController - Report Comments is nil/empty, we create a default value");
        report.manuelentryremark = @"Ingen kommentar indtastet";
    }
    
    if (report.homeToBorderDistance == nil) {
        // Will be nil if we are not using the 4 km rule
        NSLog(@"UploadDriveViewController - Report HomeToBorderDistance is nil, we create a 0 value");
        report.homeToBorderDistance = [NSNumber numberWithFloat:0.0f];
    }
    
    if (report.uuid == nil || [report.uuid isEqualToString:@""]) {
        // sanity check, since we had some issues, where the uuid wasn't
        // send to the backend.
        NSLog(@"UploadDriveViewController - Report UUID is empty, we create a new one");
        report.uuid = [[NSUUID UUID] UUIDString].lowercaseString;
        NSLog(@"UploadDriveViewController - New created Report UUID: %@", report.uuid);
    }
    
    if (report.route.coordinates != nil || report.route.coordinates.count < 2) {
        // If we close the drive too fast, and/or we don't move, we will only
        // have 1 or no coordicates. We want to make sure we have two, otherwise
        // it will not get synced into the database.
        NSLog(@"UploadDriveViewController - Report route coordinates before sanity check: %lu", report.route.coordinates.count);
        if (report.route.coordinates.count == 1) {
            GpsCoordinates *cor = [[GpsCoordinates alloc] init];
            cor = report.route.coordinates[0];
            [report.route.coordinates addObject:cor];
        }
        else {
            GpsCoordinates *cor1 = [[GpsCoordinates alloc] init];
            cor1.loc = [[CLLocation alloc] initWithLatitude:56.1187857 longitude:10.1396362];
            GpsCoordinates *cor2 = [[GpsCoordinates alloc] init];
            cor2.loc = [[CLLocation alloc] initWithLatitude:56.1187857 longitude:10.1396362];
            [report.route.coordinates addObject:cor1];
            [report.route.coordinates addObject:cor2];
        }
        NSLog(@"UploadDriveViewController - Report route coordinates after sanity check: %lu", report.route.coordinates.count);
    }
}

-(void)uploadReport
{
    UserInfo* info = [UserInfo sharedManager];
    eMobilityHTTPSClient* client = [eMobilityHTTPSClient sharedeMobilityHTTPSClient];
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    
    [client postDriveReport:self.report forAuthorization:info.authorization withBlock:^(NSURLSessionTask *task, id resonseObject) {
        [self.spinner stopAnimating];
        self.spinner.hidden = YES;
        [Settings removeSavedReport:_savedReport];
        
        self.infoText.text = @"Din indberetning er modtaget.";
        [NSTimer scheduledTimerWithTimeInterval:WAIT_TIME_S target:self selector:@selector(uploadSuccess) userInfo:nil repeats:NO];
    }
                  failBlock:^(NSURLSessionTask * task, NSError *Error) {
                      self.spinner.hidden = YES;
                      [self.spinner stopAnimating];
                      NSLog(@"%@", Error);
                      
                      NSInteger errorCode = [Error.userInfo[ErrorCodeKey] intValue];
                      [self uploadFailWithErrorCode:(NSInteger)errorCode];
                  }];
}

-(void) uploadSuccess
{
    [self dismissViewControllerAnimated:true completion:nil];
    [self.delegate didFinishUpload];
}

- (void) uploadFailWithErrorCode:(NSInteger)errorCode
{
    //Change text, hide spinner, show button
    self.infoText.text = @"Der skete en fejl ved afsendelsen af din rapport! Prøv igen eller tryk på 'Gem' og send rapporten fra hovedmenuen på et andet tidspunkt.";
    self.spinner.hidden = true;
    self.tryAgianButton.hidden = false;
    self.cancelButton.hidden = false;
}

- (IBAction)tryAgianButtonPressed:(id)sender {
    self.spinner.hidden = false;
    self.tryAgianButton.hidden = true;
    self.cancelButton.hidden = true;
    
    self.infoText.text = @"Uploader kørselsdata";
    [self uploadReport];
}

//This is action called alongside an unwind to StartDriveTableViewVC
- (IBAction)cancelButtonPressed:(id)sender {
    //Reset the report, so that a clean report is shown in StartDriveTableViewVC
    //(It is already saved to Settings)
    self.report.shouldReset = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
