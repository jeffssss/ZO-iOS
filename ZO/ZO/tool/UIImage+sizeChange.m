//
//  UIImage+sizeChange.m
//  ZO
//
//  Created by JiFeng on 16/5/8.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "UIImage+sizeChange.h"

@implementation UIImage (sizeChange)

-(UIImage*)changeSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(UIImage*)changeSizeWithMulti:(CGFloat)multi{
    
    CGFloat newWidth = self.size.width * multi;
    CGFloat newHeight = self.size.height * multi;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, newWidth,newHeight)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
