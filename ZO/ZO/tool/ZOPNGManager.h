//
//  ZOPNGManager.h
//  ZO
//
//  Created by JiFeng on 16/3/7.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZOPNGManager : NSObject

+(NSString *)saveImageToPNG:(UIImage *)image withName:(NSString *)name;

+(UIImage *)imageWithFilename:(NSString *)filename;

+(BOOL)deletePNGImage:(NSString *)filename;
@end
