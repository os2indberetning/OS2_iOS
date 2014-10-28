//
//  Purpose.h
//  eIndberetning
//
//  Created by Jacob Hansen on 28/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Purpose : NSManagedObject

@property (nonatomic, retain) NSString * purpose;
@property (nonatomic, retain) NSDate * lastusedat;

@end
