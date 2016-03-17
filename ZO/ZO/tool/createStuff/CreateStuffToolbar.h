//
//  CreateStuffToolbar.h
//  ZO
//
//  Created by JiFeng on 16/3/12.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateStuffToolbarDelegate <NSObject>

-(void)fontImageViewClick:(id)sender;
-(void)colorImageViewClick:(UIColor *)color;
-(void)sizeBtnClick:(int)method;

@end


@interface CreateStuffToolbar : UIView

@property(nonatomic,copy)   NSString                        *selectedWordString;//当前选中的文字

@property(nonatomic,weak)   id<CreateStuffToolbarDelegate>  delegate;

@end
