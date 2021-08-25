//
//  XMP2PLog.h
//  XMStreamComCtrl
//
//  Created by Tix Xie on 2020/11/23.
//  Copyright © 2020 xmitech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XMP2PLogType) {
    /// 发送命令信息
    XMP2PLogTypeResponseInfo = 0,
    /// P2P连接信息
    XMP2PLogTypeConnectInfo  = 1,
};

@interface XMP2PLog : NSObject

- (instancetype)initWithData:(NSDictionary *)dictionary;

@end

@interface XMP2PInfoItem : XMP2PLog
/// p2p连接模式 0：P2P，1：转发
@property (nonatomic, assign) NSInteger mode;
/// 本地IP地址
@property (nonatomic, copy) NSString *local_address;
/// 本地IP地址端口
@property (nonatomic, assign) NSInteger local_address_port;
/// 远程IP地址
@property (nonatomic, copy) NSString *remote_address;
/// 远程IP地址端口
@property (nonatomic, assign) NSInteger remote_address_port;
/// 外网IP地址
@property (nonatomic, copy) NSString *wan_address;
/// 外网IP地址端口
@property (nonatomic, assign) NSInteger wan_address_port;
@end

@interface XMP2PConnectInfoItem : XMP2PLog
/// 连接会话句柄
@property (nonatomic, assign) NSInteger session;
/// 开始连接时间
@property (nonatomic, assign) NSInteger connect_start_time;
/// 连接结束时间
@property (nonatomic, assign) NSInteger connect_result_time;
/// 耗时 毫秒
@property (nonatomic, assign) NSInteger connect_time_consume;
/// 连接类型
@property (nonatomic, assign) NSInteger connect_type;
/// 连接设备DID
@property (nonatomic, copy) NSString *device_did;
/// 连接设备SN
/// 注意：这个SN在旧版时可能没有值，只有是新版在连接设备时 XMConnectParameter 传入了SN，才会有值。
@property (nonatomic, nullable, copy) NSString *device_sn;
/// p2P_info：当 session > 0 时有值
@property (nonatomic, nullable, strong) XMP2PInfoItem *p2p_info;

@end

@interface XMP2PResponseInfoItem : XMP2PLog
/// 当前指定值
@property (nonatomic, assign) NSInteger cmd;
/// 会话ID
@property (nonatomic, assign) NSInteger session;
/// 请求报文的时间戳
@property (nonatomic, assign) NSInteger request_time;
/// 请求数据的报文
@property (nonatomic, copy) NSDictionary *request_body;
/// 响应报文的时间戳
@property (nonatomic, assign) NSInteger response_time;
/// 响应的数据报文
@property (nonatomic, copy) NSDictionary *response_body;
/// 耗时 毫秒
@property (nonatomic, assign) NSInteger time_consume;
@end

NS_ASSUME_NONNULL_END
