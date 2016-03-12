//
//  CreateStuffToolbar.m
//  ZO
//
//  Created by JiFeng on 16/3/12.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "CreateStuffToolbar.h"

@interface CreateStuffToolbar ()

@property(nonatomic,strong) UIView          *firstView;//第一级view，基础选项
@property(nonatomic,strong) NSMutableArray  *firstBtnArray;

@property(nonatomic,strong) UIView          *secondView;//第二级View，放拓展选项

@property(nonatomic,assign) BOOL            isSecondShown;//状态量，判断第二级是否出现

@property(nonatomic,strong) UITableView     *secondContentTableView;//第二级的content为一个tableview

@end

@implementation CreateStuffToolbar

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        [self firstView];
        [self firstBtnArray];
        [self secondView];
        self.isSecondShown = NO;
    }
    return self;
}

#pragma mark - getter
-(UIView *)firstView{
    if(nil == _firstView){
        if(self.isSecondShown){
            _firstView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-70, self.width, 70)];
        } else {
            _firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        }
        _firstView.backgroundColor = UIColorHex(0x656565);
        [self addSubview:_firstView];
    }
    return _firstView;
}

-(NSMutableArray *)firstBtnArray{
    if(nil == _firstBtnArray){
        _firstBtnArray = [[NSMutableArray alloc] init];
        NSArray *btnNameArray = @[@"字形",@"颜色",@"大小",@"删除",@"↓"];
        for (int i = 0; i < btnNameArray.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20 + 50*i, 10, 50, 50)];
            [button setTitle:btnNameArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.tag = 1000+i;//1000是基数，为了避免小值tag出问题
            [button setTarget:self action:@selector(onFirstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            //如果shown是NO的话，不需要↓可见;
            if(i == (btnNameArray.count - 1)){
                button.hidden = !self.isSecondShown;
            }
            
            [self.firstView addSubview:button];
            [_firstBtnArray addObject:button];
        }
    }
    return _firstBtnArray;
}

-(UIView *)secondView{
    if(nil == _secondView){
        _secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 70)];
        _secondView.backgroundColor = UIColorHex(0x989898);
        _secondView.hidden = !self.isSecondShown;
        [self addSubview:_secondView];
    }
    return _secondView;
}

-(void)onFirstBtnClick:(UIButton *)sender{
    NSInteger tag = sender.tag - 1000;

    switch (tag) {
        case 0:
            //点击 选择字形
            [self changeSecondView:YES];
            break;
        case 1:
            //点击 改变颜色
            [self changeSecondView:YES];
            break;
        case 2:
            //点击 改变大小
            [self changeSecondView:YES];
            break;
        case 3:
            //点击 删除
            break;
        case 4:
            //点击 缩回secondView
            [self changeSecondView:NO];
            break;
        default:
            break;
    }
}

-(void)changeSecondView:(BOOL)willShown{
    //改变self的frame
    //firstView的frame也要改变
    CGRect frame = self.frame;
    CGRect firstFrame = self.firstView.frame;
    if(willShown){
        //需要将要show并且现在没有show才改变frame
        if(!self.isSecondShown){
            frame.origin.y -=70;
            frame.size.height +=70;
            
            firstFrame.origin.y +=70;
        }
    } else {
        if(self.isSecondShown){
            frame.origin.y +=70;
            frame.size.height -=70;
            
            firstFrame.origin.y -=70;
        }
    }
    self.frame = frame;
    self.firstView.frame = firstFrame;
    
    self.secondView.hidden = !willShown;
    self.isSecondShown = willShown;
    
    //如果willshow,则↓应该显示出来
    if(willShown){
        [self.firstBtnArray[4] setHidden:NO];
    } else {
        [self.firstBtnArray[4] setHidden:YES];
    }
}


@end
