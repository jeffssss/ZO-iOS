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
@property(nonatomic,assign) CGRect      originalFrame;
@end

@implementation SealView


-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.originalFrame = frame;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    UIFont  *font = [UIFont fontWithName:@"HYj1gf" size:40.0];//设置
    NSArray *pointArray = [self pointArrayWithCount:self.nameString.length andPaddingX:-12.0 paddingY:-2.0];
    
    //先设置以及背景的frame
    CGFloat backgroundPadding_x = 2;
    CGFloat backgroundPadding_y = 4;
    CGFloat height = self.originalFrame.size.height;
    CGFloat width = self.originalFrame.size.width;
    switch (pointArray.count) {
        case 1:
            backgroundPadding_x = width/8.0;
            backgroundPadding_y = height/8.0;
            font = [UIFont fontWithName:@"HYj1gf" size:width*3/4];
            break;
        case 2:
            width = width/2.0;
            backgroundPadding_x = width/8.0;
            backgroundPadding_y = height/8.0;
            font = [UIFont fontWithName:@"HYj1gf" size:width*3/4];
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
        default:;
    }
    
    self.backgourndImageView.frame = CGRectMake(0, 0, width, height);
    
    self.backgourndImageView.image = [UIImage imageNamed:@"seal_background.png"];//这个不用重复赋值
    
    //再绘出每一个字
    [self.nameString enumerateSubstringsInRange:NSMakeRange(0, self.nameString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        CGPoint thispoint = CGPointFromString(pointArray[substringRange.location]);
        //如果是英文，需要往右平移一段距离
        const char    *cString = [substring UTF8String];
        if(strlen(cString) < 3){
            //不是中文
            thispoint = CGPointMake(thispoint.x + width/4.0, thispoint.y);
        }
        CGPoint realpoint = CGPointMake(backgroundPadding_x + thispoint.x, backgroundPadding_y + thispoint.y);
        [substring drawAtPoint:realpoint withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor colorWithRed:220.0/255 green:30.0/255 blue:15.0/255 alpha:1]}];//,NSBackgroundColorAttributeName:[UIColor greenColor]
    }];
}
-(UIImageView *)backgourndImageView{
    if(nil == _backgourndImageView){
        _backgourndImageView = [[UIImageView alloc] init];
        _backgourndImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backgourndImageView];
    }
    return _backgourndImageView;
}

-(NSArray*)pointArrayWithCount:(NSInteger)count andPaddingX:(CGFloat)paddingX paddingY:(CGFloat)paddingY{
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:count];
    CGFloat unit_x = self.originalFrame.size.width/count * 3.0 / 4.0;
    CGFloat unit_y = self.originalFrame.size.height/(count % 3) * 3.0 / 4.0;
    switch (count) {
        case 1:
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 0))];
            break;
        case 2:
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 0))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, unit_y +paddingY))];
            break;
        case 3:
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, 0))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, unit_y + paddingY))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(0, unit_y + 2*paddingY))];
            break;
        case 4:
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(unit_x+paddingX, 0))];
            [resultArray addObject:NSStringFromCGPoint(CGPointMake(unit_x+paddingX, unit_y+paddingY))];
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

-(NSString *)sizeThatAdjust{
    CGFloat height = self.originalFrame.size.height;
    CGFloat width = self.originalFrame.size.width;
    switch (self.nameString.length) {
        case 1:
            break;
        case 2:
            width = width/2.0;
            break;
        case 3:
            width = width/3.0;
            break;
        case 4:
            width = width * 7.0 / 8.0;
            break;
        case 5:
        case 6:
            height = 120;
            width = width * 7.0 / 12.0;;
            break;
        default:;
    }
    return NSStringFromCGSize(CGSizeMake(width, height));
}

-(void)adjustFrame{
    //调整frame
    CGRect frame = self.frame;
    frame.size = CGSizeFromString([self sizeThatAdjust]);
    frame.origin.x = (self.superview.width - frame.size.width)/2.0;
    self.frame = frame;
    
    [self setNeedsDisplay];
}
@end
