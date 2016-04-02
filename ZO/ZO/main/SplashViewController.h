//
//  SplashViewController.h
//  ZO
//
//  Created by JiFeng on 16/4/2.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SplashViewController;
@protocol SplashViewControllerDelegate <NSObject>

@optional
- (void)splashWillPerform:(SplashViewController *)splashScreen;
- (void)splashDidPerform:(SplashViewController *)splashScreen;
@end

@interface SplashViewController : UIViewController

@property(nonatomic,weak)   id<SplashViewControllerDelegate>    delegate;

@property(nonatomic,strong) UIImage     *backgroundImage;

@property(nonatomic,copy)   void (^performanceBlock)(UIView *);//参数是stageView，在block里执行需要的操作。

@property(nonatomic,assign) CGFloat     delay; //performanceBlock执行完后多久退出

@end
