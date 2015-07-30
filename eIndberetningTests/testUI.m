//
//  testUI.m
//  eIndberetning
//
//  Created by Anders Faurholdt on 30/07/15.
//  Copyright (c) 2015 IT-Minds. All rights reserved.
//

#import "testUI.h"
#import "ViewController+helper.h"

@implementation testUI

- (void)beforeEach {
    [UIViewController returnToRootViewController];
    [tester waitForAnimationsToFinish];
}

- (void)afterEach {
    
}

- (void)testLogin {
    
}

@end