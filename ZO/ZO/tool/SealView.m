//
//  SealView.m
//  SealDemo
//
//  Created by JiFeng on 16/2/28.
//  Copyright © 2016年 jeffsss. All rights reserved.
//

#import "SealView.h"

@interface SealView()

@property(nonatomic,strong) UIImageView *backgourndImageView;
@end

@implementation SealView


- (void)drawRect:(CGRect)rect{

    UIFont  *font = [UIFont fontWithName:@"HYj1gf" size:40.0];//设置
    NSArray *pointArray = [self pointArrayWithCount:self.nameString.length andPaddingX:-12.0 paddingY:-2.0];
    [self.nameString enumerateSubstringsInRange:NSMakeRange(0, self.nameString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        CGPoint basepoint = CGPointMake(10, 10);
        CGPoint thispoint = CGPointFromString(pointArray[substringRange.location]);
        //如果是英文，需要往右平移一段距离
        const char    *cString = [substring UTF8String];
        if(strlen(cString) < 3){
            //不是中文
            thispoint = CGPointMake(thispoint.x + 12, thispoint.y);
        }
        CGPoint realpoint = CGPointMake(basepoint.x + thispoint.x, basepoint.y + thispoint.y);
        [substring drawAtPoint:realpoint withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor colorWithRed:220.0/255 green:30.0/255 blue:15.0/255 alpha:1]}];//,NSBackgroundColorAttributeName:[UIColor greenColor]
    }];
    CGFloat backgroundPadding_x = 4;
    CGFloat backgroundPadding_y = 4;
    CGFloat height = 100;
    CGFloat width = 100;
    switch (pointArray.count) {
        case 1:
            backgroundPadding_x = 2;
            backgroundPadding_y = 4;
            height = 40;
            width = 40;
            break;
        case 2:
            backgroundPadding_x = 2;
            backgroundPadding_y = 8;
            height = 80;
            width = 40;
            break;
        case 3:
            backgroundPadding_x = 2;
            backgroundPadding_y = 14;
            height = 120;
            width = 40;
            break;
        case 4:
            backgroundPadding_x = 2;
            backgroundPadding_y = 10;
            height = 80;
            width = 70;
            break;
        case 5:
            backgroundPadding_x = 2;
            backgroundPadding_y = 14;
            height = 120;
            width = 70;
            break;
        case 6:
            backgroundPadding_x = 2;
            backgroundPadding_y = 14;
            height = 120;
            width = 70;
            break;
    }
    
    self.backgourndImageView.frame = CGRectMake(10-backgroundPadding_x, 10 - backgroundPadding_y, 2*backgroundPadding_x + width, 2*backgroundPadding_y +height);
    
    self.backgourndImageView.image = [UIImage imageNamed:@"seal_background.png"];
    
}
-(UIImageView *)backgourndImageView{
    if(nil == _backgourndImageView){
        _backgourndImageView = [[UIImageView alloc] init];
        [self addSubview:_backgourndImageView];
    }
    return _backgourndImageView;
}

-(NSArray*)pointArrayWithCount:(NSInteger)count andPaddingX:(CGFloat)paddingX paddingY:(CGFloat)paddingY{
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:count];
    switch (count) {
        case 1:
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 0))];
            break;
        case 2:
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 0))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 40+paddingY))];
            break;
        case 3:
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 0))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 40+paddingY))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 80+2*paddingY))];
            break;
        case 4:
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(40+paddingX, 0))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(40+paddingX, 40+paddingY))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 0))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 40+paddingY))];
            break;
        case 5:
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(40+paddingX, 0))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(40+paddingX, 40+paddingY))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(40+paddingX, 80+paddingY*2))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 15))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 65+paddingY))];
            break;
        case 6:
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(40+paddingX, 0))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(40+paddingX, 40+paddingY))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(40+paddingX, 80+2*paddingY))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 0))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 40+paddingY))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 80+2*paddingY))];
            break;
        default:
            break;
    }
    return [resultArray copy];
}
@end
