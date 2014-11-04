//
//  CoreDataManader.m
//  eIndberetning
//
//  Created by Jacob Hansen on 04/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import "CoreDataManager.h"


@interface CoreDataManager ()
    @property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@end

@implementation CoreDataManager

- (NSManagedObjectContext*) managedObjectContext {
    return [(AppDelegate*) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

+ (CoreDataManager *)sharedeCoreDataManager
{
    static CoreDataManager *_sharedeCoreDataManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedeCoreDataManager = [[self alloc] init];
    });
    
    return _sharedeCoreDataManager;
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [self.managedObjectContext deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

- (void) insertEmployments: (NSArray*)employments
{
    NSError *error;
    
    //Save employment to coredata
    for (Employment* e in employments) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CDEmployment" inManagedObjectContext:self.managedObjectContext];
        CDEmployment* CDe = [[CDEmployment alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
        
        CDe.employmentid = e.employmentId;
        CDe.employmentposition = e.employmentPosition;
        
        [self.managedObjectContext insertObject:CDe];
    }

    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error inserting %@ - error:%@",@"employment",error);
    }
}

- (void) insertRates: (NSArray*)rates
{
    NSError *error;
    
    //Save rates to coredata
    for (Rate* r in rates) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CDRate" inManagedObjectContext:self.managedObjectContext];
        CDRate* CDr = [[CDRate alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
        
        CDr.kmrate = r.kmrate;
        CDr.tfcode = r.tfcode;
        CDr.type = r.type;
        CDr.rateid = r.rateid;
        
        [self.managedObjectContext insertObject:CDr];
    }
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error inserting %@ - error:%@",@"rate",error);
    }
    
    [self.managedObjectContext save:nil];
}

- (NSArray *) fetchRates
{
 
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDRate" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *CDArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSArray* rateArray = nil;
    
    if (!error) {
        rateArray = [Rate initFromCoreDataArray:CDArray];
    }
    else
    {
        NSLog(@"Error fetching %@ - error:%@",@"rate",error);
    }
    
    return rateArray;
}

- (NSArray *) fetchEmployments
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDEmployment" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *CDArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSArray* empArray = nil;
    
    if (!error)
    {
        empArray = [Employment initFromCoreDataArray:CDArray];
    }
    else
    {
        NSLog(@"Error fetching %@ - error:%@",@"employment",error);
    }
    
    return empArray;
}

- (NSArray *) fetchPurposes
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Purpose" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *CDArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray* purposeArray = [[NSMutableArray alloc] initWithCapacity:CDArray.count];
    
    if (!error)
    {
        for (Purpose *p in CDArray) {
            [purposeArray insertObject:p.purpose atIndex:0];
        }
    }
    else
    {
        NSLog(@"Error fetching %@ - error:%@",@"employment",error);
    }
    
    return purposeArray;
}
@end
