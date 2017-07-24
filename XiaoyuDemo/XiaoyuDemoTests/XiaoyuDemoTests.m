//
//  XiaoyuDemoTests.m
//  XiaoyuDemoTests
//
//  Created by smallpay on 17/3/30.
//  Copyright © 2017年 yml. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LaunchImageView.h"


@interface XiaoyuDemoTests : XCTestCase

@property(nonatomic, strong) LaunchImageView * launchView;

@end

@implementation XiaoyuDemoTests

- (void)setUp {
    [super setUp];
    
    NSString * urlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490097035427&di=f2223f43ce864e813ae491269dd16fa8&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201407%2F15%2F20140715170607_3adZL.jpeg";
    
    self.launchView = [[LaunchImageView alloc] initWithWindow:[UIApplication sharedApplication].keyWindow Type:FullScreenLaunchType AddImageURL:urlStr];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    
    _launchView = nil;
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [_launchView skip];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        for (int i = 0; i<100; i++) {
            
            NSLog(@"dd");
        }
    }];
}

@end
