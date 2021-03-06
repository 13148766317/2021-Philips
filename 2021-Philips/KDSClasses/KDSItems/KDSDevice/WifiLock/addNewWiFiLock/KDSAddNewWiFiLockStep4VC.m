//
//  KDSAddNewWiFiLockStep4VC.m
//  2021-Philips
//
//  Created by zhaona on 2020/3/10.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSAddNewWiFiLockStep4VC.h"
#import "KDSWifiLockHelpVC.h"
#import "KDSDeviceConnectionStep1VC.h"

@interface KDSAddNewWiFiLockStep4VC ()

@property (nonatomic,strong) UIImageView * addZigBeeLocklogoImg;

@end

@implementation KDSAddNewWiFiLockStep4VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationTitleLabel.text = Localized(@"addDoorLock");
    [self setRightButton];
    [self.rightButton setImage:[UIImage imageNamed:@"questionMark"] forState:UIControlStateNormal];
    [self setUI];
    [self startAnimation4Connection];
}

-(void)setUI
{
    UIView * supView = [UIView new];
    supView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:supView];
    [supView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(3);
    }];
    
    ///用手触碰按键区，唤醒门锁 确保门锁数字键盘灯亮
    UILabel * tipMsgLabe1 = [UILabel new];
    tipMsgLabe1.text = @"用手触碰按键区，唤醒门锁 \n确保门锁数字键盘灯亮 ";
    tipMsgLabe1.font = [UIFont systemFontOfSize:18];
    tipMsgLabe1.numberOfLines = 0;
    tipMsgLabe1.textColor = UIColor.blackColor;
    tipMsgLabe1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipMsgLabe1];
    [tipMsgLabe1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(KDSScreenHeight > 667 ? 51 : 20);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    
    ///添加门锁的logo
    self.addZigBeeLocklogoImg = [UIImageView new];
    self.addZigBeeLocklogoImg.image = [UIImage imageNamed:@"addNewWiFiLockStep2Img1.jpg"];
    [self.view addSubview:self.addZigBeeLocklogoImg];
    [self.addZigBeeLocklogoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipMsgLabe1.mas_bottom).offset(KDSScreenHeight < 667 ? 56 : 85);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.height.equalTo(@235);
        make.width.equalTo(@163);
        
    }];
    
   UIButton * wakeUpPanelBtn = [UIButton new];
   [wakeUpPanelBtn setTitle:@"已唤醒面板" forState:UIControlStateNormal];
   [wakeUpPanelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
   wakeUpPanelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
   [wakeUpPanelBtn addTarget:self action:@selector(wakeUpPanelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   wakeUpPanelBtn.backgroundColor = KDSRGBColor(31, 150, 247);
   wakeUpPanelBtn.layer.masksToBounds = YES;
   wakeUpPanelBtn.layer.cornerRadius = 20;
   [self.view addSubview:wakeUpPanelBtn];
   [wakeUpPanelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.width.equalTo(@200);
       make.height.equalTo(@44);
       make.centerX.equalTo(self.view);
       make.bottom.equalTo(self.view.mas_bottom).offset(KDSScreenHeight < 667 ? -46 : -65);
   }];
    
    
}

//NSArray *_arrayImages4Connecting; 几张图片按顺序切换
- (void)startAnimation4Connection {
    NSArray * _arrayImages4Connecting = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"addNewWiFiLockStep2Img1.jpg"],
                                         [UIImage imageNamed:@"addNewWiFiLockStep2Img2.jpg"],
                                         nil];
    [self.addZigBeeLocklogoImg setAnimationImages:_arrayImages4Connecting];
    [self.addZigBeeLocklogoImg setAnimationRepeatCount:0];
    [self.addZigBeeLocklogoImg setAnimationDuration:2.0f];
    [self.addZigBeeLocklogoImg startAnimating];

}

//停止删除
-(void)imgAnimationStop{
    [self.addZigBeeLocklogoImg.layer removeAllAnimations];
}

-(void)dealloc
{
    [self imgAnimationStop];
}

#pragma mark 控件点击事件

-(void)navRightClick
{
    KDSWifiLockHelpVC * vc = [KDSWifiLockHelpVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
//已唤醒面板
-(void)wakeUpPanelBtnClick:(UIButton *)sender
{
    KDSDeviceConnectionStep1VC * vc = [KDSDeviceConnectionStep1VC new];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
