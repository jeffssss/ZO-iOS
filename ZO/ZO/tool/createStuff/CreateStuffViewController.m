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
#import "SimpleNavigationBarView.h"

@interface CreateStuffViewController ()<UITextFieldDelegate,InputNameDelegate,CreateStuffToolbarDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong) SimpleNavigationBarView *navigationBarView;

@property(nonatomic,strong) UIButton            *addTextBtn; //添加字
@property(nonatomic,strong) UIButton            *doneBtn;
@property(nonatomic,strong) UIButton            *addBackgroundBtn;//TODO:之后提供可选的背景图
@property(nonatomic,strong) UIButton            *addImageViewBtn;//TODO:blank模式没有次选项

@property(nonatomic,strong) UIView              *middleView;//中间的view，当二级Toolbar出现，middleView的高度变小
@property(nonatomic,strong) UIView              *canvasView;//中间的画布，在middle中居中。
@property(nonatomic,strong) UIImageView         *photoImageView;//配图，type = 1和2的时候有
@property(nonatomic,strong) NSMutableDictionary *wordImageDictionary;
@property(nonatomic,strong) WordImageView       *currentImageView;//当前选中的view


@property(nonatomic,strong) CreateStuffToolbar  *bottomToolbar;
@property(nonatomic,strong) KLCPopup            *inputNamePopup;

@property(nonatomic,assign) CGFloat             lastScale;//photo上次缩放的值

@end

@implementation CreateStuffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%d",self.type);
    
    self.title = @"编辑";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"screen_background"]];
    //tabnavbar
//    UIBarButtonItem *rightButtonAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddTextBtnClick:)];
//    UIBarButtonItem *rightButtonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onFinishBtnClick:)];
//    self.navigationItem.rightBarButtonItems = @[rightButtonAdd,rightButtonDone];
    
    [self bottomToolbar];
    [self middleView];
    [self canvasView];
    [self.view bringSubviewToFront:_bottomToolbar];
    
    //初始化wordImageDictionary
    self.wordImageDictionary = [[NSMutableDictionary alloc] init];
    
    //判断type，如果是1和2，需要image；
    if(self.type != 0){
        [self photoImageView];
    }
    //初始lastScale为1.0；
    self.lastScale = 1.0f;
}

#pragma mark -getter
-(SimpleNavigationBarView *)navigationBarView{
    if(nil == _navigationBarView){
        _navigationBarView = [[SimpleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _navigationBarView.titleLabel.text = self.title;
        [_navigationBarView.backBtn setTarget:self action:@selector(onBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加 增加按钮
        _addTextBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 10*2 - 44*2, 20, 44, 44)];
        [_addTextBtn setTitle:@"+" forState:(UIControlStateNormal)];
        [_addTextBtn setTarget:self action:@selector(onAddTextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navigationBarView addSubview:_addTextBtn];
        _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 44, 20, 44, 44)];
        [_doneBtn setTitle:@"OK" forState:(UIControlStateNormal)];
        [_doneBtn setTarget:self action:@selector(onFinishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navigationBarView addSubview:_doneBtn];
        [self.view addSubview:_navigationBarView];
        
    }
    return _navigationBarView;
}

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
        _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom, kScreenWidth, self.bottomToolbar.top - 64)];
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
        //添加背景图片
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:_canvasView.bounds];
        backgroundImage.image = [UIImage imageNamed:@"create_stuff_background"];
        [_canvasView addSubview:backgroundImage];
//        UIImageView *seal = [[UIImageView alloc] initWithFrame:CGRectMake(10, _canvasView.bottom - 110, 100, 100)];
//        seal.image = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"sealimage"]];;
//        seal.contentMode = UIViewContentModeScaleAspectFit;
//        [_canvasView addSubview:seal];
    }
    return _canvasView;
}

-(UIImageView *)photoImageView{
    if(nil == _photoImageView){
        _photoImageView = [[UIImageView alloc] init];
        CGFloat photoWidth = self.photo.size.width;
        CGFloat photoHeight = self.photo.size.height;
        
        if(self.type == 1){
            // type ==1 图在上方
            // 把图放在canvas的上方居中。
            if(photoWidth > photoHeight){
                CGFloat newHeight = photoHeight * (self.canvasView.width - 10*2) / photoWidth;
                _photoImageView.frame = CGRectMake(10, 10, self.canvasView.width - 10*2, newHeight);
            } else {
                CGFloat newWidth =  photoWidth *(self.canvasView.width - 10*2)/photoHeight;
                _photoImageView.frame = CGRectMake((self.canvasView.width - newWidth)/2.0f, 10, newWidth, self.canvasView.width - 10*2);
            }
            _photoImageView.image = self.photo;
            [self.canvasView addSubview:_photoImageView];
            //允许用户拖动图片
            _photoImageView.userInteractionEnabled = YES;
            [_photoImageView enableDragging];
            //_photoImageView.cagingArea = self.canvasView.bounds;
            //允许用户缩放图片
            UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
            pinch.delegate = self;
            [_photoImageView addGestureRecognizer:pinch];
        } else {
            //type == 2,以图为背景
            if(photoWidth / photoHeight >= 0.75){
                CGFloat newHeight = photoHeight * self.canvasView.width / photoWidth;
                CGRect thisFrame = self.canvasView.frame;
                thisFrame.origin.y += (self.canvasView.height - newHeight)/2.0;
                thisFrame.size.height = newHeight;
                
                self.canvasView.frame = thisFrame;
                _photoImageView.frame = self.canvasView.bounds;
            } else {
                CGFloat newWidth =  photoWidth *self.canvasView.width /photoHeight;
                CGRect thisFrame = self.canvasView.frame;
                thisFrame.origin.x += (self.canvasView.width - newWidth)/2.0;
                thisFrame.size.width = newWidth;
                
                self.canvasView.frame = thisFrame;
                _photoImageView.frame = self.canvasView.bounds;
            }
            
            _photoImageView.image = self.photo;
            [self.canvasView addSubview:_photoImageView];
        }
    }
    return _photoImageView;
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
-(void)onBackBtnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
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

-(void)handlePinch:(UIPinchGestureRecognizer *)sender{
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        self.lastScale = 1.0;
        return;
    }
    
    CGFloat scale = 1.0 - (self.lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
    sender.view.transform = newTransform;
    
    self.lastScale = [(UIPinchGestureRecognizer*)sender scale];
    
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
    NSMutableArray *result = [[FMDBHelper sharedManager] queryModel:[NSString stringWithFormat:@"select * from zofont where name = '%@' order by createtime desc limit 1",nameStr]];
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
