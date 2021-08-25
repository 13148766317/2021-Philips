//
//  CYActivityIndicatorShape.m
//  CYActivityIndicatorView
//
//  Created by Janlor on 2019/11/18.
//  Copyright © 2019 Janlor. All rights reserved.
//

#import "CYActivityIndicatorShape.h"

@implementation CYActivityIndicatorShape

+ (CALayer *)layerWidth:(CGSize)size
                  color:(UIColor *)color
                   type:(CYActivityIndicatorShapeType)type {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    switch (type) {
        case CYActivityIndicatorShapeTypeLine:
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height)
                                              cornerRadius:size.width / 2.];
            layer.fillColor = color.CGColor;
            break;
            
        default:
            break;
    }
    
    layer.backgroundColor = nil;
    layer.path = path.CGPath;
    layer.frame = CGRectMake(0, 0, size.width, size.height);
    
    return layer;
}

@end
