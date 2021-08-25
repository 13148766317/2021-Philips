//
//  CYActivityIndicatorShape.h
//  CYActivityIndicatorView
//
//  Created by Janlor on 2019/11/18.
//  Copyright © 2019 Janlor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CYActivityIndicatorShapeType) {
    CYActivityIndicatorShapeTypeLine,
};

@interface CYActivityIndicatorShape : NSObject

+ (CALayer *)layerWidth:(CGSize)size
                  color:(UIColor *)color
                   type:(CYActivityIndicatorShapeType)type;

@end

NS_ASSUME_NONNULL_END
