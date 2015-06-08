//
//  SelectMunicipalityViewController.m
//  eIndberetning
//
//  Created by Jacob Hansen on 06/06/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
//

#import "SelectMunicipalityViewController.h"
#import "AFHTTPSessionManager.h"

@interface SelectMunicipalityViewController ()
@property (nonatomic, strong) NSArray* municipalityList;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) AppInfo* selectedAppInfo;
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
    
    [self getAppInfoWithBlock:^(NSURLSessionDataTask *task, id resonseObject) {
        
        self.isLoading = NO;
        self.municipalityList = [AppInfo initFromJsonDic:resonseObject];
        [self.tableView reloadData];
        
    } failBlock:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Fail!: %@", error);
        //Could not connect, some error happend
        
    }];
    
    
}

-(void)getAppInfoWithBlock:(void (^)(NSURLSessionDataTask *task, id resonseObject))succes failBlock:(void (^)(NSURLSessionDataTask *task, NSError* error))failure
{
#if !defined(MOCK)
    AFHTTPSessionManager* sessionManager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:baseURL]];
    [sessionManager GET:@"AppInfo" parameters:nil success:succes failure:failure];
#else
    
    succes(nil,@[
                 @{
                     @"Name":@"Favrskov",
                     @"APIUrl":@"https://ework.favrskov.dk/FavrskovMobilityAPI/api/",
                     @"ImgUrl":@"http://www.denstoredanske.dk/@api/deki/files/8935/=39997926.jpg",
                     @"TextColor":@"#FFFFFF",
                     @"PrimaryColor":@"#00665F",
                     @"SecondaryColor":@"#DB813C"
                     },
                 @{
                     @"Name":@"Syddjurs",
                     @"APIUrl":@"https://ework.favrskov.dk/FavrskovMobilityAPI/api/",
                     @"ImgUrl":@"https://www.syddjurs.dk/sites/default/files/vaabenskjold-ikon.png",
                     @"TextColor":@"#FFFFFF",
                     @"PrimaryColor":@"#6b2d52",
                     @"SecondaryColor":@"#6583d3"
                     }
                 ]);
#endif
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
        [self performSegueWithIdentifier:@"ChooseMunicipialitySegue" sender:self];
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
}
@end
