//
//  InputNameView.m
//  ZO
//
//  Created by JiFeng on 16/3/8.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "InputNameView.h"

@interface InputNameView ()
@property(nonatomic,strong) UILabel         *nameLabel;
@property(nonatomic,strong) UITextField     *nameTextField;
@property(nonatomic,strong) UIButton        *okBtn;
@end

@implementation InputNameView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = UIColorHex(0xFFFFFF);
        self.layer.cornerRadius = 10.0;
        self.layer.borderWidth = 3.0;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        [self nameLabel];
        [self nameTextField];
        [self okBtn];
    }
    return self;
}

#pragma mark - getter
-(UILabel *)nameLabel{
    if(nil == _nameLabel){
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.width , 40)];
        _nameLabel.text=@"我要写的字:";
        _nameLabel.font = [UIFont fontWithName:@"-" size:25];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor blackColor];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}
-(UITextField *)nameTextField{
    if(nil == _nameTextField){
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.width * 0.2, self.nameLabel.bottom + 10, self.width * 0.6, 60)];
        _nameTextField.textAlignment = NSTextAlignmentCenter;
        _nameTextField.backgroundColor = [UIColor whiteColor];
        _nameTextField.placeholder = @"限一个字";
        _nameTextField.backgroundColor = UIColorHex(0xE3E4E6);
        _nameTextField.font = [UIFont fontWithName:@"-" size:35];
        _nameTextField.layer.cornerRadius = 4.0;
        [self addSubview:_nameTextField];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.nameTextField.left, self.nameTextField.bottom, self.nameTextField.width, 22)];
        lineImageView.image = [UIImage imageNamed:@"brush_line"];
        [self addSubview:lineImageView];
    }
    return _nameTextField;
}
-(UIButton *)okBtn{
    if(nil == _okBtn){
        _okBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width * 0.25, self.height - 50, self.width * 0.5, 30)];
        _okBtn.titleLabel.font = [UIFont fontWithName:@"-" size:25];
        _okBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _okBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _okBtn.layer.borderWidth = 2.0;
        _okBtn.layer.cornerRadius = _okBtn.height/2.0;
        [_okBtn setTarget:self action:@selector(onOKBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_okBtn];
        
    }
    return _okBtn;
}

-(void)onOKBtnClick{
    if([self.inputNameDelegate respondsToSelector:@selector(onInputNameOKBtnClick:)]){
        [self.inputNameDelegate onInputNameOKBtnClick:self.nameTextField.text];
    }
}

-(void)setTextFieldDelegate:(id<UITextFieldDelegate>)textFieldDelegate{
    _textFieldDelegate = textFieldDelegate;
    if(_nameTextField){
        _nameTextField.delegate = _textFieldDelegate;
    }
}

@end
