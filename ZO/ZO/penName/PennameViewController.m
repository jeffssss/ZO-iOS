//
//  PennameViewController.m
//  ZO
//
//  Created by JiFeng on 16/3/4.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "PennameViewController.h"
#import "SealView.h"
#import "MainViewController.h"
#import "ZONavigationBarView.h"

@interface PennameViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UIImageView     *pennameBackgroundImageView;
@property(nonatomic,strong) UITextField     *pennameTextField;
@property(nonatomic,strong) UIButton        *okBtn;

@property(nonatomic,strong) SealView     *sealImageView;

@property(nonatomic,strong) ZONavigationBarView *navigationBarView;
@end


@implementation PennameViewController

#pragma mark - life cycle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"选择笔名";
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"screen_background"]];
    [self pennameTextField];
    [self okBtn];
    [self.sealImageView adjustFrame];
}

#pragma mark - component getter & setter
-(ZONavigationBarView *)navigationBarView{
    if(nil == _navigationBarView){
        _navigationBarView = [[ZONavigationBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 120)];
        _navigationBarView.titleLabel.text = self.title;
        [self.view addSubview:_navigationBarView];
        
    }
    return _navigationBarView;
}

-(UIImageView *)pennameBackgroundImageView{
    if(nil == _pennameBackgroundImageView){
        _pennameBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, self.sealImageView.bottom +30 , kScreenWidth - 30*2, 22)];
        _pennameBackgroundImageView.image = [UIImage imageNamed:@"brush_line"];
        [self.view addSubview:_pennameBackgroundImageView];
    }
    return _pennameBackgroundImageView;
}

-(UITextField *)pennameTextField{
    if(nil == _pennameTextField){
        _pennameTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.pennameBackgroundImageView.left, self.pennameBackgroundImageView.top - 20, self.pennameBackgroundImageView.width, 25)];
        _pennameTextField.placeholder = @"请输入笔名,限六字";
        _pennameTextField.textAlignment = NSTextAlignmentCenter;
        _pennameTextField.font = [UIFont fontWithName:@"-" size:20];
        _pennameTextField.delegate = self;
        [_pennameTextField addTarget:self action:@selector(refreshSeal) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_pennameTextField];
    }
    return _pennameTextField;
}

-(UIButton *)okBtn{
    if(nil == _okBtn){
        _okBtn = [[UIButton alloc] initWithFrame:CGRectMake( (kScreenWidth - 150 )/2.0, self.pennameBackgroundImageView.bottom + 30, 150, 30)];
        _okBtn.titleLabel.font = [UIFont fontWithName:@"-" size:25];
        _okBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _okBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _okBtn.layer.borderWidth = 2.0;
        _okBtn.layer.cornerRadius = _okBtn.height/2.0;
        [_okBtn setTitle:@"进入字哦" forState:UIControlStateNormal];
        [_okBtn setTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_okBtn];
    }
    return _okBtn;
}

-(SealView *)sealImageView{
    if(nil == _sealImageView){
        _sealImageView = [[SealView alloc] initWithFrame:CGRectMake( (kScreenWidth - 200)/2.0, self.navigationBarView.bottom, 150, 150)];
        _sealImageView.backgroundColor = [UIColor clearColor];
        _sealImageView.opaque = NO;//默认为YES，则截图后背景是黑色的。
        [self.view addSubview:_sealImageView];
    }
    return _sealImageView;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // 滚动到键盘上方
    [UIView beginAnimations:@"moveUpView" context:nil];
    [UIView setAnimationDuration:0.3f];
    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y - 100;
    self.view.frame = frame;
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    // 恢复
    [UIView beginAnimations:@"moveUpView" context:nil];
    [UIView setAnimationDuration:0.3f];
    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y + 100;
    self.view.frame = frame;
    [UIView commitAnimations];
}

#pragma mark - sel
-(void)onBtnClick:(id)sender{
    if([self.pennameTextField.text isEqualToString:@""] || [self.pennameTextField.text length]>6){
        return;
    }
    
//    [self refreshSeal];
    
    //TODO:提示用户是否确定
    
    //当点确认后
    //生成截图 放到存到userDefault
    NSData *imageData=[NSKeyedArchiver archivedDataWithRootObject:[self.sealImageView snapshotImage]];
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"sealimage"];
    [[NSUserDefaults standardUserDefaults] setObject:self.pennameTextField.text forKey:@"penname"];
    
    //跳转到mian
    MainViewController *mainViewController = [[MainViewController alloc] init];
    UINavigationController *mainControllerNav =  [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [[UIApplication sharedApplication].delegate window].rootViewController = mainControllerNav;
    
}

-(void)refreshSeal{
    if([self.pennameTextField.text length]>6){
        return;
    }
    self.sealImageView.nameString = self.pennameTextField.text;
    [self.sealImageView adjustFrame];
}

@end
