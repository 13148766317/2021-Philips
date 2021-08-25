//
//  KDSHttpManager+VideoWifiLock.m
//  2021-Philips
//
//  Created by zhaoxueping on 2020/9/9.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSHttpManager+VideoWifiLock.h"

@implementation KDSHttpManager (VideoWifiLock)

- (NSURLSessionDataTask *)videoWifiLockGetTokenWithUid:(NSString *)uid success:(void (^)(NSString * _Nullable))success error:(void (^)(NSError * _Nonnull))errorBlock failure:(void (^)(NSError * _Nonnull))failure
{
   uid = uid ?: @"";
    return [self POST:@"wifi/vedio/getToken" parameters:@{@"uid": uid} success:^(id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:NSDictionary.class])
        {
            !errorBlock ?: errorBlock([NSError errorWithDomain:@"服务器返回值错误" code:(int)KDSHttpErrorReturnValueIncorrect userInfo:nil]);
            return;
        }
        NSDictionary *obj = (NSDictionary *)responseObject;
        NSString *token = [obj[@"token"] isKindOfClass:NSString.class] ? obj[@"token"] : nil;
        !success ?: success(token);
    } error:errorBlock failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
}

- (NSURLSessionDataTask *)bindMediaWifiDevice:(KDSWifiLockModel *)device uid:(NSString *)uid success:(void (^)(void))success error:(void (^)(NSError * _Nonnull))errorBlock failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:7];
    params[@"wifiSN"] = device.wifiSN;
    params[@"lockNickName"] = device.lockNickname ?: device.wifiSN;
    params[@"uid"] = uid ?: @"";
    params[@"randomCode"] = device.randomCode ?: @"";
    params[@"wifiName"] = device.wifiName;
    params[@"functionSet"] = @(device.functionSet.intValue);
    params[@"distributionNetwork"] = @(device.distributionNetwork);
    params[@"device_sn"] = device.device_sn;
    params[@"mac"] = device.mac;
    params[@"device_did"] = device.device_did;
    params[@"p2p_password"] = device.p2p_password;

    return [self POST:@"wifi/vedio/bind" parameters:params success:^(id  _Nullable responseObject) {
        !success ?: success();
    } error:errorBlock failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
}

- (NSURLSessionDataTask *)updateMediaBindWifiDevice:(KDSWifiLockModel *)device uid:(NSString *)uid success:(void (^)(void))success error:(void (^)(NSError * _Nonnull))errorBlock failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:7];
    params[@"wifiSN"] = device.wifiSN;
    params[@"uid"] = uid ?: @"";
    params[@"randomCode"] = device.randomCode ?: @"";
    params[@"wifiName"] = device.wifiName;
    params[@"functionSet"] = @(device.functionSet.intValue);
    params[@"device_did"] = device.device_did;
    params[@"p2p_password"] = device.p2p_password;

    return [self POST:@"wifi/vedio/updateBind" parameters:params success:^(id  _Nullable responseObject) {
        !success ?: success();
    } error:errorBlock failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
}
- (NSURLSessionDataTask *)XMMediaBindFailWifiDevice:(KDSWifiLockModel *)device uid:(NSString *)uid result:(int)result success:(void (^)(void))success error:(void (^)(NSError * _Nonnull))errorBlock failure:(void (^)(NSError * _Nonnull))failure
{
    return [self POST:@"wifi/vedio/bindFail" parameters:@{@"wifiSN":device.wifiSN,@"result":@(0)} success:^(id  _Nullable responseObject) {
        !success ?: success();
    } error:errorBlock failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
}

- (NSURLSessionDataTask *)unbindXMMediaWifiDeviceWithWifiSN:(NSString *)wifiSN uid:(NSString *)uid success:(void (^)(void))success error:(void (^)(NSError * _Nonnull))errorBlock failure:(void (^)(NSError * _Nonnull))failure
{
    wifiSN = wifiSN ?: @""; uid = uid ?: @"";
    return [self POST:@"wifi/vedio/unbind" parameters:@{@"wifiSN":wifiSN, @"uid":uid} success:^(id  _Nullable responseObject) {
        !success ?: success();
    } error:errorBlock failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
}

- (nullable NSURLSessionDataTask *)getXMMediaLockBindedDeviceAlarmRecordWithWifiSN:(NSString *)wifiSN index:(int)index StartTime:(int)startTime EndTime:(int)endTime MarkIndex:(int)markIndex success:(nullable void(^)(NSArray<KDSWifiLockAlarmModel *> *models))success error:(nullable void(^)(NSError *error))errorBlock failure:(nullable void(^)(NSError *error))failure
{
    NSDictionary *paramDic = nil;
    NSString *urlString = nil;
    if (markIndex == 2) {//按照时间筛选预警记录
        urlString = @"wifi/alarm/filterList";
        paramDic = @{@"wifiSN":wifiSN, @"page":@(index), @"startTime":@(startTime), @"endTime":@(endTime)};
        
    }else{//正常获取访客预警数据
        urlString = @"wifi/vedio/alarmList";
        paramDic = @{@"wifiSN":wifiSN, @"page":@(index)};
    }
    
    wifiSN = wifiSN ?: @"";
    return [self POST:urlString parameters:paramDic success:^(id  _Nullable responseObject) {
        
        NSArray *obj = nil;
        
        if (markIndex == 2) {//时间筛选报警记录
            obj = [responseObject objectForKey:@"alarmList"];
            
        }else{//正常查询报警记录
            obj = responseObject;
        }
        
        if (![obj isKindOfClass:NSArray.class] || (obj.count && ![obj.firstObject isKindOfClass:NSDictionary.class]))
        {
            !errorBlock ?: errorBlock([NSError errorWithDomain:@"服务器返回值错误" code:(int)KDSHttpErrorReturnValueIncorrect userInfo:nil]);
            return;
        }
        !success ?: success([KDSWifiLockAlarmModel mj_objectArrayWithKeyValuesArray:obj].copy);
    } error:errorBlock failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
}

- (nullable NSURLSessionDataTask *)getXMMediaLockBindedDeviceVisitorRecordWithWifiSN:(NSString *)wifiSN index:(int)index StartTime:(int)startTime EndTime:(int)endTime MarkIndex:(int)markIndex success:(nullable void(^)(NSArray<KDSWifiLockAlarmModel *> *models))success error:(nullable void(^)(NSError *error))errorBlock failure:(nullable void(^)(NSError *error))failure
{
    NSDictionary *paranDic = nil;
    NSString *urlString = nil;
    if (markIndex == 2) {//按照时间筛选访客记录
        urlString = @"wifi/doorbell/filterList";
        paranDic = @{@"wifiSN":wifiSN, @"page":@(index), @"startTime":@(startTime), @"endTime":@(endTime)};
        
    }else{//正常获取访客记录数据
        urlString = @"wifi/vedio/doorbellList";
        paranDic = @{@"wifiSN":wifiSN, @"page":@(index)};
    }
    
    wifiSN = wifiSN ?: @"";
    return [self POST:urlString parameters:paranDic success:^(id  _Nullable responseObject) {
        
        NSArray *obj = nil;
        //通过日期筛选
        if (markIndex == 2) {
            obj = [responseObject objectForKey:@"doorbellList"];
            
        }else{//正常获取操作记录数据
            obj = responseObject;
        }
        
        if (![obj isKindOfClass:NSArray.class] || (obj.count && ![obj.firstObject isKindOfClass:NSDictionary.class]))
        {
            !errorBlock ?: errorBlock([NSError errorWithDomain:@"服务器返回值错误" code:(int)KDSHttpErrorReturnValueIncorrect userInfo:nil]);
            return;
        }
        !success ?: success([KDSWifiLockAlarmModel mj_objectArrayWithKeyValuesArray:obj].copy);
    } error:errorBlock failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
    
}

- (NSURLSessionDataTask *)getBindedWifiDeviceListWithUid:(NSString *)uid success:(void (^)(NSArray<KDSWifiLockModel *> * _Nonnull))success error:(void (^)(NSError * _Nonnull))errorBlock failure:(void (^)(NSError * _Nonnull))failure
{
    return [self POST:@"wifi/device/list" parameters:@{@"uid":uid} success:^(id  _Nullable responseObject) {
        NSArray *obj = responseObject;
        if (![obj isKindOfClass:NSArray.class] || (obj.count && ![obj.firstObject isKindOfClass:NSDictionary.class]))
        {
            !errorBlock ?: errorBlock([NSError errorWithDomain:@"服务器返回值错误" code:(int)KDSHttpErrorReturnValueIncorrect userInfo:nil]);
            return;
        }
        !success ?: success([KDSWifiLockModel mj_objectArrayWithKeyValuesArray:obj].copy);
    } error:errorBlock failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
    
}

- (NSURLSessionDataTask *)checkXMWiFiOTAWithSerialNumber:(NSString *)deviceName withCustomer:(int)customer withVersion:(NSString *)version withDevNum:(int)devNum success:(void (^)(id _Nullable))success error:(void (^)(NSError * _Nonnull))errorBlock failure:(void (^)(NSError * _Nonnull))failure
{
       NSMutableDictionary *params = [NSMutableDictionary dictionary];
       params[@"customer"] = @(customer);
       params[@"deviceName"] = deviceName;
       params[@"version"] = version;
       params[@"devNum"] = @(devNum);
       
       return [self POST:kOTAHost parameters:params success:^(id  _Nullable responseObject) {
           NSDictionary *obj = responseObject;
           if (![obj isKindOfClass:NSDictionary.class])
           {
               !errorBlock ?: errorBlock([NSError errorWithDomain:@"服务器返回值错误" code:(int)KDSHttpErrorReturnValueIncorrect userInfo:nil]);
               return;
           }

           !success ?: success(obj);
       } error:errorBlock failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           !failure ?: failure(error);
       }];
}

- (NSURLSessionDataTask *)xmWifiDeviceOTAWithSerialNumber:(NSString *)deviceName withOTAData:(NSDictionary *)data success:(void (^)(void))success error:(void (^)(NSError * _Nonnull))errorBlock failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"wifiSN"] = deviceName;
    params[@"fileLen"] = data[@"fileLen"];
    params[@"fileUrl"] = data[@"fileUrl"];
    params[@"fileMd5"] = data[@"fileMd5"];
          
    ///升级编号。1为WIFI模块，2为WIFI锁，3为人脸模组，4为视频模组，5为视频模组微控制器。
    params[@"devNum"] = data[@"devNum"];
    params[@"fileVersion"] = data[@"fileVersion"];
    
    return [self POST:KDS_WiFiLockOTA parameters:params success:^(id  _Nullable responseObject) {
        NSDictionary *obj = responseObject;
        if (![obj isKindOfClass:NSDictionary.class])
        {
            !errorBlock ?: errorBlock([NSError errorWithDomain:@"服务器返回值错误" code:(int)KDSHttpErrorReturnValueIncorrect userInfo:nil]);
            return;
        }

        !success ?: success();
    } error:errorBlock failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
          
}

@end
