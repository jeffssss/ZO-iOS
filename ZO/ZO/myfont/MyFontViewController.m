//
//  MyFontViewController.m
//  ZO
//
//  Created by JiFeng on 16/3/5.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "MyFontViewController.h"
#import "FMDBHelper.h"
#import "InputNameView.h"
#import "WriteWordViewController.h"
#import "SingleWordViewController.h"
#import "WordListViewController.h"
#import "ZONavigationBarView.h"
#import "WordWithTZGView.h"

@interface MyFontViewController ()<InputNameDelegate,UITextFieldDelegate>

@property(nonatomic,strong) ZONavigationBarView *navigationBarView;

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
    self.title = @"我的字库";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"screen_background"]];
    //获取数据源
    [self initLayout];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshDatasourceArray];
    [self refreshlayout];
}

#pragma mark - getter
-(ZONavigationBarView *)navigationBarView{
    if(nil == _navigationBarView){
        _navigationBarView = [[ZONavigationBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 120)];
        _navigationBarView.titleLabel.text = self.title;
        [_navigationBarView.backBtn setTarget:self action:@selector(onBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_navigationBarView];
        
    }
    return _navigationBarView;
}

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
        [self.datasourceArray addObject:[[FMDBHelper sharedManager] queryModel:[NSString stringWithFormat:@"select * from zofont where type = %d order by createtime desc limit 5",i]]];
    }
    //TEST:
    NSLog(@"Datasource:\nType=1数据有%lu,Type=2数据有%lu,Type=3数据有%lu",(unsigned long)[self.datasourceArray[0] count],(unsigned long)[self.datasourceArray[1] count],(unsigned long)[self.datasourceArray[2] count]);
}

-(void)initLayout{
    self.firstClassWordTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom, kScreenWidth, 40)];
    [self.firstClassWordTitleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        WordListViewController *wordlistVC = [[WordListViewController alloc] init];
        wordlistVC.type = 1;
        [self.navigationController pushViewController:wordlistVC animated:YES];
    }]];
    [self.view addSubview:self.firstClassWordTitleView];
    self.firstClassCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 251, self.firstClassWordTitleView.height)];
    self.firstClassCountLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scroll"]];
    self.firstClassCountLabel.font = [UIFont fontWithName:@"-" size:20];
    self.firstClassCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.firstClassWordTitleView addSubview:self.firstClassCountLabel];
    self.firstClassContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.firstClassWordTitleView.bottom, self.firstClassWordTitleView.width, 60)];
    [self.view addSubview:self.firstClassContentView];
    
    self.secondClassWordTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.firstClassContentView.bottom, kScreenWidth, 40)];
    [self.view addSubview:self.secondClassWordTitleView];
    self.secondClassCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.firstClassCountLabel.width, self.secondClassWordTitleView.height)];
    self.secondClassCountLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scroll"]];
    self.secondClassCountLabel.font = [UIFont fontWithName:@"-" size:20];
    self.secondClassCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.secondClassWordTitleView addSubview:self.secondClassCountLabel];
    self.secondClassContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.secondClassWordTitleView.bottom, self.secondClassWordTitleView.width, 60)];
    [self.view addSubview:self.secondClassContentView];
    
    //TODO:暂时省略其他类，也暂时把文字只放到一个UILabel里。
    
    [self writeWordBtn];
    
}

-(void)refreshlayout{

    NSMutableDictionary *dict = [self getFontCountGroupCount];
    self.firstClassCountLabel.text = [NSString stringWithFormat:@"一级汉字（%@/3755）",dict[@"1"]] ;//TODO:这个数字需要查数据库
    self.secondClassCountLabel.text = [NSString stringWithFormat:@"二级汉字（%@/3008）",dict[@"2"]];
    //其他类别的暂时没做UI
    
    //先清空subviews
    [self.firstClassContentView removeAllSubviews];
    [self.secondClassContentView removeAllSubviews];
    //一级
    if([self.datasourceArray[0] count] > 0 ){
        for(int i = 0 ; i < [self.datasourceArray[0] count] ; i++){
            if(i>3){
                break;
            }
            //显示图片
            ZOFontModel *model = self.datasourceArray[0][i];
            WordWithTZGView *imageview = [[WordWithTZGView alloc] initWithFrame:CGRectMake(10 + 60*i, 5, 50, 50) andWordImage:[ZOPNGManager imageWithFilename:model.filename]];
            NSLog(@"path = %@",[(ZOFontModel*)self.datasourceArray[0][i] filename]);
            [self.firstClassContentView addSubview:imageview];
            
            //点击图片跳转
            imageview.userInteractionEnabled = YES;
            [imageview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                SingleWordViewController *singleVC = [[SingleWordViewController alloc] init];
                singleVC.model = model;
                [self.navigationController pushViewController:singleVC animated:YES];
            }]];
        }
    } else {
        //显示无记录
        UILabel *noresultLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 200, 50)];
        noresultLabel.text = @"没有记录，快去写字吧~";
        noresultLabel.font = [UIFont fontWithName:@"-" size:20];
        [self.firstClassContentView addSubview:noresultLabel];
    }
    //二级
    if([self.datasourceArray[1] count] > 0 ){
        for(int i = 0 ; i < [self.datasourceArray[1] count] ; i++){
            if(i>3){
                break;
            }
            //显示图片
            ZOFontModel *model = self.datasourceArray[1][i];
            WordWithTZGView *imageview = [[WordWithTZGView alloc] initWithFrame:CGRectMake(10 + 60*i, 5, 50, 50) andWordImage:[ZOPNGManager imageWithFilename:model.filename]];
            [self.secondClassContentView addSubview:imageview];
            //点击图片跳转
            imageview.userInteractionEnabled = YES;
            [imageview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                SingleWordViewController *singleVC = [[SingleWordViewController alloc] init];
                singleVC.model = model;
                [self.navigationController pushViewController:singleVC animated:YES];
            }]];
        }
    } else {
        //TODO:本来应该显示无的，现在先不写
        UILabel *noresultLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 200, 50)];
        noresultLabel.text = @"没有记录，快去写字吧~";
        noresultLabel.font = [UIFont fontWithName:@"-" size:20];
        [self.secondClassContentView addSubview:noresultLabel];
    }
}

#pragma mark - SEL
-(void)onBackBtnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

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

#pragma mark - private
//查询数据库中一级汉字和二级汉字的个数
-(NSMutableDictionary *)getFontCountGroupCount{
    NSMutableDictionary *countDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    NSString *query = [NSString stringWithFormat:@"select type,COUNT(*) as 'count' from zofont group by type"];
    NSMutableArray *result = [[FMDBHelper sharedManager] query:query];
    
    for(NSMutableDictionary *dict in result){
        [countDict setObject:[NSString stringWithFormat:@"%@",dict[@"count"]] forKey:[NSString stringWithFormat:@"%@",dict[@"type"]]];
    }
    
    //检查内容，key为1，2，3.如果缺少 则补0
    for(int i = 1; i < 4; i++){
        if(![countDict objectForKey:[NSString stringWithFormat:@"%d",i]]){
            [countDict setObject:@"0" forKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return countDict;
}

@end
