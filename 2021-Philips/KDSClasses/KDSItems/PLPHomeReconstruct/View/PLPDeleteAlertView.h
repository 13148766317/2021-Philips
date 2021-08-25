//
//  PLPDeleteAlertView.h
//  2021-Philips
//
//  Created by Apple on 2021/6/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPDeleteAlertView : NSObject

/// 确认删除回调
@property(nonatomic, copy) void (^confirmedBlock)(BOOL isConfirmed);

/// 显示确认删除
-(void) show;
@end

NS_ASSUME_NONNULL_END
