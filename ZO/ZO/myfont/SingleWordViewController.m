//
//  SingleWordViewController.m
//  ZO
//
//  Created by JiFeng on 16/3/10.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "SingleWordViewController.h"
#import "FMDBHelper.h"
#import "ZOPNGManager.h"

@interface SingleWordViewController ()

@property(nonatomic,strong) UIView      *bottomView;
@property(nonatomic,strong) UIButton    *deleteBtn;

@property(nonatomic,strong) UIView      *middelView;
@property(nonatomic,strong) UIImageView *tianBackgroundImageView;
@property(nonatomic,strong) UIImageView *wordImageView;

@end

@implementation SingleWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self wordImageView];
    [self deleteBtn];
}
#pragma mark -getter
-(UIView *)bottomView{
    if(nil == _bottomView){
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 60, kScreenWidth, 60)];
        _bottomView.backgroundColor = UIColorHex(0x656565);
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

-(UIButton *)deleteBtn {
    if(nil == _deleteBtn){
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomView.width - 60, 5, 50, 50)];
        [_deleteBtn setTitle:@"D" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_deleteBtn setTarget:self action:@selector(onDeleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_deleteBtn];
    }
    return _deleteBtn;
}

-(UIView *)middelView{
    if(nil == _middelView){
        _middelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.bottomView.height)];
        _middelView.backgroundColor = UIColorHex(0xD8D8D8);
        [self.view addSubview:_middelView];
    }
    return _middelView;
}

-(UIImageView *)tianBackgroundImageView{
    if(nil == _tianBackgroundImageView){
        _tianBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.middelView.height - kScreenWidth)/2.0, kScreenWidth, kScreenWidth)];
        _tianBackgroundImageView.image = [UIImage imageNamed:@"tianzige"];
        [self.middelView addSubview:_tianBackgroundImageView];
    }
    return _tianBackgroundImageView;
}
-(UIImageView *)wordImageView{
    if(nil == _wordImageView){
        _wordImageView = [[UIImageView alloc] initWithFrame:self.tianBackgroundImageView.frame];
        _wordImageView.image = [ZOPNGManager imageWithFilename:self.model.filename];
        [self.middelView addSubview:_wordImageView];
    }
    return _wordImageView;
}

#pragma mark - SEL 
-(void)onDeleteBtnClick{
    //TODO: 确认删除
    
    //数据库中删除记录
    if(![[FMDBHelper sharedManager] deleteById:self.model.zoid]){
        //TODO: 返回错误提示，删除失败
        return;
    }
    //删除本地文件（如果本地删除失败也要返回成功消息，因为数据库的数据已经不见了）
    [ZOPNGManager deletePNGImage:self.model.filename];
    
    //TODO: 提示删除成功
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
