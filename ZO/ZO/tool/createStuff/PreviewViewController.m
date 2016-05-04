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

@interface PreviewViewController ()

@property(nonatomic,strong) SimpleNavigationBarView *navigationBarView;
@property(nonatomic,strong) UIImageView     *previewImageView;

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
    _previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom, kScreenWidth, kScreenHeight-self.navigationBarView.bottom)];
    _previewImageView.image = self.previewImage;
    _previewImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_previewImageView];
}
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
-(void)onSaveBtnClick:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIImageWriteToSavedPhotosAlbum(self.previewImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
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
