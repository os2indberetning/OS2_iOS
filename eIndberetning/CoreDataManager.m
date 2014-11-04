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
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastusedate" ascending:true];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPurpose" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *CDArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSArray* purposeArray = nil;
    
    if (!error)
    {
        purposeArray = [Purpose initFromCoreDataArray:CDArray];
    }
    else
    {
        NSLog(@"Error fetching %@ - error:%@",@"employment",error);
    }
    
    return purposeArray;
}

- (void) insertPurpose: (Purpose*)purpose;
{
    NSError *error;
    
    //Save purpose to coredata
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CDPurpose" inManagedObjectContext:self.managedObjectContext];
    CDPurpose* p = [[CDPurpose alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    
    p.purpose = purpose.purpose;
    p.lastusedate = purpose.lastusedate;
    
    [self.managedObjectContext insertObject:p];
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error inserting %@ - error:%@",@"purpose",error);
    }
    
    [self.managedObjectContext save:nil];
}

- (void)updatePurpose:(Purpose*)purpose
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"purpose = %@", purpose.purpose];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDPurpose" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *CDArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (!error)
    {
        CDPurpose* p = (CDPurpose*)CDArray[0];
        p.lastusedate = [NSDate date];
        [self.managedObjectContext save:nil];
    }
    else
    {
        NSLog(@"Error updating %@ - error:%@",@"purpose",error);
    }

}

-(void)saveContext
{
    [self.managedObjectContext save:nil];
}

@end
