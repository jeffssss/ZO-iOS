//
//  SingleWordCollectionViewCell.h
//  ZO
//
//  Created by JiFeng on 16/3/10.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZOFontModel.h"

@interface SingleWordCollectionViewCell : UICollectionViewCell

-(void)loadData:(ZOFontModel *)model;

@end

@interface SingleWordCollectionViewHeader : UICollectionReusableView
-(void)loadData:(NSString *)data;
@end