//
//  SaveSuccessViewController.m
//  ZO
//
//  Created by JiFeng on 16/3/17.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "SaveSuccessViewController.h"
#import "SimpleNavigationBarView.h"
#import "UMSocialSnsService.h"
#import "UMSocial.h"

@interface SaveSuccessViewController ()<UMSocialUIDelegate>

@property(nonatomic,strong) SimpleNavigationBarView *navigationBarView;
@property(nonatomic,strong) UIImageView     *resultImageView;
@property(nonatomic,strong) UIView          *shareView;
@end

@implementation SaveSuccessViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"保存成功";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"screen_background"]];
    [self resultImageView];
    [self shareView];
}

#pragma mark - getter
-(SimpleNavigationBarView *)navigationBarView{
    if(nil == _navigationBarView){
        _navigationBarView = [[SimpleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _navigationBarView.titleLabel.text = self.title;
        [_navigationBarView.backBtn setTarget:self action:@selector(onBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_navigationBarView];
        
    }
    return _navigationBarView;
}
-(UIImageView *)resultImageView{
    if(nil == _resultImageView){
        _resultImageView = [[UIImageView alloc] initWithFrame: CGRectMake(kScreenWidth /6, self.navigationBarView.bottom + 20, kScreenWidth *2/3, kScreenWidth *2/3)];
        _resultImageView.image = self.resultImage;
        _resultImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_resultImageView];
    }
    return _resultImageView;
}
-(UIView *)shareView{
    if(nil == _shareView){
        _shareView = [[UIView alloc] initWithFrame:CGRectMake(20, self.resultImageView.bottom + 20, self.resultImageView.width, 200)];
        [self.view addSubview:_shareView];
        
        UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _shareView.width, 20)];
        shareLabel.text = @"分享:";
        shareLabel.font = [UIFont fontWithName:@"-" size:18.0];
        [_shareView addSubview:shareLabel];
        
        //sina
        UIButton *sinaBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, shareLabel.bottom+5, 40, 40)];
        [sinaBtn setImage:[UIImage imageNamed:@"sina_icon"] forState:(UIControlStateNormal)];
        [sinaBtn setTarget:self action:@selector(onSinaShareBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_shareView addSubview:sinaBtn];
        //wechat
        UIButton *wechatBtn = [[UIButton alloc] initWithFrame:CGRectMake(sinaBtn.right + 10, shareLabel.bottom+5, 40, 40)];
        [wechatBtn setImage:[UIImage imageNamed:@"wechat_icon"] forState:(UIControlStateNormal)];
        [wechatBtn setTarget:self action:@selector(onWechatBtnShareBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_shareView addSubview:wechatBtn];
        //qq
        UIButton *qqBtn = [[UIButton alloc] initWithFrame:CGRectMake(wechatBtn.right + 10, shareLabel.bottom+5, 40, 40)];
        [qqBtn setImage:[UIImage imageNamed:@"qq_icon"] forState:(UIControlStateNormal)];
        [qqBtn setTarget:self action:@selector(onQQShareBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_shareView addSubview:qqBtn];
    }
    return _shareView;
}

#pragma mark - SEL
-(void)onBackBtnClick:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)onSinaShareBtnClick{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"572aa335e0f55a323a001866"
                                      shareText:@"字哦，写你所写"
                                     shareImage:self.resultImage
                                shareToSnsNames:@[UMShareToSina]
                                       delegate:self];
}
-(void)onWechatBtnShareBtnClick{
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"572aa335e0f55a323a001866"
                                      shareText:nil
                                     shareImage:self.resultImage
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite]
                                       delegate:self];

}
-(void)onQQShareBtnClick{
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"572aa335e0f55a323a001866"
                                      shareText:@"字哦，写你所写"
                                     shareImage:self.resultImage
                                shareToSnsNames:@[UMShareToQQ,UMShareToQzone]
                                       delegate:self];
}

#pragma mark - delegate
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
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
