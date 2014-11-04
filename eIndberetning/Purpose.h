//
//  Purpose.h
//  eIndberetning
//
//  Created by Jacob Hansen on 04/11/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Purpose : NSObject

@property (nonatomic, strong) NSDate * lastusedate;
@property (nonatomic, strong) NSString * purpose;

+ (NSArray *) initFromCoreDataArray:(NSArray*)CDArray;

@end
