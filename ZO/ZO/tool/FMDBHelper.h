//
//  FMDBHelper.h
//  ZO
//
//  Created by JiFeng on 16/3/6.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZOFontModel.h"

@interface FMDBHelper : NSObject

+ (FMDBHelper *)sharedManager;

-(BOOL)insertData:(ZOFontModel *)model;

-(NSMutableArray *)query:(NSString *)sql;

-(BOOL)exec:(NSString *)sql;

@end
