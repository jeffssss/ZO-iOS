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
        self.backgroundColor = UIColorHex(0x00FF7F);
        self.layer.cornerRadius = 10.0;
        [self nameLabel];
        [self nameTextField];
        [self okBtn];
    }
    return self;
}

#pragma mark - getter
-(UILabel *)nameLabel{
    if(nil == _nameLabel){
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.width , 20)];
        _nameLabel.text=@"我要写的字是";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor blackColor];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}
-(UITextField *)nameTextField{
    if(nil == _nameTextField){
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.width * 0.2, self.nameLabel.bottom + 10, self.width * 0.6, 30)];
        _nameTextField.textAlignment = NSTextAlignmentCenter;
        _nameTextField.backgroundColor = UIColorHex(0xE3E4E6);
        _nameTextField.layer.cornerRadius = 4.0;
        [self addSubview:_nameTextField];
    }
    return _nameTextField;
}
-(UIButton *)okBtn{
    if(nil == _okBtn){
        _okBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width * 0.25, self.nameTextField.bottom + 10, self.width * 0.5, 30)];
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_okBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_okBtn setTarget:self action:@selector(onOKBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_okBtn];
    }
    return _okBtn;
}

-(void)onOKBtnClick{
    if([self.inputNameDelegate respondsToSelector:@selector(onInputNameOKBtnClick)]){
        [self.inputNameDelegate onInputNameOKBtnClick];
    }
}

-(void)setTextFieldDelegate:(id<UITextFieldDelegate>)textFieldDelegate{
    _textFieldDelegate = textFieldDelegate;
    if(_nameTextField){
        _nameTextField.delegate = _textFieldDelegate;
    }
}

@end
