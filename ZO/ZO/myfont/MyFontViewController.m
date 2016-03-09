//
//  MyFontViewController.m
//  ZO
//
//  Created by JiFeng on 16/3/5.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "MyFontViewController.h"
#import "FontThumbnailView.h"
#import "FMDBHelper.h"
#import "ZOPNGManager.h"
#import "InputNameView.h"
#import "WriteWordViewController.h"

@interface MyFontViewController ()<InputNameDelegate,UITextFieldDelegate>

@property(nonatomic,strong) UIImageView *backgroundImageView;

@property(nonatomic,strong) UIView      *firstClassWordTitleView;
@property(nonatomic,strong) UILabel     *firstClassCountLabel;
@property(nonatomic,strong) UIView      *firstClassContentView;

@property(nonatomic,strong) UIView      *secondClassWordTitleView;
@property(nonatomic,strong) UILabel     *secondClassCountLabel;
@property(nonatomic,strong) UIView      *secondClassContentView;

@property(nonatomic,strong) UIView      *otherWordTitleView;
@property(nonatomic,strong) UILabel     *otherCountLabel;
@property(nonatomic,strong) UIView      *otherContentView;

@property(nonatomic,strong) NSMutableArray  *datasourceArray;//二维数组

@property(nonatomic,strong) UIButton    *writeWordBtn;

@property(nonatomic,strong) KLCPopup    *inputNamePopup;

@end

@implementation MyFontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"字体养成";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    FontThumbnailView *thisView = [[FontThumbnailView alloc] initWithFrame:CGRectMake(0, 70, 50, 50)];
//    thisView.wordNameString = @"哦";
//    thisView.backgroundColor = [UIColor redColor];
    
//    [self.view addSubview:thisView];
    //获取数据源
    
    
    [self initLayout];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshDatasourceArray];
    [self refreshlayout];
}

#pragma mark - getter
-(UIButton *)writeWordBtn{
    if(nil == _writeWordBtn){
        _writeWordBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.secondClassContentView.bottom +120, kScreenWidth, 30)];
        [_writeWordBtn setTitle:@"写字" forState:UIControlStateNormal];
        [_writeWordBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_writeWordBtn setTarget:self action:@selector(onWriteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_writeWordBtn];
    }
    return _writeWordBtn;
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


#pragma mark - private 
-(void)refreshDatasourceArray{
    self.datasourceArray = [[NSMutableArray alloc] init];
    for(int i = 1 ; i < 4 ; i ++){
        [self.datasourceArray addObject:[[FMDBHelper sharedManager] query:[NSString stringWithFormat:@"select * from zofont where type = %d order by createtime desc",i]]];//TODO:未测试;不知道能不能倒序查询正确
    }
    //TEST:
    NSLog(@"Datasource:\nType=1数据有%lu,Type=2数据有%lu,Type=3数据有%lu",(unsigned long)[self.datasourceArray[0] count],(unsigned long)[self.datasourceArray[1] count],(unsigned long)[self.datasourceArray[2] count]);
}

-(void)initLayout{
    self.firstClassWordTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, 40)];
    [self.view addSubview:self.firstClassWordTitleView];
    self.firstClassCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.firstClassWordTitleView.width, self.firstClassWordTitleView.height)];
    [self.firstClassWordTitleView addSubview:self.firstClassCountLabel];
    self.firstClassContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.firstClassWordTitleView.bottom, self.firstClassWordTitleView.width, 60)];
    [self.view addSubview:self.firstClassContentView];
    
    self.secondClassWordTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.firstClassContentView.bottom, kScreenWidth, 40)];
    [self.view addSubview:self.secondClassWordTitleView];
    self.secondClassCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.secondClassWordTitleView.width, self.secondClassWordTitleView.height)];
    [self.secondClassWordTitleView addSubview:self.secondClassCountLabel];
    self.secondClassContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.secondClassWordTitleView.bottom, self.secondClassWordTitleView.width, 60)];
    [self.view addSubview:self.secondClassContentView];
    
    //TODO:暂时省略其他类，也暂时把文字只放到一个UILabel里。
    
    [self writeWordBtn];
    
}

-(void)refreshlayout{

    self.firstClassCountLabel.text = @"一级汉字（0/3577）";//TODO:这个数字需要查数据库
    self.secondClassCountLabel.text = @"二级汉字（0/3577）";
    //一级
    if([self.datasourceArray[0] count] > 0 ){
        for(int i = 0 ; i < [self.datasourceArray[0] count] ; i++){
            if(i>3){
                break;
            }
            //显示图片
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 60*i, 5, 50, 50)];
            imageview.backgroundColor = [UIColor redColor];
            imageview.image = [ZOPNGManager imageWithFilepath:[(ZOFontModel*)self.datasourceArray[0][i] filename] ];
            NSLog(@"path = %@",[(ZOFontModel*)self.datasourceArray[0][i] filename]);
            [self.firstClassContentView addSubview:imageview];
        }
    } else {
        //TODO:本来应该显示无的，现在先不写
    }
    //二级
    if([self.datasourceArray[1] count] > 0 ){
        for(int i = 0 ; i < [self.datasourceArray[1] count] ; i++){
            if(i>3){
                break;
            }
            //显示图片
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 60*i, 5, 50, 50)];
            imageview.image = [ZOPNGManager imageWithFilepath:[(ZOFontModel*)self.datasourceArray[1][i] filename] ];
            [self.secondClassContentView addSubview:imageview];
        }
    } else {
        //TODO:本来应该显示无的，现在先不写
    }
}

#pragma mark - SEL
-(void)onWriteBtnClick:(id)sender{
    [self.inputNamePopup show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - InputNameDelegate
-(void)onInputNameOKBtnClick:(NSString *)nameStr{
    if([nameStr length]!=1){
        return;
    }
    WriteWordViewController *writeVC = [[WriteWordViewController alloc] init];
    [self.navigationController pushViewController:writeVC animated:YES];
    writeVC.nameString = nameStr;
    [self.inputNamePopup dismiss:NO];
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

@end
