//
//  MainViewController.m
//  ZO
//
//  Created by JiFeng on 16/3/4.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "MainViewController.h"
#import "MyFontViewController.h"
#import "ChooseTemplateViewController.h"

@interface MainViewController ()

@property(nonatomic,strong) UIImageView     *sealImageView;

@property(nonatomic,strong) UIButton        *createStuffBtn;
@property(nonatomic,strong) UIButton        *myfontBtn;
@property(nonatomic,strong) UIButton        *collectBtn;


@end


@implementation MainViewController

#pragma mark - life cycle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"首页";
    
    //self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self sealImageView];
    [self collectBtn];
}

#pragma mark - component getter & setter
-(UIImageView *)sealImageView{
    if(nil == _sealImageView){
        UIImage *seal = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"sealimage"]];
        _sealImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 64, seal.size.width, seal.size.height)];
        _sealImageView.image = seal;
//        _sealImageView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_sealImageView];
    }
    return _sealImageView;
}


-(UIButton *)createStuffBtn{
    if(nil == _createStuffBtn){
        _createStuffBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 30)];
        [_createStuffBtn setTitle:@"新的作品" forState:UIControlStateNormal];
        [_createStuffBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_createStuffBtn setTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_createStuffBtn];
    }
    return _createStuffBtn;
}
-(UIButton *)myfontBtn{
    if(nil == _myfontBtn){
        _myfontBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.createStuffBtn.bottom + 20, kScreenWidth, 30)];
        [_myfontBtn setTitle:@"字体养成" forState:UIControlStateNormal];
        [_myfontBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_myfontBtn setTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_myfontBtn];
    }
    return _myfontBtn;
}
-(UIButton *)collectBtn{
    if(nil == _collectBtn){
        _collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.myfontBtn.bottom + 20, kScreenWidth, 30)];
        [_collectBtn setTitle:@"收集素材" forState:UIControlStateNormal];
        [_collectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_collectBtn setTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_collectBtn];
    }
    return _collectBtn;
}

#pragma mark - SEL
-(void)onButtonClick:(id)sender{
    if(sender == self.myfontBtn){
        MyFontViewController *myfontViewController = [[MyFontViewController alloc] init];
        [self.navigationController pushViewController:myfontViewController animated:YES];
    } else if(sender == self.createStuffBtn){
        ChooseTemplateViewController *chooseTemplateVC = [[ChooseTemplateViewController alloc] init];
        [self.navigationController pushViewController:chooseTemplateVC animated:YES];
    }
}
@end
