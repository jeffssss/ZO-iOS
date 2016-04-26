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
#import <MobileCoreServices/MobileCoreServices.h>
#import "ZONavigationBarView.h"

@interface ChooseTemplateViewController ()<iCarouselDataSource, iCarouselDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) ZONavigationBarView *navigationBarView;

@property(nonatomic,strong) iCarousel       *carousel;

@property(nonatomic,strong) NSArray         *coverImageArray;

@property(nonatomic,strong) UIPageControl   *pageControl;

@property(nonatomic,strong) UIButton        *chooseBtn;

@end

@implementation ChooseTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择模板";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"screen_background"]];
    [self carousel];
    // Do any additional setup after loading the view.
    [self pageControl];
    [self chooseBtn];
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

-(iCarousel *)carousel{
    if(nil == _carousel){
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom, kScreenWidth, kScreenHeight - self.navigationBarView.bottom - 110)];
//        _carousel.backgroundColor = UIColorHex(0x4F4F4F);
        _carousel.backgroundColor = [UIColor clearColor];
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
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.carousel.width - 100)/2.0, self.carousel.bottom + 5, 100, 30)];
        _pageControl.numberOfPages = self.coverImageArray.count;
        _pageControl.currentPage = 0;
        [self.view addSubview:_pageControl];
    }
    return _pageControl;
}
-(UIButton *)chooseBtn{
    if(nil == _chooseBtn){
        _chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.carousel.width - 150)/2.0, self.pageControl.bottom + 5, 150, 30)];
        _chooseBtn.titleLabel.font = [UIFont fontWithName:@"-" size:25];
        _chooseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _chooseBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _chooseBtn.layer.borderWidth = 2.0;
        _chooseBtn.layer.cornerRadius = _chooseBtn.height/2.0;
        [_chooseBtn setTitle:@"就选它了" forState:UIControlStateNormal];
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
        view.layer.shouldRasterize = YES;//防止锯齿
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
    [self onChooseBtnClick:nil];
}
#pragma UIImagePickerControllerDelegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
//    NSMutableDictionary * dict= [NSMutableDictionary dictionaryWithDictionary:editingInfo];
//    
//    [dict setObject:image forKey:@"UIImagePickerControllerEditedImage"];
//    
//    //直接调用处理函数
//    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
//}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        UIImage *theImage = nil;
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            
        }
        //跳转到新页面
        CreateStuffViewController *createVC = [[CreateStuffViewController alloc] init];
        createVC.type = (int)self.carousel.currentItemIndex;
        createVC.photo = theImage;
        [self.navigationController pushViewController:createVC animated:YES];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - SEL
-(void)onBackBtnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onChooseBtnClick:(id)sender{
    int type = (int)self.carousel.currentItemIndex;
    
    if (type == 0) {
        //纯文字type
        CreateStuffViewController *createVC = [[CreateStuffViewController alloc] init];
        createVC.type = type;
        [self.navigationController pushViewController:createVC animated:YES];
    } else {
        //需要先选择照片
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.allowsEditing = NO;
            imagePicker.delegate = self;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:( NSString *)kUTTypeImage];
            [imagePicker setMediaTypes:mediaTypes];
            dispatch_async_on_main_queue(^{
                [self presentViewController: imagePicker animated: YES completion:^{
                    //关菊花
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
            });
        });
        
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
