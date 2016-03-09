//
//  WriteWordViewController.m
//  ZO
//
//  Created by JiFeng on 16/3/7.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "WriteWordViewController.h"
#import "ZO-Swift.h"
#import "ZOPNGManager.h"
#import "FMDBHelper.h"

@interface WriteWordViewController ()

@property(nonatomic,strong) UIView          *brushContentView;
@property(nonatomic,strong) UIImageView     *tianBackgroundImageView;
@property(nonatomic,strong) AFBrushBoard    *brushBoard;
@property(nonatomic,strong) UIButton        *clearBtn;
@property(nonatomic,strong) UIButton        *completeBtn;

@end

@implementation WriteWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clearBtn];
    [self tianBackgroundImageView];
    [self completeBtn];
    [self brushContentView];
    [self brushBoard];
}

#pragma mark - getter
-(UIButton *)clearBtn{
    if(nil == _clearBtn){
        _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 50)];
        [_clearBtn setTitle:@"clear" forState:UIControlStateNormal];
        [_clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_clearBtn setBackgroundColor:[UIColor grayColor]];
        [_clearBtn setTarget:self action:@selector(onClearBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_clearBtn];
    }
    return _clearBtn;
}

-(UIButton *)completeBtn{
    if(nil == _completeBtn){
        _completeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bottom - 50, kScreenWidth, 50)];
        [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_completeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_completeBtn setBackgroundColor:[UIColor grayColor]];
        [_completeBtn setTarget:self action:@selector(onCompleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_completeBtn];
    }
    return _completeBtn;
}

-(UIView *)brushContentView{
    if(nil == _brushContentView){
        _brushContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.clearBtn.bottom, kScreenWidth, self.completeBtn.top - self.clearBtn.bottom)];
        _brushContentView.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:_brushContentView];
    }
    return _brushContentView;
}
-(UIImageView *)tianBackgroundImageView{
    if(nil == _tianBackgroundImageView){
        _tianBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.brushContentView.height - kScreenWidth)/2.0, kScreenWidth, kScreenWidth)];
        _tianBackgroundImageView.image = [UIImage imageNamed:@"tianzige"];
        [self.brushContentView addSubview:_tianBackgroundImageView];
    }
    return _tianBackgroundImageView;
}
-(AFBrushBoard *)brushBoard{
    if(nil == _brushBoard){
        _brushBoard = [[AFBrushBoard alloc] initWithFrame:CGRectMake(0, (self.brushContentView.height - kScreenWidth)/2.0, kScreenWidth, kScreenWidth)];
        [self.brushContentView addSubview:_brushBoard];
    }
    return _brushBoard;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SEL

-(void)onClearBtnClick{
    [self.brushBoard btnClick];
}
-(void)onCompleteBtnClick{
    if([self.nameString length]!=1){
        NSLog(@"self.namestring出错了！！！！！！！！！！！！！！！！！！！！");
    }
    NSString *filename = [ZOPNGManager saveImageToPNG:self.brushBoard.image withName:self.nameString];
    if(nil == filename){
        return;
    }
    
    //存到数据库里。
    
    //先假设全部都是一级汉字.
    ZOFontModel *model = [[ZOFontModel alloc] init];
    model.filename = filename;
    model.type = 1;
    model.name = self.nameString;
    model.createtime = [NSDate date];
    
    if(![[FMDBHelper sharedManager] insertData:model]){
        NSLog(@"fmdb insert fail！！！！！！！！！！！！！");
        return;
    }
    
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
@end
