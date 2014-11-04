//
//  CDPurpose.h
//  eIndberetning
//
//  Created by Jacob Hansen on 04/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDPurpose : NSManagedObject

@property (nonatomic, retain) NSDate * lastusedate;
@property (nonatomic, retain) NSString * purpose;

@end
