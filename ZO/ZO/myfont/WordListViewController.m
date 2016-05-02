//
//  WordListViewController.m
//  ZO
//
//  Created by JiFeng on 16/3/10.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "WordListViewController.h"
#import "ZOFontModel.h"
#import "FMDBHelper.h"
#import "SingleWordCollectionViewCell.h"
#import "ZONavigationBarView.h"

@interface WordListViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) ZONavigationBarView         *navigationBarView;

@property(nonatomic,strong) UILabel                     *progressLabel;

@property(nonatomic,strong) NSMutableDictionary         *datasource;
@property(nonatomic,strong) NSMutableArray              *dataOrderArray;//为了能顺序的获取dictionary的value；

@property(nonatomic,strong) UICollectionView            *collectionView;


@end

@implementation WordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.type) {
        case 1:
            self.title = @"一级汉字";
            break;
        case 2:
            self.title = @"二级汉字";
            break;
        default:
            self.title = @"其他字符";
            break;
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"screen_background"]];
    
    // Do any additional setup after loading the view.
    [self refreshDatasource];
    [self collectionView];
    
    NSLog(@"datasouce : %ld",[self.datasource count]);
    [self.datasource enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@:%ld",key,[obj count]);
    }];
}

#pragma mark - getter
-(ZONavigationBarView *)navigationBarView{
    if(nil == _navigationBarView){
        _navigationBarView = [[ZONavigationBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 100)];
        _navigationBarView.titleLabel.text = self.title;
        [_navigationBarView.backBtn setTarget:self action:@selector(onBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_navigationBarView];
        
    }
    return _navigationBarView;
}

-(UILabel *)progressLabel{
    if(nil == _progressLabel){
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 251)/2.0, self.navigationBarView.bottom, 251, 40)];
        _progressLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scroll"]];
        _progressLabel.font = [UIFont fontWithName:@"-" size:20];
        _progressLabel.text = [self getProgressDescription];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_progressLabel];
    }
    return _progressLabel;
}
-(UICollectionView *)collectionView{
    if(nil == _collectionView){
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
        fl.headerReferenceSize = CGSizeMake(self.view.width, 40);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.progressLabel.bottom, kScreenWidth, kScreenHeight - self.progressLabel.bottom) collectionViewLayout:fl];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[SingleWordCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"COLLECTIONVIEW_HEADER"];
        [_collectionView registerClass:[SingleWordCollectionViewCell class] forCellWithReuseIdentifier:@"COLLECTIONVIEW_SINGLEWORD"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[self.datasource objectForKey:self.dataOrderArray[section]] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SingleWordCollectionViewCell *mycell = [collectionView dequeueReusableCellWithReuseIdentifier:@"COLLECTIONVIEW_SINGLEWORD" forIndexPath:indexPath];
    [mycell loadData:[self.datasource objectForKey:self.dataOrderArray[indexPath.section]][indexPath.row]];
    return mycell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.datasource.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    SingleWordCollectionViewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"COLLECTIONVIEW_HEADER" forIndexPath:indexPath];
    [headerView loadData:self.dataOrderArray[indexPath.section]];
    return headerView;
}

#pragma mark - UICollectionViewDelegateFlowLayout 
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(60, 60);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

#pragma mark - private
-(void)refreshDatasource{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //获取type的所有记录
    NSMutableArray *dataArray = [[FMDBHelper sharedManager] queryModel:[NSString stringWithFormat:@"select * from zofont where type = %d order by createtime desc",self.type]];
    //分类，组成dictionary
    for(ZOFontModel *model in dataArray){
        NSMutableArray *thisArray = [dict objectForKey:model.name];
        if(!thisArray){
            thisArray = [[NSMutableArray alloc] init];
            [dict setObject:thisArray forKey:model.name];
            [array addObject:model.name];
        }
        [thisArray addObject:model];//TODO:需要检查是否加进去了
    }
    self.datasource = dict;
    self.dataOrderArray = array;
}

-(NSString *)getProgressDescription{
    NSString *query = [NSString stringWithFormat:@"select COUNT(*) as 'count' from zofont where type = %d group by type",self.type];
    switch (self.type) {
        case 1:{
            NSMutableArray *result = [[FMDBHelper sharedManager] query:query];
            return [NSString stringWithFormat:@"完成进度 (%@/3755)",result[0][@"count"]];
            break;
        }
        case 2:{
            NSMutableArray *result = [[FMDBHelper sharedManager] query:query];
            return [NSString stringWithFormat:@"完成进度 (%@/3008)",result[0][@"count"]];
            break;
        }
        case 3:{
            NSMutableArray *result = [[FMDBHelper sharedManager] query:query];
            return [NSString stringWithFormat:@"完成进度 (共%@个)",result[0][@"count"]];
            break;
        }
        default:{
            return @"完成进度未知";
            break;
        }
    }
}

-(void)onBackBtnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
