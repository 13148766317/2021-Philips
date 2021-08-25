//
//  PLPDeviceListHomeVC.h
//  Pages
//
//  Created by Apple on 2021/5/18.
//

#import <UIKit/UIKit.h>
#import "PLPHomeNoDeviceView.h"
NS_ASSUME_NONNULL_BEGIN

@interface PLPHomeDevicesVC : UIViewController

//添加设备按钮
@property(nonatomic, weak) IBOutlet UIButton *btnAddDevice;

//切换设备列表显示按钮
@property(nonatomic, weak) IBOutlet UIButton *btnListView;

//切换设备卡片显示按钮
@property(nonatomic, weak) IBOutlet UIButton *btnCardView;

//设备分类容器视图
@property(nonatomic, weak) IBOutlet UIView *categoryContainerView;

//设备列表容器视图
@property(nonatomic, weak) IBOutlet UIView *deviceListContainerView;

//设备卡片容器视图
@property(nonatomic, weak) IBOutlet UIView *deviceCardContainerView;

//没有设备视图
@property(nonatomic, weak) IBOutlet PLPHomeNoDeviceView *noDeviceView;

//兼容旧版
@property(nonatomic, assign) BOOL enableCompatibleMode;

//切换设备卡片与列表显示
- (IBAction)changeDeviceView:(UIButton *) sender;

//添加设备
- (IBAction)addDeviceAction:(id)sender;


@end

NS_ASSUME_NONNULL_END
