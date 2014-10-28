//
//  Route.h
//  eIndberetning
//
//  Created by Jacob Hansen on 27/10/14.
//  Copyright (c) 2014 IT-Minds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject
@property (nonatomic, strong) NSNumber* totalDistanceMeasure;
@property (nonatomic, strong) NSNumber* totalDistanceEdit;

@property (nonatomic, strong) NSArray* coordinates;
@end
