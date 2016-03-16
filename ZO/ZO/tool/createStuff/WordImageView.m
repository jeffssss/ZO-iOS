//
//  WordImageView.m
//  ZO
//
//  Created by JiFeng on 16/3/16.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "WordImageView.h"
#import "ZOPNGManager.h"
#import "UIImage+Tint.h"

@interface WordImageView ()

@property(nonatomic,strong) UILabel *nameLabel;

@end

@implementation WordImageView

@synthesize imageColor = _imageColor;

-(void)setNameString:(NSString *)nameString{
    _nameString = nameString;
    self.isFromZOModel = NO;
    [self removeAllSubviews];
    self.image = [[UIImage alloc]init];
    self.nameLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.nameLabel.text = nameString;
    self.nameLabel.textColor = self.imageColor;
    self.nameLabel.font = [UIFont systemFontOfSize:self.width*0.8];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nameLabel];
}

-(void)setModel:(ZOFontModel *)model{
    _model = model;
    self.isFromZOModel = YES;
    _nameString = model.name;
    [self removeAllSubviews];
    [self paintImageWithColor:self.imageColor];
}
-(UIColor *)imageColor{
    if(nil == _imageColor){
        _imageColor = [UIColor blackColor];
    }
    return _imageColor;
}

-(void)setImageColor:(UIColor *)imageColor{
    _imageColor = imageColor;
    if(self.isFromZOModel){
        [self paintImageWithColor:imageColor];
    } else {
        //是label，则改变textcolor
        self.nameLabel.textColor = imageColor;
    }
}

-(void)paintImageWithColor:(UIColor *)color{
    if([color rgbaValue] == [[UIColor blackColor] rgbaValue]){
        //如果是黑色，则不用离屏渲染
        self.image = [ZOPNGManager imageWithFilename:self.model.filename];
    } else {
        self.image = [[ZOPNGManager imageWithFilename:self.model.filename] imageWithTintColor:color];
    }
}
@end
