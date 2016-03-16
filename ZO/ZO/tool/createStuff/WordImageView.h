//
//  WordImageView.h
//  ZO
//
//  Created by JiFeng on 16/3/16.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZOFontModel.h"

@interface WordImageView : UIImageView

@property(nonatomic,copy)   NSString    *nameString;
@property(nonatomic,assign) BOOL        isFromZOModel;//是否从zomodel里获得的image;
@property(nonatomic,strong) ZOFontModel *model;
@property(nonatomic,strong) UIColor     *imageColor;

@end
