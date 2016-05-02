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
#import "SimpleNavigationBarView.h"
#import "WordWithTZGView.h"

@interface SingleWordViewController ()

@property(nonatomic,strong) SimpleNavigationBarView *navigationBarView;
@property(nonatomic,strong) UIView      *bottomView;
@property(nonatomic,strong) UIButton    *deleteBtn;

//@property(nonatomic,strong) UIView      *middelView;
//@property(nonatomic,strong) UIImageView *tianBackgroundImageView;
@property(nonatomic,strong) WordWithTZGView *wordImageView;

@end

@implementation SingleWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.name;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"screen_background"]];
    
    [self navigationBarView];
    [self wordImageView];
    [self deleteBtn];
}
#pragma mark -getter
-(SimpleNavigationBarView *)navigationBarView{
    if(nil == _navigationBarView){
        _navigationBarView = [[SimpleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _navigationBarView.titleLabel.text = self.title;
        [_navigationBarView.backBtn setTarget:self action:@selector(onBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_navigationBarView];
        
    }
    return _navigationBarView;
}
-(UIView *)bottomView{
    if(nil == _bottomView){
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.wordImageView.bottom, kScreenWidth, kScreenHeight - self.wordImageView.bottom)];
//        _bottomView.backgroundColor = UIColorHex(0x656565);
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

-(UIButton *)deleteBtn {
    if(nil == _deleteBtn){
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomView.width - 60, (self.bottomView.height - 50)/2.0, 50, 50)];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
        [_deleteBtn setTarget:self action:@selector(onDeleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_deleteBtn];
    }
    return _deleteBtn;
}

//-(UIView *)middelView{
//    if(nil == _middelView){
//        _middelView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom, kScreenWidth, kScreenHeight-self.bottomView.height - self.bottomView.height)];
//        _middelView.backgroundColor = UIColorHex(0xD8D8D8);
//        [self.view addSubview:_middelView];
//    }
//    return _middelView;
//}

//-(UIImageView *)tianBackgroundImageView{
//    if(nil == _tianBackgroundImageView){
//        _tianBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (self.middelView.height - kScreenWidth + 20 * 2)/2.0, kScreenWidth - 20 * 2, kScreenWidth - 20 * 2)];
//        _tianBackgroundImageView.image = [UIImage imageNamed:@"tianzige"];
//        [self.middelView addSubview:_tianBackgroundImageView];
//    }
//    return _tianBackgroundImageView;
//}
-(WordWithTZGView *)wordImageView{
    if(nil == _wordImageView){
        _wordImageView = [[WordWithTZGView alloc] initWithFrame:CGRectMake(20, (kScreenHeight - (kScreenWidth - 20 * 2) )/2.0, kScreenWidth - 20 * 2, kScreenWidth - 20 * 2) andWordImage:[ZOPNGManager imageWithFilename:self.model.filename]];
        [self.view addSubview:_wordImageView];
    }
    return _wordImageView;
}

#pragma mark - SEL 
-(void)onBackBtnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onDeleteBtnClick{
    //TODO: 确认删除alert
    
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
