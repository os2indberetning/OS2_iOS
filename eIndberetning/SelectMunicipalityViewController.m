/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  SelectMunicipalityViewController.m
//  eIndberetning
//

#import "SelectMunicipalityViewController.h"
#import "ErrorMsgViewController.h"
#import "AFHTTPSessionManager.h"

@interface SelectMunicipalityViewController ()
@property (nonatomic, strong) NSArray* municipalityList;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) AppInfo* selectedAppInfo;

@property (nonatomic, strong) ErrorMsgViewController* errorMsg;
@end

static NSString * const baseURL = @"https://ework.favrskov.dk/FavrskovMobilityAPI/api/";

@implementation SelectMunicipalityViewController

NSString* loadingCell = @"LoadingCell";
NSString* municipalityCell = @"MunicipalityCell";

-(NSArray*)municipalityList
{
    if(!_municipalityList)
        _municipalityList = [[NSArray alloc] init];
    
    return _municipalityList;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.isLoading = YES;
    
    [self fetchProviders];
}


-(void)fetchProviders{
    AFHTTPSessionManager* sessionManager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:baseURL]];
    [sessionManager GET:@"AppInfo" parameters:nil success:^(NSURLSessionDataTask *task, id resonseObject) {
        
        self.isLoading = NO;
        self.municipalityList = [AppInfo initFromJsonDic:resonseObject];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        self.errorMsg = [[ErrorMsgViewController alloc] initWithNibName:@"ErrorMsgViewController" bundle:nil];
        
        self.errorMsg.delegate = self;
        
        NSHTTPURLResponse* r = (NSHTTPURLResponse*) task.response;
        
        NSString *errorMessage = @"Der skete en fejl - prøv igen";
        
        if(!r.statusCode){
            errorMessage = @"Ingen ingen internetforbindelse - prøv igen.";
        }
        
        [self.errorMsg showErrorMsg: errorMessage];
        
        NSLog(@"Fail!: %@", error);
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:nil];
    [self.navigationController.navigationBar setTintColor:nil];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
}

#pragma mark ErrorMessageDelegate
-(void) errorMessageButtonClicked {
    [self fetchProviders];
}

#pragma mark tableviewcontroller
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isLoading)
        return 1;
    else
        return self.municipalityList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isLoading)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:loadingCell];
        return cell;
    }
    else
    {
        AppInfo* appInfo = [self.municipalityList objectAtIndex:indexPath.row];
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:municipalityCell];
        cell.textLabel.text = appInfo.Name;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.isLoading)
    {
        self.selectedAppInfo = [self.municipalityList objectAtIndex:indexPath.row];
        
//        [self performSegueWithIdentifier:@"ChooseMunicipialitySegue" sender:self];
        
        [self performSegueWithIdentifier:@"ProviderToUserLoginSegue" sender:self];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"ChooseMunicipialitySegue"])
    {
        // Get reference to the destination view controller
        PairViewController *vc = [segue destinationViewController];
        vc.appInfo = self.selectedAppInfo;
    }
    
    if([[segue identifier] isEqualToString:@"ProviderToUserLoginSegue"]){
        // Get reference to the destination view controller
        UserLoginViewController *vc = [segue destinationViewController];
        vc.appInfo = self.selectedAppInfo;
    }
}
@end
