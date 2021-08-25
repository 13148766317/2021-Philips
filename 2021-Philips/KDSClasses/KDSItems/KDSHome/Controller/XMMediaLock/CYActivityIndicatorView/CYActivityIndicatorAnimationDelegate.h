//
//  CYActivityIndicatorAnimationDelegate.h
//  CYActivityIndicatorView
//
//  Created by Janlor on 2019/11/18.
//  Copyright © 2019 Janlor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CYActivityIndicatorAnimationDelegate <NSObject>

- (void)setUpAnimation:(CALayer *)layer
                  size:(CGSize)size
                 color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
