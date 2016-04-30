//
//  WordWithTZGView.m
//  ZO
//
//  Created by JiFeng on 16/4/30.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "WordWithTZGView.h"

@interface WordWithTZGView ()

@property(nonatomic,strong) UIImageView *tianzigeImageView;

@property(nonatomic,strong) UIImageView *wordImageView;

@end

@implementation WordWithTZGView

-(instancetype)initWithFrame:(CGRect)frame andWordImage:(UIImage *)wordImage{
    if(self = [super initWithFrame:frame]){
        //init tianzige
        self.tianzigeImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.tianzigeImageView.image = [UIImage imageNamed:@"tianzige"];
        [self addSubview:self.tianzigeImageView];
        
        //init wordimage
        self.wordImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.wordImageView.image = wordImage;
        [self addSubview:self.wordImageView];
    }
    return self;
}

@end
