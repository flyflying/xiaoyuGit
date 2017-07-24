//
//  AppDelegate.m
//  XiaoyuDemo
//
//  Created by smallpay on 17/3/21.
//  Copyright © 2017年 yml. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LaunchImageView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController * vc= [[ViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    
    NSString * urlStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490097035427&di=f2223f43ce864e813ae491269dd16fa8&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201407%2F15%2F20140715170607_3adZL.jpeg";
    LaunchImageView * lauchView = [[LaunchImageView alloc] initWithWindow:self.window Type:FullScreenLaunchType AddImageURL:urlStr];
    
    lauchView.clickBlock= ^(ClickType clickType){
        
        switch (clickType) {
            case AdvertLaunchType:{
                
                Mylog(@"进入广告");

                UIViewController * presentvc = [[UIViewController alloc] init];
                presentvc.title = @"广告";
                presentvc.view.backgroundColor = [UIColor yellowColor];
                [nav pushViewController:presentvc animated:YES];
                
            }
                break;
                
            case SkipLaunchType:{
                
                Mylog(@"跳过广告");

            }
            default:
                break;
        }
        
    };

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
