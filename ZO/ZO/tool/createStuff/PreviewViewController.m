//
//  PreviewViewController.m
//  ZO
//
//  Created by JiFeng on 16/3/17.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "PreviewViewController.h"
#import "SaveSuccessViewController.h"
#import "SimpleNavigationBarView.h"
#import "UIImage+sizeChange.h"
#import <UIView+draggable/UIView+draggable.h>
@interface PreviewViewController ()

@property(nonatomic,strong) SimpleNavigationBarView *navigationBarView;
@property(nonatomic,strong) UIImageView     *previewImageView;
@property(nonatomic,strong) UIButton        *addSealBtn;
@property(nonatomic,strong) UIImage         *sealBtnImage;
@property(nonatomic,strong) UIImageView     *sealImageView;
@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"screen_background"]];
    //tabnavbar
    UIBarButtonItem *rightButtonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onSaveBtnClick:)];
    self.navigationItem.rightBarButtonItems = @[rightButtonDone];
    
    //previewImageView相关
    [self navigationBarView];
    [self previewImageView];
    [self addSealBtn];

}
#pragma mark - getter
-(SimpleNavigationBarView *)navigationBarView{
    if(nil == _navigationBarView){
        _navigationBarView = [[SimpleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _navigationBarView.titleLabel.text = self.title;
        [_navigationBarView.backBtn setTarget:self action:@selector(onBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //保存按钮
        UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 44, 20, 44, 44)];
        [saveBtn setTitle:@"Save" forState:(UIControlStateNormal)];
        [saveBtn setTarget:self action:@selector(onSaveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navigationBarView addSubview:saveBtn];
        [self.view addSubview:_navigationBarView];
        
    }
    return _navigationBarView;
}
-(UIImageView *)previewImageView{
    if(nil == _previewImageView){
        _previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.navigationBarView.bottom + 15 , kScreenWidth - 15*2, (kScreenWidth - 15*2) * 4 / 3.0)];
        _previewImageView.image = self.previewImage;
        _previewImageView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:_previewImageView];
    }
    return _previewImageView;
}
-(UIButton *)addSealBtn{
    if(nil == _addSealBtn){
        _addSealBtn = [[UIButton alloc] initWithFrame:CGRectMake( (kScreenWidth - 50)/2.0, kScreenHeight - 50 - 20, 50, 50)];
        _addSealBtn.layer.cornerRadius = _addSealBtn.width/2.0;
        _addSealBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        [_addSealBtn setImage: self.sealBtnImage forState:UIControlStateNormal];
        [_addSealBtn setTarget:self action:@selector(onAddSealBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addSealBtn];
    }
    return _addSealBtn;
}
-(UIImage *)sealBtnImage{
    if(nil == _sealBtnImage){
        UIImage *image = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"sealimage"]];
        //计算缩小比例
        CGFloat multi = (35.0/image.size.width) > (35.0/image.size.height) ? (35.0/image.size.height):(35.0/image.size.width);
        _sealBtnImage = [image changeSizeWithMulti:multi];
    }
    return _sealBtnImage;
}
-(UIImageView *)sealImageView{
    if(nil == _sealImageView){
        UIImage *image = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"sealimage"]];
        _sealImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.previewImageView.height - 20-50, 50, 50)];
        _sealImageView.contentMode = UIViewContentModeScaleAspectFit;
        _sealImageView.image = image;
        _sealImageView.userInteractionEnabled = YES;
        [_sealImageView enableDragging];
        [_sealImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
            NSLog(@"seal tapped!!!");
        }]];
        
    }
    return _sealImageView;
}


-(void)onSaveBtnClick:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIImageWriteToSavedPhotosAlbum([self.previewImageView snapshotImage], self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //回到主线程操作UI
    dispatch_async_on_main_queue(^{
        //收起菊花
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //跳转到图片。
        if (!error) {
            NSLog(@"保存成功");
            SaveSuccessViewController *saveSuccessVC = [[SaveSuccessViewController alloc] init];
            saveSuccessVC.resultImage = image;
            [self.navigationController pushViewController:saveSuccessVC animated:YES];
            
        }else
        {
            NSLog(@"保存失败，原因：%@",[error description]);
        }
        
    });
    
    
    
}
#pragma mark - SEL
-(void)onAddSealBtnClick{
    [self.previewImageView addSubview:self.sealImageView];
    [self.addSealBtn setImage:[UIImage imageNamed:@"disable_icon"] forState:UIControlStateNormal];
    [self.addSealBtn setTarget:self action:@selector(onRemoveSealBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)onRemoveSealBtnClick{
    [self.sealImageView removeFromSuperview];
    [self.addSealBtn setImage:self.sealBtnImage forState:UIControlStateNormal];
    [self.addSealBtn setTarget:self action:@selector(onAddSealBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)onBackBtnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
