//
//  SingleWordCollectionViewCell.m
//  ZO
//
//  Created by JiFeng on 16/3/10.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "SingleWordCollectionViewCell.h"

@interface SingleWordCollectionViewCell ()

@property(nonatomic,strong) UIImageView         *backgroundImageView;

@property(nonatomic,strong) UIImageView         *singleWordImageView;

@end

@implementation SingleWordCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        CGRect thisframe = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _backgroundImageView = [[UIImageView alloc] initWithFrame:thisframe];
        _backgroundImageView.image = [UIImage imageNamed:@"tianzige"];
        [self addSubview:_backgroundImageView];
        
        _singleWordImageView = [[UIImageView alloc] initWithFrame:thisframe];
        [self addSubview:_singleWordImageView];
    }
    return self;
}

-(void)loadData:(ZOFontModel *)model{
    self.singleWordImageView.image = [ZOPNGManager imageWithFilename:model.filename];
}

@end

@interface SingleWordCollectionViewHeader()
@property(nonatomic,strong) UILabel *nameLabel;
@end

@implementation SingleWordCollectionViewHeader

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        CGRect thisframe = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _nameLabel = [[UILabel alloc] initWithFrame:thisframe];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
    }
    return self;
}

-(void)loadData:(NSString *)data{
    self.nameLabel.text = data;
}

@end