//
//  PLPMSGTypeModel.h
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/31.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//消息统计类型
typedef NS_ENUM(NSUInteger, PLPDeviceMSGType) {
    ///没有定义
    lockTypeNone = 0,
    ///密码开门记录统计
    pwdOpenLock,
    ///指纹开门记录统计
    fingerprintOpenLock,
    ///卡片开门记录统计
    cardOpenLock,
    ///人脸开门记录统计
    faceOpenLock,
    ///访客记录统计
    doorbell
};

@interface PLPMSGTypeModel : NSObject
///消息类型
@property (nonatomic,assign)PLPDeviceMSGType  msgType;
///消息次数
@property (nonatomic,assign)int msgLockCount;

@end

NS_ASSUME_NONNULL_END
