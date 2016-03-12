//
//  CreateStuffViewController.m
//  ZO
//
//  Created by JiFeng on 16/3/11.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "CreateStuffViewController.h"
#import "CreateStuffToolbar.h"

@interface CreateStuffViewController ()

@property(nonatomic,strong) UIButton            *addTextBtn;
@property(nonatomic,strong) UIButton            *addBackgroundBtn;//TODO:之后提供可选的背景图
@property(nonatomic,strong) UIButton            *addImageViewBtn;//TODO:blank模式没有次选项

@property(nonatomic,strong) UIView              *middleView;//中间的view，当二级Toolbar出现，middleView的高度变小
@property(nonatomic,strong) UIView              *canvasView;//中间的画布，在middle中居中。

@property(nonatomic,strong) CreateStuffToolbar  *bottomToolbar;

@end

@implementation CreateStuffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%d",self.type);
    
    self.title = @"编辑";
    
    
    [self bottomToolbar];
    [self middleView];
    [self canvasView];
    [self.view bringSubviewToFront:_bottomToolbar];
}

#pragma mark -getter
-(CreateStuffToolbar *)bottomToolbar{
    if(nil == _bottomToolbar){
        _bottomToolbar = [[CreateStuffToolbar alloc] initWithFrame:CGRectMake(0, self.view.height-70, kScreenWidth, 70)];
        
        [self.view addSubview:_bottomToolbar];
    }
    return _bottomToolbar;
}

-(UIView *)middleView{
    if(nil == _middleView){
        _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, self.bottomToolbar.top - 64)];
        _middleView.backgroundColor = UIColorHex(0xD8D8D8);
        [self.view addSubview:_middleView];
    }
    return _middleView;
}

-(UIView *)canvasView{
    if(nil == _canvasView){
        //初始状态下，按4:3来
        _canvasView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.middleView.height - kScreenWidth*4/3.0)/2.0, kScreenWidth, kScreenWidth*4/3.0)];
        _canvasView.backgroundColor = [UIColor whiteColor];
        [self.middleView addSubview:_canvasView];
    }
    return _canvasView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
