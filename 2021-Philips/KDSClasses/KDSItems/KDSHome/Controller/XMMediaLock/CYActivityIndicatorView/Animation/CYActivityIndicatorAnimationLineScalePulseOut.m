//
//  CYActivityIndicatorAnimationLineScalePulseOut.m
//  CYActivityIndicatorView
//
//  Created by Janlor on 2019/11/18.
//  Copyright © 2019 Janlor. All rights reserved.
//

#import "CYActivityIndicatorAnimationLineScalePulseOut.h"
#import "CYActivityIndicatorShape.h"

@implementation CYActivityIndicatorAnimationLineScalePulseOut

- (void)setUpAnimation:(CALayer *)layer
                  size:(CGSize)size
                 color:(UIColor *)color {
    CGFloat lineWidth = size.width / 9.;
    CGFloat x = (layer.bounds.size.width - size.width) / 2.;
    CGFloat y = (layer.bounds.size.height - size.height) / 2.;
    CFTimeInterval duration = 1;
    CFTimeInterval beginTime = CACurrentMediaTime();
    NSArray *beginTimes = @[@0.4, @0.2, @0, @0.2, @0.4];
    CAMediaTimingFunction *timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.85 :0.25 :0.37 :0.85];
    
    // Animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    
    animation.keyTimes = @[@0, @0.5, @1];
    animation.timingFunctions = @[timingFunction, timingFunction];
    animation.values = @[@1, @0.4, @1];
    animation.duration = duration;
    animation.repeatCount = HUGE;
    animation.removedOnCompletion = NO;
    
    // Draw lines
    for (NSInteger i = 0; i < 5; i++) {
        CALayer *lineLayer = [CYActivityIndicatorShape layerWidth:CGSizeMake(lineWidth, size.height)
                                                                             color:color
                                                                              type:CYActivityIndicatorShapeTypeLine];
        CGRect frame = CGRectMake(x + lineWidth * 2. * i, y, lineWidth, size.height);
        CFTimeInterval addTimes = [beginTimes[i] doubleValue];
        animation.beginTime = beginTime + addTimes;
        lineLayer.frame = frame;
        [lineLayer addAnimation:animation forKey:@"animation"];
        [layer addSublayer:lineLayer];
    }
}

@end
