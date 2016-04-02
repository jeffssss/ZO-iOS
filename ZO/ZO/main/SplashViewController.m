//
//  SplashViewController.m
//  ZO
//
//  Created by JiFeng on 16/4/2.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@property(nonatomic,strong) UIImageView     *backgroundImageView;

@property(nonatomic,strong) UIView      *stageView;//舞台

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _backgroundImageView.image = self.backgroundImage;
    [self.view addSubview:_backgroundImageView];
//    self.view.layer.contentsScale = [[UIScreen mainScreen] scale];
//    self.view.layer.contents = (id)self.backgroundImage.CGImage;
//    self.view.contentMode =UIViewContentModeScaleAspectFill;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.delegate respondsToSelector:@selector(splashWillPerform:)]) {
        NSLog(@"delegate splashWillPerform");
        [self.delegate splashWillPerform:self];
    }
    
    //performance
    if(self.performanceBlock){
        NSLog(@"before performanceBlock");
        self.performanceBlock(self.stageView);
        NSLog(@"after performanceBlock");
    }
    
    //performance结束
    if ([self.delegate respondsToSelector:@selector(splashDidPerform:)]) {
        NSLog(@"delegate splashDidPerform");
        [self.delegate splashDidPerform:self];
    }
}

-(UIView *)stageView{
    if(nil == _stageView){
        _stageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _stageView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_stageView];
    }
    return _stageView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
