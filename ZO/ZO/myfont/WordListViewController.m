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

@interface WordListViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) NSMutableDictionary         *datasource;
@property(nonatomic,strong) NSMutableArray              *dataOrderArray;//为了能顺序的获取dictionary的value；

@property(nonatomic,strong) UICollectionView            *collectionView;


@end

@implementation WordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    [self refreshDatasource];
    [self collectionView];
    
    NSLog(@"datasouce : %ld",[self.datasource count]);
    [self.datasource enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@:%ld",key,[obj count]);
    }];
}

#pragma mark - getter
-(UICollectionView *)collectionView{
    if(nil == _collectionView){
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
        fl.headerReferenceSize = CGSizeMake(self.view.width, 40);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:fl];
        _collectionView.backgroundColor = [UIColor whiteColor];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
