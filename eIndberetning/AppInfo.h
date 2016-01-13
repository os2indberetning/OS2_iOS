/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  AppInfo.h
//  eIndberetning
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
