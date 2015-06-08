//
//  CheckMarkImageView.m
//  eIndberetning
//
//  Created by Jacob Hansen on 08/06/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
//

#import "CheckMarkImageView.h"
#import "UserInfo.h"

@interface CheckMarkImageView ()
@property (nonatomic, strong) CALayer* checkBoxLayer;
@property (nonatomic, strong) CAShapeLayer* checkMarkMaskLayer;
@property (nonatomic, strong) CALayer* checkMarkLayer;
@end

@implementation CheckMarkImageView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        [self baseInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        [self baseInit];
    }
    
    return self;
}

-(void)baseInit
{
    UserInfo* info = [UserInfo sharedManager];
    [info loadInfo];
    
    NSLog(@"init");
    self.checkBoxLayer = [CALayer layer];
    self.checkBoxLayer.frame = self.bounds;
    self.checkBoxLayer.contents = (__bridge id)([[UIImage imageNamed:@"checkBox"] CGImage]);
    
    self.checkMarkMaskLayer = [CAShapeLayer layer];
    self.checkMarkMaskLayer.frame = self.bounds;
    self.checkMarkMaskLayer.contents = (__bridge id)([[UIImage imageNamed:@"checkMark"] CGImage]);
    
    self.checkMarkLayer = [CALayer layer];
    self.checkMarkLayer.frame = self.bounds;
    self.checkMarkLayer.mask = self.checkMarkMaskLayer;
    self.checkMarkLayer.backgroundColor = [info.appInfo.SecondaryColor CGColor];
    
    [self.layer addSublayer:self.checkBoxLayer];
    [self.layer addSublayer:self.checkMarkLayer];
}

-(void)setCheckMarkState:(BOOL)isChecked
{
    if(self.image)
        self.image = nil;
    
    if(isChecked)
    {
        self.checkMarkLayer.opacity = 1.0f;
    }
    else
    {
         self.checkMarkLayer.opacity = 0.0f;
    }
}


@end
