//
//  SaveSuccessViewController.m
//  ZO
//
//  Created by JiFeng on 16/3/17.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "SaveSuccessViewController.h"

@interface SaveSuccessViewController ()

@property(nonatomic,strong) UIImageView     *resultImageView;

@end

@implementation SaveSuccessViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"保存成功";
    
    [self resultImageView];
}

-(UIImageView *)resultImageView{
    if(nil == _resultImageView){
        _resultImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 64, 100, 100)];
        _resultImageView.image = self.resultImage;
        _resultImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_resultImageView];
    }
    return _resultImageView;
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
