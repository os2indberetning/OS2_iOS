/* Copyright (c) OS2 2016
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//
//  SavedReport.m
//  OS2Indberetning
//

#import "SavedReport.h"

@implementation SavedReport

+(SavedReport *) parseFromJsonString :(NSString *) jsonString{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &e];
    if(e!=nil){
        NSLog(@"ERROR HAPPEND");
        return nil;
    }
    return [SavedReport parseFromJsonDict:JSON];
}

+(SavedReport *)parseFromJsonDict:(NSDictionary *) JSON{
    SavedReport * result = [SavedReport new];

    result.jsonToSend = JSON[@"jsonToSend"];
    result.purpose = JSON[@"purpose"];
    result.rate = JSON[@"rate"];
    result.totalDistance = JSON[@"totalDistance"];

    result.createdAt = [NSDate dateWithTimeIntervalSince1970:[(NSNumber*)JSON[@"createdAt"] doubleValue]];
    return result;
}


+(NSMutableArray* ) parseAllFromJson:(NSString *)json{
    if(json==nil){
        return [NSMutableArray new];
    }
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &e];
    NSMutableArray * result = [NSMutableArray new];
    for (int i=0; i<[JSON count]; i++) {
        [result addObject:[SavedReport parseFromJsonDict:[JSON objectAtIndex:i]]];
    }
    return result;
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.jsonToSend = [decoder decodeObjectForKey:@"jsonToSend"];
    self.purpose = [decoder decodeObjectForKey:@"purpose"];
    self.createdAt = [decoder decodeObjectForKey:@"createdAt"];
    self.rate = [decoder decodeObjectForKey:@"rate"];
    self.totalDistance = [decoder decodeObjectForKey:@"totalDistance"];
    
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.jsonToSend forKey:@"jsonToSend"];
    [encoder encodeObject:self.purpose forKey:@"purpose"];
    [encoder encodeObject:self.createdAt forKey:@"createdAt"];
    [encoder encodeObject:self.rate forKey:@"rate"];
    [encoder encodeObject:self.totalDistance forKey:@"totalDistance"];

}

+(NSString *) saveArrayToJson:(NSArray *)arr{
    NSError *error;
    NSMutableArray * parts = [NSMutableArray new];
    for (SavedReport * report in arr){
        [parts addObject:[report saveToJson]];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parts
                                                       options:0
                                                         error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+(SavedReport *) parseFromNSData :(NSData *) data{
    return [SavedReport parseFromJsonString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
}

-(NSDictionary *)saveToJson{
    NSDictionary *JSON = @{
                           @"jsonToSend":[SavedReport safeGetObject:self.jsonToSend withDefault:@""],
                           @"purpose":[SavedReport safeGetObject:self.purpose withDefault:@""],
                           @"rate":[SavedReport safeGetObject:self.rate withDefault:@""],
                           @"totalDistance":[SavedReport safeGetObject:self.totalDistance withDefault:@0],
                           @"createdAt":[NSNumber numberWithLongLong:[[SavedReport safeGetObject:self.createdAt withDefault:[NSDate new]] timeIntervalSince1970]]
                           };
    
    return JSON;
}

+(id)safeGetObject:(id)opt withDefault:(id) def{
    if(opt==nil){
        return def;
    }
    return opt;
}

-(BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[SavedReport class]]) {
        return NO;
    }
    
    SavedReport * other =  (SavedReport * )object;
    
    BOOL isEqual = [[other jsonToSend] isEqualToString:self.jsonToSend] &&
                    [[other purpose] isEqualToString:self.purpose] &&
                    [[other rate] isEqualToString:self.rate]&&
                     [self.totalDistance isEqualToNumber:other.totalDistance];
   
    return isEqual;
    
}
@end