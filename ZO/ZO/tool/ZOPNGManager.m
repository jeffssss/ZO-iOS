//
//  ZOPNGManager.m
//  ZO
//
//  Created by JiFeng on 16/3/7.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "ZOPNGManager.h"

@implementation ZOPNGManager

+(NSString *)saveImageToPNG:(UIImage *)image withName:(NSString *)name{
    NSString *filename = [NSString stringWithFormat:@"%@%@.png",name,[[NSDate date] stringWithFormat:@"yyyyMMddHHmmss"]];
    
    NSString *filePath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename];
    BOOL result = [UIImagePNGRepresentation(image)writeToFile: filePath atomically:YES]; // 保存成功会返回YES
    
    if(result){
        NSLog(@"保存成功！");
    } else {
        NSLog(@"保存失败！！！！！filename = %@",filename);
        return nil;
    }
    return filename;
}

+(UIImage *)imageWithFilename:(NSString *)filename{
    return [UIImage imageWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename]];
}

+(BOOL)deletePNGImage:(NSString *)filename{
    NSString *filePath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename];
    NSError *error;
    BOOL result = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    if(!result){
        NSLog(@"Unable to delete pngImageFile:%@",[error localizedDescription]);
    }
    return result;
}

@end
