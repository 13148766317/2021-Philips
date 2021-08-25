//
//  DeviceListTableViewCell.h
//  UIViewDome
//
//  Created by kaadas on 2021/4/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceListTableViewCell : UITableViewCell

// 锁的图标
@property(nonatomic ,strong) UIImageView  *logoimg;
// 锁的型号显示
@property(nonatomic ,strong) UILabel  *titlelabelSN;
// 开门状态
@property(nonatomic ,strong) UIImageView  * doorimg;
// 开门状态显示
@property(nonatomic ,strong) UILabel  *detaillabelDoor;
// 显示是蓝牙或wifi
@property(nonatomic ,strong) UIImageView  *flagimg;
///associated device model.蓝牙、Wi-Fi锁传KDSLock对象。
@property (nonatomic, strong) id model;

@end

NS_ASSUME_NONNULL_END
