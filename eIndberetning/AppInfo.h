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

@property(nonatomic,strong) UIColor *TextColor;
@property(nonatomic,strong) UIColor *PrimaryColor;
@property(nonatomic,strong) UIColor *SecondaryColor;

@property (nonatomic, strong) UIImage* ImgData;

+ (NSArray *) initFromJsonDic:(NSDictionary*)dic;
-(void)getImageDataIfNotPresent;
@end
