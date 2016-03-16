//
//  WordImageView.m
//  ZO
//
//  Created by JiFeng on 16/3/16.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "WordImageView.h"
#import "ZOPNGManager.h"

@interface WordImageView ()

@property(nonatomic,strong) UILabel *nameLabel;
@end

@implementation WordImageView

-(void)setNameString:(NSString *)nameString{
    _nameString = nameString;
    self.isFromZOModel = NO;
    [self removeAllSubviews];
    self.image = [[UIImage alloc]init];
    _nameLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _nameLabel.text = nameString;
    _nameLabel.font = [UIFont systemFontOfSize:self.width*0.8];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nameLabel];
}

-(void)setModel:(ZOFontModel *)model{
    _model = model;
    self.isFromZOModel = YES;
    _nameString = model.name;
    [self removeAllSubviews];
    self.image = [ZOPNGManager imageWithFilename:model.filename];
}
@end
