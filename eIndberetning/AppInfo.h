//
//  AppInfo.h
//  eIndberetning
//
//  Created by Jacob Hansen on 06/06/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppInfo : NSObject

@property (nonatomic, strong) NSString* Name;
@property (nonatomic, strong) NSString* APIUrl;
@property (nonatomic, strong) NSString* ImgUrl;

@property(nonatomic,strong) UIColor *HeaderTextColor;
@property(nonatomic,strong) UIColor *HeaderColor;
@property(nonatomic,strong) UIColor *ButtonColor;
@property(nonatomic,strong) UIColor *ButtonTextColor;
@property(nonatomic,strong) UIColor *SpinnerColor;

@property (nonatomic, strong) UIImage* ImgData;

+ (NSArray *) initFromJsonDic:(NSDictionary*)dic;
-(void)getImageDataIfNotPresent;
@end
