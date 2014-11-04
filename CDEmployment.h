//
//  CDEmployment.h
//  eIndberetning
//
//  Created by Jacob Hansen on 04/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDEmployment : NSManagedObject

@property (nonatomic, retain) NSString * employmentposition;
@property (nonatomic, retain) NSNumber * employmentid;

@end
