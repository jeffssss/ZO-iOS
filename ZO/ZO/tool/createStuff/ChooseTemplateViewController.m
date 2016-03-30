//
//  ChooseTemplateViewController.m
//  ZO
//
//  Created by JiFeng on 16/3/11.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "ChooseTemplateViewController.h"
#import <iCarousel/iCarousel.h>
#import "CreateStuffViewController.h"

@interface ChooseTemplateViewController ()<iCarouselDataSource, iCarouselDelegate>

@property(nonatomic,strong) iCarousel       *carousel;

@property(nonatomic,strong) NSArray         *coverImageArray;

@property(nonatomic,strong) UIPageControl   *pageControl;

@property(nonatomic,strong) UIButton        *chooseBtn;

@end

@implementation ChooseTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择模板";
    self.view.backgroundColor = [UIColor whiteColor];
    [self carousel];
    // Do any additional setup after loading the view.
    [self pageControl];
    [self chooseBtn];
}

#pragma mark - getter
-(iCarousel *)carousel{
    if(nil == _carousel){
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 80)];
        _carousel.backgroundColor = [UIColor yellowColor];
        _carousel.type = iCarouselTypeCylinder;
        _carousel.vertical = NO;
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.scrollSpeed = 0.3;
        [self.view addSubview:_carousel];
    }
    return _carousel;
}
-(NSArray *)coverImageArray{
    if(nil == _coverImageArray){
        _coverImageArray = @[@"pure_text",@"image_top",@"text_in_image"];
    }
    return _coverImageArray;
}
-(UIPageControl *)pageControl{
    if(nil == _pageControl){
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.carousel.width - 100)/2.0, self.carousel.height - 50, 100, 30)];
        _pageControl.numberOfPages = self.coverImageArray.count;
        _pageControl.currentPage = 0;
        [self.carousel addSubview:_pageControl];
    }
    return _pageControl;
}
-(UIButton *)chooseBtn{
    if(nil == _chooseBtn){
        _chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.carousel.width - 150)/2.0, self.carousel.bottom, 150, 60)];
        [_chooseBtn setTitle:@"就选它了" forState:UIControlStateNormal];
        [_chooseBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_chooseBtn setTarget:self action:@selector(onChooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_chooseBtn];
    }
    return _chooseBtn;
}
#pragma mark - iCarouseDelegate & datasource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 3;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 300.0f)];
        //view.contentMode = UIViewContentModeBottom;
    }
    [(UIImageView*)view setImage:[UIImage imageNamed:self.coverImageArray[index]]] ;
    return view;
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    self.pageControl.currentPage = carousel.currentItemIndex;
}
- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.0f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    CreateStuffViewController *createVC = [[CreateStuffViewController alloc] init];
    createVC.type = (int)index;
    [self.navigationController pushViewController:createVC animated:YES];
}
#pragma mark - SEL
-(void)onChooseBtnClick:(id)sender{
    CreateStuffViewController *createVC = [[CreateStuffViewController alloc] init];
    createVC.type = (int)self.carousel.currentItemIndex;
    [self.navigationController pushViewController:createVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
