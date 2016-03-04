//
//  PennameViewController.m
//  ZO
//
//  Created by JiFeng on 16/3/4.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "PennameViewController.h"
#import "SealView.h"

@interface PennameViewController ()

@property(nonatomic,strong) UIImageView     *backgroundImageView;
@property(nonatomic,strong) UILabel         *pennameLabel;
@property(nonatomic,strong) UITextField     *pennameTextField;
@property(nonatomic,strong) UIButton        *okBtn;

@property(nonatomic,strong) SealView     *sealImageView;

@end


@implementation PennameViewController

#pragma mark - life cycle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"选择笔名";
    self.view.backgroundColor = [UIColor whiteColor];
    [self pennameLabel];
    [self pennameTextField];
    [self okBtn];
    [self sealImageView];
}

#pragma mark - component getter & setter
-(UILabel *)pennameLabel{
    if(nil == _pennameLabel){
        _pennameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 40, 30)];
        _pennameLabel.text = @"笔名";
        _pennameLabel.textColor = [UIColor blackColor];
        _pennameLabel.font = [UIFont systemFontOfSize:20];
        [self.view addSubview:_pennameLabel];
    }
    return _pennameLabel;
}
-(UITextField *)pennameTextField{
    if(nil == _pennameTextField){
        _pennameTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.pennameLabel.right + 10, self.pennameLabel.top, 150, self.pennameLabel.height)];
        _pennameTextField.placeholder = @"请输入笔名(6字以内)";
        [_pennameTextField addTarget:self action:@selector(refreshSeal) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_pennameTextField];
    }
    return _pennameTextField;
}

-(UIButton *)okBtn{
    if(nil == _okBtn){
        _okBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, self.pennameLabel.bottom + 20, kScreenWidth - 40*2, 30)];
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_okBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_okBtn setTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_okBtn];
    }
    return _okBtn;
}

-(SealView *)sealImageView{
    if(nil == _sealImageView){
        _sealImageView = [[SealView alloc] initWithFrame:CGRectMake(30, self.okBtn.bottom+20, kScreenWidth - 30*2, 150)];
        _sealImageView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_sealImageView];
    }
    return _sealImageView;
}


#pragma mark - sel
-(void)onBtnClick:(id)sender{
    [self refreshSeal];
    
    
}

-(void)refreshSeal{
    if([self.pennameTextField.text length]>6){
        return;
    }
    self.sealImageView.nameString = self.pennameTextField.text;
    [self.sealImageView setNeedsDisplay];
}

@end
