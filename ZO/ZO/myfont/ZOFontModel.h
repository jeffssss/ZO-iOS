//
//  ZOFontModel.h
//  ZO
//
//  Created by JiFeng on 16/3/6.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZOFontModel : NSObject

@property(nonatomic,assign) NSInteger   zoid;

@property(nonatomic,copy)   NSString    *name;

@property(nonatomic,copy)   NSString    *filename;

@property(nonatomic,assign) NSInteger   type;

@property(nonatomic,copy)   NSDate    *createtime;

@end
