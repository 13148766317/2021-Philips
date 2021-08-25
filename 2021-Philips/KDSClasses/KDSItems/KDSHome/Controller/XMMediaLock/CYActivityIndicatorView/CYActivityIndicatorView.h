//
//  CYActivityIndicatorView.h
//  CYActivityIndicatorView
//
//  Created by Janlor on 2019/11/18.
//  Copyright © 2019 Janlor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CYActivityIndicatorType) {
    CYActivityIndicatorTypeLineScalePulseOut,
};

@interface CYActivityIndicatorView : UIView

@property (nonatomic, assign, readonly) BOOL animating;

- (instancetype)initWithFrame:(CGRect)frame
                         type:(CYActivityIndicatorType)type
                        color:(UIColor *)color;

- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
