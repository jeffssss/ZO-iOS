//
//  SimpleNavigationBarView.m
//  ZO
//
//  Created by JiFeng on 16/5/1.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "SimpleNavigationBarView.h"

@interface SimpleNavigationBarView ()

@end

@implementation SimpleNavigationBarView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        //NavigationBar需要包含状态栏的那一部分，所以y坐标要加20
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20 + 5, frame.size.height-5*2 - 20 , frame.size.height-5*2 -20)];
        [_backBtn setImage:[UIImage imageNamed:@"back_arrow_white"] forState:UIControlStateNormal];
//        [_backBtn setImage:[UIImage imageNamed:@"zo"] forState:UIControlStateDisabled];
//        [_backBtn setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
        [self addSubview:_backBtn];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width - 200)/2.0, 20, 200, frame.size.height -20)];
        _titleLabel.font = [UIFont fontWithName:@"-" size:30];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return self;
}

@end
