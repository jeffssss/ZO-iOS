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
#import "SplashViewController.h"
#import "BezierPathAnimationView.h"

@interface AppDelegate ()<SplashViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSArray *familyNames = [UIFont familyNames];
    for(NSString *familyName in familyNames)
    {
        NSLog(@"%@", familyName);
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for(NSString *fontName in fontNames)
        {
            NSLog(@"\t%@", fontName);
        }  
    }
    
    //performe splash
    [self performSplash];

    [self.window makeKeyAndVisible];
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

-(void)performSplash{
    SplashViewController *splashVC = [[SplashViewController alloc] init];
    splashVC.delegate = self;
    splashVC.delay = 2.0f;//从VC开始到退出的时间
    splashVC.performanceBlock = ^(UIView *stageView){
        //加入动画
        BezierPathAnimationView *bview = [[BezierPathAnimationView alloc] initWithFrame:CGRectMake(20, 150, kScreenWidth - 20*2 , 80)];
        bview.displayString = @"写我所写";
        bview.duration = 1.0f;
        [stageView addSubview:bview];
        [bview beginAnimate];
    };
    //获取启动页图片
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, self.window.bounds.size) && [@"Portrait" isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            splashVC.backgroundImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    self.window.rootViewController = splashVC;
}

- (void)splashDidPerform:(SplashViewController *)splashScreen{
    
    //延迟退出
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( splashScreen.delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"退出");
        //启动动画完成 显示状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        //正常启动
        [self checkPenname];
    });
    

    
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
