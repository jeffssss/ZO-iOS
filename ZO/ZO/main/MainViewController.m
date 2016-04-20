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
#import "ZONavigationBarView.h"

@interface MainViewController ()

@property(nonatomic,strong) ZONavigationBarView *navigationBarView;

@property(nonatomic,strong) UIImageView     *sealImageView;

@property(nonatomic,strong) UIButton        *createStuffBtn;
@property(nonatomic,strong) UIButton        *myfontBtn;
@property(nonatomic,strong) UIButton        *collectBtn;


@end


@implementation MainViewController

#pragma mark - life cycle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"字哦";
    //使用自定义的view来充当navigationbar
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"screen_background"]];
    
    [self sealImageView];
    [self collectBtn];
}

#pragma mark - component getter & setter
-(UIImageView *)sealImageView{
    if(nil == _sealImageView){
        UIImage *seal = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"sealimage"]];
        _sealImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 150)/2.0, self.navigationBarView.bottom, 150, 150)];
        _sealImageView.image = seal;
        _sealImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _sealImageView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_sealImageView];
    }
    return _sealImageView;
}


-(UIButton *)createStuffBtn{
    if(nil == _createStuffBtn){
        _createStuffBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.sealImageView.bottom + 20, kScreenWidth - 20*2, 36)];
        [self setButtonBorderAndFont:_createStuffBtn];
        [_createStuffBtn setTitle:@"创作作品" forState:UIControlStateNormal];
        [_createStuffBtn setTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_createStuffBtn];
    }
    return _createStuffBtn;
}
-(UIButton *)myfontBtn{
    if(nil == _myfontBtn){
        _myfontBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.createStuffBtn.bottom + 20, kScreenWidth - 20*2, 36)];
        [self setButtonBorderAndFont:_myfontBtn];
        [_myfontBtn setTitle:@"养成字库" forState:UIControlStateNormal];
        [_myfontBtn setTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_myfontBtn];
    }
    return _myfontBtn;
}
-(UIButton *)collectBtn{
    if(nil == _collectBtn){
        _collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.myfontBtn.bottom + 20, kScreenWidth - 20*2, 36)];
        [self setButtonBorderAndFont:_collectBtn];
        [_collectBtn setTitle:@"收集素材" forState:UIControlStateNormal];
        [_collectBtn setTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_collectBtn];
    }
    return _collectBtn;
}

-(ZONavigationBarView *)navigationBarView{
    if(nil == _navigationBarView){
        _navigationBarView = [[ZONavigationBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 120)];
        _navigationBarView.titleLabel.text = self.title;
        [self.view addSubview:_navigationBarView];
        
    }
    return _navigationBarView;
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

#pragma mark -Private
-(void)setButtonBorderAndFont:(UIButton *)button{
    button.titleLabel.font = [UIFont fontWithName:@"-" size:25];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 2.0;
    button.layer.cornerRadius = button.height/2.0;
}
@end
