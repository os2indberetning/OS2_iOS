//
//  AppInfo.m
//  eIndberetning
//
//  Created by Jacob Hansen on 06/06/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
//

#import "AppInfo.h"
#import "AFNetworking.h"

@implementation AppInfo

+ (NSArray *) initFromJsonDic:(NSDictionary*)dic;
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for (NSDictionary* token in dic) {
        AppInfo *t = [[AppInfo alloc] init];
        
        t.Name = [[token objectForKey:@"Name"] description];
        t.APIUrl = [[token objectForKey:@"APIUrl"] description];
        t.ImgUrl = [[token objectForKey:@"ImgUrl"] description];
        
        t.TextColor = [self colorFromHexString:[[token objectForKey:@"TextColor"] description]];
        t.PrimaryColor = [self colorFromHexString:[[token objectForKey:@"PrimaryColor"] description]];
        t.SecondaryColor = [self colorFromHexString:[[token objectForKey:@"SecondaryColor"] description]];
        
        [array insertObject:t atIndex:0];
    }
    
    return array;
}

-(void)getImageDataIfNotPresent
{
    if(self.ImgData == nil)
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.ImgUrl]];
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            self.ImgData = responseObject;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];
    }
}
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.Name forKey:@"Name"];
    [encoder encodeObject:self.APIUrl forKey:@"APIUrl"];
    [encoder encodeObject:self.ImgUrl forKey:@"ImgUrl"];
    
    [encoder encodeObject:self.TextColor forKey:@"TextColor"];
    [encoder encodeObject:self.PrimaryColor forKey:@"PrimaryColor"];
    [encoder encodeObject:self.SecondaryColor forKey:@"SecondaryColor"];
    
    [encoder encodeObject:self.ImgData forKey:@"ImgData"];
}

-(void)setImgUrl:(NSString *)ImgUrl
{
    _ImgUrl = ImgUrl;
    
    if(self.ImgData == nil)
        [self getImageDataIfNotPresent];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.Name = [decoder decodeObjectForKey:@"Name"];
        self.APIUrl = [decoder decodeObjectForKey:@"APIUrl"];
        self.ImgData = [decoder decodeObjectForKey:@"ImgData"];
        self.ImgUrl = [decoder decodeObjectForKey:@"ImgUrl"];
        
        self.TextColor = [decoder decodeObjectForKey:@"TextColor"];
        self.PrimaryColor = [decoder decodeObjectForKey:@"PrimaryColor"];
        self.SecondaryColor = [decoder decodeObjectForKey:@"SecondaryColor"];
        
        
    }
    return self;
}

@end
