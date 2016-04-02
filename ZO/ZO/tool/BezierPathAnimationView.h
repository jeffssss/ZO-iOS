//
//  BezierPathAnimationView.h
//  ZO
//
//  Created by JiFeng on 16/4/2.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BezierPathAnimationView : UIView

@property(nonatomic,copy)   NSString    *displayString;

@property(nonatomic,strong) UIImage     *penImage;

@property(nonatomic,assign) CGFloat     duration;

@property(nonatomic,copy)   NSString    *fontName;

-(void)beginAnimate;
@end
