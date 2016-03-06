//
//  AppDelegate.m
//  ZO
//
//  Created by JiFeng on 16/3/4.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "AppDelegate.h"
#import "PennameViewController.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self checkPenname];
    
    return YES;
}

-(void)checkPenname{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"penname"]){
        //有笔名，不是第一次打开，进入主页
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    } else {
        //没有笔名，进入注册页
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[PennameViewController alloc] init]];
    }
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[PennameViewController alloc] init]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
