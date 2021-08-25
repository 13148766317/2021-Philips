//
//  HWCircleView.m
//  HYHCircleProgress
//
//  Created by kaadas on 2021/7/21.
//  Copyright © 2021 huangyongheng. All rights reserved.
//

#import "HWCircleView.h"

@interface HWCircleView ()

@property (nonatomic, weak) UILabel *cLabel;

@end

@implementation HWCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //默认颜色
        self.progerssBackgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        self.progerssColor= [UIColor colorWithRed:0/255.0 green:102/255.0 blue:161/255.0 alpha:1.0];
        self.percentFontColor= [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        //默认进度条宽度
        self.progerWidth=15;
        //默认百分比字体大小
        self.percentageFontSize=48;
        self.progress = 1.0;
        
        //百分比标签
        UILabel *cLabel = [[UILabel alloc] initWithFrame:self.bounds];
        cLabel.font = [UIFont boldSystemFontOfSize:self.percentageFontSize];
        cLabel.textColor = self.percentFontColor;
        cLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:cLabel];
        self.cLabel = cLabel;
        UILabel *second = [[UILabel alloc] init];
        second.frame = CGRectMake(self.bounds.origin.x+(self.bounds.size.width/2)+15, self.bounds.origin.y+( self.bounds.size.height/2)-20, 40, 60);
        
        second.font = [UIFont boldSystemFontOfSize:18];
        second.text = @"S";
        second.textColor =[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
        second.textAlignment = NSTextAlignmentCenter;
        [self addSubview:second];
    
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _cLabel.text = [NSString stringWithFormat:@"%d", (int)floor(progress * 100)];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    
    //路径
    UIBezierPath *backgroundPath = [[UIBezierPath alloc] init];
    //线宽
    backgroundPath.lineWidth = self.progerWidth;
    //颜色
    [self.progerssBackgroundColor set];
    //拐角
    backgroundPath.lineCapStyle = kCGLineCapRound;
    backgroundPath.lineJoinStyle = kCGLineJoinRound;
    //半径
    CGFloat radius = (MIN(rect.size.width, rect.size.height) - self.progerWidth) * 0.5;
    //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    [backgroundPath addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2  clockwise:YES];
    //连线
    [backgroundPath stroke];
    
    
    //路径
    UIBezierPath *progressPath = [[UIBezierPath alloc] init];
    //线宽
    progressPath.lineWidth = self.progerWidth;
    //颜色
    [self.progerssColor set];
    //拐角
    progressPath.lineCapStyle = kCGLineCapRound;
    progressPath.lineJoinStyle = kCGLineJoinRound;
    //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    [progressPath addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 *( 1-(_progress-0.01)) clockwise:YES];
    //连线
    [progressPath stroke];
}

@end

