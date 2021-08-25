//
//  PLPDoorLockStatisticsModel.h
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/19.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//-----门锁当天统计-------
@interface PLPDoorLockStatisticsModel : NSObject

///密码开门记录统计
@property(nonatomic,assign)int pwdOpenLockCount;
///指纹开门记录统计
@property(nonatomic,assign)int fingerprintOpenLockCount;
///卡片开门记录统计
@property(nonatomic,assign)int cardOpenLockCount;
///人脸开门记录统计
@property(nonatomic,assign)int faceOpenLockCount;
///访客记录统计
@property(nonatomic,assign)int doorbellCount;
///统计总数
@property(nonatomic,assign)int allCount;

@end

NS_ASSUME_NONNULL_END
