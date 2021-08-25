//
//  CYActivityIndicatorView.m
//  CYActivityIndicatorView
//
//  Created by Janlor on 2019/11/18.
//  Copyright © 2019 Janlor. All rights reserved.
//

#import "CYActivityIndicatorView.h"
#import "CYActivityIndicatorAnimationLineScalePulseOut.h"

@interface CYActivityIndicatorView ()

@property (nonatomic, assign) CYActivityIndicatorType type;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation CYActivityIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
                         type:(CYActivityIndicatorType)type
                        color:(UIColor *)color {
    _type = type;
    _color = color ?: [UIColor whiteColor];
    
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.hidden = YES;
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return self.bounds.size;
}

#pragma mark Public

- (BOOL)animating {
    return _isAnimating;
}

- (void)startAnimating {
    if (_isAnimating) { return; }
    
    self.hidden = NO;
    self.isAnimating = YES;
    self.layer.speed = 1;
    [self setUpAnimation];
}

- (void)stopAnimating {
    if (!_isAnimating) { return; }
    
    self.hidden = YES;
    self.isAnimating = NO;
    
    for (CAShapeLayer *layer in self.layer.sublayers) {
        [layer removeAllAnimations];
    }
}

#pragma mark Private

- (void)setUpAnimation {
    id<CYActivityIndicatorAnimationDelegate> animation = [self animation:_type];
    CGRect animationRect = self.frame;
    CGFloat minEdge = MIN(self.frame.size.width, self.frame.size.height);
    
    self.layer.sublayers = nil;
    animationRect.size = CGSizeMake(minEdge, minEdge);
    [animation setUpAnimation:self.layer size:animationRect.size color:_color];
}

- (id<CYActivityIndicatorAnimationDelegate>)animation:(CYActivityIndicatorType)type {
    switch (type) {
        case CYActivityIndicatorTypeLineScalePulseOut:
            return [[CYActivityIndicatorAnimationLineScalePulseOut alloc] init];
            break;
            
        default:
            break;
    }
}

@end
