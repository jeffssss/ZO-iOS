//
//  FontThumbnailView.m
//  ZO
//
//  Created by JiFeng on 16/3/5.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "FontThumbnailView.h"

@interface FontThumbnailView ()

@end

@implementation FontThumbnailView


- (void)drawRect:(CGRect)rect{
    UIFont  *font = [UIFont systemFontOfSize:rect.size.width*0.8];//设置
    [self.wordNameString drawAtPoint:CGPointMake(rect.size.width*0.1, 0) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]}];//,NSBackgroundColorAttributeName:[UIColor greenColor]
}

@end
