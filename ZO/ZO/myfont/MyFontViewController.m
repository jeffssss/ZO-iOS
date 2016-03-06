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

@interface MyFontViewController ()

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
    [[FMDBHelper sharedManager] exec:@"delete from zofont"];
    
}

#pragma mark - private 
-(NSMutableArray *)queryDatasourceArray{
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
