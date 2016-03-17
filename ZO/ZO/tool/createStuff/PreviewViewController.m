//
//  PreviewViewController.m
//  ZO
//
//  Created by JiFeng on 16/3/17.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "PreviewViewController.h"
#import "SaveSuccessViewController.h"

@interface PreviewViewController ()

@property(nonatomic,strong) UIImageView     *previewImageView;


@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览";
    
    //tabnavbar
    UIBarButtonItem *rightButtonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onSaveBtnClick:)];
    self.navigationItem.rightBarButtonItems = @[rightButtonDone];
    
    //previewImageView相关
    _previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _previewImageView.image = self.previewImage;
    _previewImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_previewImageView];
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
