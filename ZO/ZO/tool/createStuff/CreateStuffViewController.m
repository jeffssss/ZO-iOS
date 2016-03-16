//
//  CreateStuffViewController.m
//  ZO
//
//  Created by JiFeng on 16/3/11.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "CreateStuffViewController.h"
#import "CreateStuffToolbar.h"
#import <UIView+draggable/UIView+draggable.h>
#import "InputNameView.h"
#import "FMDBHelper.h"
#import "ZOPNGManager.h"

@interface CreateStuffViewController ()<UITextFieldDelegate,InputNameDelegate>

@property(nonatomic,strong) UIButton            *addTextBtn;
@property(nonatomic,strong) UIButton            *addBackgroundBtn;//TODO:之后提供可选的背景图
@property(nonatomic,strong) UIButton            *addImageViewBtn;//TODO:blank模式没有次选项

@property(nonatomic,strong) UIView              *middleView;//中间的view，当二级Toolbar出现，middleView的高度变小
@property(nonatomic,strong) UIView              *canvasView;//中间的画布，在middle中居中。

@property(nonatomic,strong) CreateStuffToolbar  *bottomToolbar;
@property(nonatomic,strong) KLCPopup            *inputNamePopup;
@end

@implementation CreateStuffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%d",self.type);
    
    self.title = @"编辑";
    //tabnavbar
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddTextBtnClick:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
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
-(KLCPopup *)inputNamePopup{
    if(nil == _inputNamePopup){
        InputNameView *inputNameView = [[InputNameView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.1, 0, kScreenWidth * 0.8, 120)];
        inputNameView.inputNameDelegate = self;
        inputNameView.textFieldDelegate = self;
        _inputNamePopup = [KLCPopup popupWithContentView:inputNameView
                                                showType:KLCPopupShowTypeGrowIn
                                             dismissType:KLCPopupDismissTypeGrowOut
                                                maskType:KLCPopupMaskTypeDimmed
                                dismissOnBackgroundTouch:YES
                                   dismissOnContentTouch:NO];
    }
    return _inputNamePopup;
}
#pragma mark - SEL 
-(void)onAddTextBtnClick:(id)sender{
    [self.inputNamePopup show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // 滚动到键盘上方
    [UIView beginAnimations:@"moveUpView" context:nil];
    [UIView setAnimationDuration:0.3f];
    CGRect frame = self.inputNamePopup.contentView.frame;
    frame.origin.y = frame.origin.y - 100;
    self.inputNamePopup.contentView.frame = frame;
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    // 恢复
    [UIView beginAnimations:@"moveUpView" context:nil];
    [UIView setAnimationDuration:0.3f];
    CGRect frame = self.inputNamePopup.contentView.frame;
    frame.origin.y = frame.origin.y + 100;
    self.inputNamePopup.contentView.frame = frame;
    [UIView commitAnimations];
}
#pragma mark - InputNameView Delegate
-(void)onInputNameOKBtnClick:(NSString *)nameStr{
    if([nameStr length]!=1){
        return;
    }
    NSMutableArray *result = [[FMDBHelper sharedManager] query:[NSString stringWithFormat:@"select * from zofont where name = '%@' order by createtime desc limit 1",nameStr]];
    UIImageView *wordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    wordImageView.backgroundColor = [UIColor greenColor];
    if(result.count>0){
        //有结果
        wordImageView.image = [ZOPNGManager imageWithFilename:[(ZOFontModel *)result[0] filename]];
    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:wordImageView.frame];
        label.text = nameStr;
        label.font = [UIFont systemFontOfSize:label.width*0.8];
        label.textAlignment = NSTextAlignmentCenter;
        [wordImageView addSubview:label];
    }
    wordImageView.userInteractionEnabled = YES;
    [wordImageView enableDragging];
    
    [self.canvasView addSubview:wordImageView];
    [self.inputNamePopup dismiss:YES];
}

@end
