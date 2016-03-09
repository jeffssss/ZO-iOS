//
//  InputNameView.h
//  ZO
//
//  Created by JiFeng on 16/3/8.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView/FXBlurView.h>

@protocol InputNameDelegate <NSObject>

-(void)onInputNameOKBtnClick;

@end

@interface InputNameView : UIView

@property(nonatomic,weak) id<InputNameDelegate> inputNameDelegate;

@property(nonatomic,weak) id<UITextFieldDelegate> textFieldDelegate;

@end
