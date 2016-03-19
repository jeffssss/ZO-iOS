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
#import "WordImageView.h"
#import "PreviewViewController.h"
@interface CreateStuffViewController ()<UITextFieldDelegate,InputNameDelegate,CreateStuffToolbarDelegate>

@property(nonatomic,strong) UIButton            *addTextBtn;
@property(nonatomic,strong) UIButton            *addBackgroundBtn;//TODO:之后提供可选的背景图
@property(nonatomic,strong) UIButton            *addImageViewBtn;//TODO:blank模式没有次选项

@property(nonatomic,strong) UIView              *middleView;//中间的view，当二级Toolbar出现，middleView的高度变小
@property(nonatomic,strong) UIView              *canvasView;//中间的画布，在middle中居中。
@property(nonatomic,strong) NSMutableDictionary *wordImageDictionary;
@property(nonatomic,strong) WordImageView       *currentImageView;//当前选中的view


@property(nonatomic,strong) CreateStuffToolbar  *bottomToolbar;
@property(nonatomic,strong) KLCPopup            *inputNamePopup;
@end

@implementation CreateStuffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"%d",self.type);
    
    self.title = @"编辑";
    //tabnavbar
    UIBarButtonItem *rightButtonAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddTextBtnClick:)];
    UIBarButtonItem *rightButtonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onFinishBtnClick:)];
    self.navigationItem.rightBarButtonItems = @[rightButtonAdd,rightButtonDone];
    
    [self bottomToolbar];
    [self middleView];
    [self canvasView];
    [self.view bringSubviewToFront:_bottomToolbar];
    
    //初始化wordImageDictionary
    self.wordImageDictionary = [[NSMutableDictionary alloc] init];
    
}

#pragma mark -getter
-(CreateStuffToolbar *)bottomToolbar{
    if(nil == _bottomToolbar){
        _bottomToolbar = [[CreateStuffToolbar alloc] initWithFrame:CGRectMake(0, self.view.height-70, kScreenWidth, 70)];
        _bottomToolbar.delegate = self;
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
        UIImageView *seal = [[UIImageView alloc] initWithFrame:CGRectMake(10, _canvasView.bottom - 110, 100, 100)];
        seal.image = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"sealimage"]];;
        seal.contentMode = UIViewContentModeScaleAspectFit;
        [_canvasView addSubview:seal];
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

-(void)onFinishBtnClick:(id)sender{
    
    //完成之前先把选中的红框框去掉
    self.currentImageView.layer.borderWidth = 0;
    
    PreviewViewController *previewVC = [[PreviewViewController alloc] init];
    previewVC.previewImage = [self.canvasView snapshotImage];
    [self.navigationController pushViewController:previewVC animated:YES];

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

#pragma mark - CreateStuffToolbarDelegate
-(void)fontImageViewClick:(id)sender{
    if([(WordImageView *)sender isFromZOModel]){
        self.currentImageView.model = [(WordImageView *)sender model];
    } else {
        self.currentImageView.nameString = [(WordImageView *)sender nameString];
    }
    
}
-(void)colorImageViewClick:(UIColor *)color{
    self.currentImageView.imageColor = color;
}

-(void)sizeBtnClick:(int)method{
    switch (method) {
        case 1:
            //小
            [self.currentImageView changeSize:-5];
            break;
        case 2:
            //大
            [self.currentImageView changeSize:5];
            break;
        default:
            break;
    }
}
-(void)deleteBtnClick{
    [self.currentImageView removeFromSuperview];
    self.currentImageView = nil;
}

#pragma mark - InputNameView Delegate
-(void)onInputNameOKBtnClick:(NSString *)nameStr{
    if([nameStr length]!=1){
        return;
    }
    NSMutableArray *result = [[FMDBHelper sharedManager] query:[NSString stringWithFormat:@"select * from zofont where name = '%@' order by createtime desc limit 1",nameStr]];
    WordImageView *wordImageView = [[WordImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    wordImageView.backgroundColor = [UIColor greenColor];
    if(result.count>0){
        //有结果
        wordImageView.model = result[0];
    } else {
        wordImageView.nameString = nameStr;
    }
    wordImageView.userInteractionEnabled = YES;
    [wordImageView enableDragging];
    wordImageView.cagingArea = self.canvasView.bounds;
    //在拖动之前需要变成选中状态,但是如果拖动稍微快了一点，就不会调用startedBlock 所以要用endedblock
//    wordImageView.draggingStartedBlock =  ^(id sender){
//        [self chooseWordImageView: sender];
//    };
    wordImageView.draggingEndedBlock =  ^(id sender){
        [self chooseWordImageView: sender];
    };
    
    
    [self.canvasView addSubview:wordImageView];
    
    //给word添加tap识别器
    [wordImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [self chooseWordImageView:(WordImageView *)[(UITapGestureRecognizer *)sender view]];
    }]];
    
    //放到dictionary里
    [self.wordImageDictionary setObject:wordImageView forKey:nameStr];
    
    [self.inputNamePopup dismiss:YES];
}

-(void)chooseWordImageView:(WordImageView *)wordimageview{
    //删除边框
    self.currentImageView.layer.borderWidth = 0;
    
    //添加边框
    self.currentImageView = wordimageview;
    wordimageview.layer.borderWidth = 1.0f;
    wordimageview.layer.borderColor = [UIColor redColor].CGColor;
    [self.canvasView bringSubviewToFront:wordimageview];
    
    self.bottomToolbar.selectedWordString = wordimageview.nameString;
    
}


@end
