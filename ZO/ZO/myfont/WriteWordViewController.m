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
        _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 50)];
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
    model.type = [self typeWithNameString:self.nameString];
    model.name = self.nameString;
    model.createtime = [NSDate date];
    
    if(![[FMDBHelper sharedManager] insertData:model]){
        NSLog(@"fmdb insert fail！！！！！！！！！！！！！");
        return;
    }
    
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private
//获取分类，一级汉字=1 二级汉子=2 其他=3
-(int)typeWithNameString:(NSString *)namestr{
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [namestr dataUsingEncoding:encoding];
    Byte *bytes = (Byte *)[data bytes];
    //获取到区码
//    NSInteger randomH = bytes[1];
    NSInteger randomL = bytes[0];
    NSInteger areaCode = randomL - 160;
//    NSLog(@"区码：%ld",areaCode);
//    NSLog(@"byte[1]=%ld,byte[0]=%ld",randomH,randomL);
    //16~87区为汉字区，包含6763个汉字 。其中16-55区为一级汉字(3755个最常用的汉字，按拼音字母的次序排列)，56-87区为二级汉字(3008个汉字，按部首次序排列)。
    if(areaCode > 15 && areaCode < 56){
        return 1;
    }
    if(areaCode > 55 && areaCode <88){
        return 2;
    }
    return 3;

}
//测试用
-(void)printCode:(NSString *)string{
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [string dataUsingEncoding:encoding];
    NSLog(@"length of data:%lu",(unsigned long)[data length]);
    Byte *bytes = (Byte *)[data bytes];
    for(int i = 0 ; i < [data length] ; i++){
        NSLog(@"data[%d] = %d",i,bytes[i]);
    }
}
//测试用
-(void)printFont{
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //data[0] = 199
    //data[1] = 208
    NSInteger randomH = 208;
    
    NSInteger randomL = 199;
    
    NSInteger number = (randomH<<8)+randomL;
    NSData *data = [NSData dataWithBytes:&number length:2];
    
    NSString *string = [[NSString alloc] initWithData:data encoding:gbkEncoding];
    
    NSLog(@"%@",string);
}
@end
