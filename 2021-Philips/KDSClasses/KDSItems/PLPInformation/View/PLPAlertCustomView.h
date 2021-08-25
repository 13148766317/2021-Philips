//
//  PLPAlertCustomView.h
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/20.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    // 从中间弹出
    NKAlertViewTypeDef,
    // 从底部弹出
    NKAlertViewTypeBottom
} NKAlertViewType;

@interface PLPAlertCustomView : UIView

@property (nonatomic, assign) NKAlertViewType type;
// 点击背景时候隐藏alert
//@property (nonatomic, assign) BOOL hiddenWhenTapBG;
///cell展示的数据
@property (nonatomic, strong)NSArray * devArr;
@property (nonatomic, strong)NSString * currentDevString;
/** cell点击回调 */
@property (nonatomic, copy) void (^cellClickBlock)(KDSLock*);

// Show the alert view in current window
- (void)show;

// Hide the alert view
- (void)hide;
@end

NS_ASSUME_NONNULL_END
