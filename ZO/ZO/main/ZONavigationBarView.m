//
//  ZONavigationBarView.m
//  ZO
//
//  Created by JiFeng on 16/4/20.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "ZONavigationBarView.h"

@interface ZONavigationBarView ()

@end

@implementation ZONavigationBarView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, frame.size.height-5*2, frame.size.height-5*2)];
        [_backBtn setImage:[UIImage imageNamed:@"zo"] forState:UIControlStateNormal];
        [self addSubview:_backBtn];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backBtn.right + 5, 0, frame.size.width - _backBtn.right - 5, frame.size.height)];
        _titleLabel.font = [UIFont fontWithName:@"-" size:45];
        _titleLabel.textColor = [UIColor blackColor];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return self;
}

@end
