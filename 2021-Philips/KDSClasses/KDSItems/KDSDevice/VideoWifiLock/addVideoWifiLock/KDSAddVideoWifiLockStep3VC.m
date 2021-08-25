//
//  KDSAddVideoWifiLockStep3VC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2020/9/8.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSAddVideoWifiLockStep3VC.h"
#import "KDSVideoWiFiLockUpDataAdminiPwdVC.h"
#import "KDSAddVideoWifiLockConfigureWiFiVC.h"
#import "KDSXMMediaLockHelpVC.h"
#import "KDSAMapLocationManager.h"
#import "PLPDistributionNetworkPopupsView.h"
#import "SYAlertView.h"
#import "KDSBleAndWiFiForgetAdminPwdVC.h"

@interface KDSAddVideoWifiLockStep3VC ()

@property (nonatomic, strong) UIView *routerProtocolView;
@property (nonatomic, strong) UIView *supView;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) UILabel *failelabel;

///添加成功之后弹出的提示设置开关的视图
@property (nonatomic, strong) PLPDistributionNetworkPopupsView *successShowView;
@property (nonatomic, strong) SYAlertView *alertView;

@end

@implementation KDSAddVideoWifiLockStep3VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationTitleLabel.text = Localized(@"进入管理模式");
    [self setRightButton];
    [self.rightButton setImage:[UIImage imageNamed:@"philips_icon_help"] forState:UIControlStateNormal];
    //先判断是否连接上wifi
    [[KDSUserManager sharedManager] monitorNetWork];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityStatusDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self setupUI];
}

- (void)setupUI {
    self.supView = [UIView new];
    self.supView.backgroundColor = UIColor.whiteColor;

    [self.view addSubview:self.supView];
    [self.supView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];

    // 添加滚动视图的占位图
    UIView *topView = [UIView  new];
    // topView.backgroundColor = [UIColor redColor];
    [_supView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_supView).offset(20);
        make.right.left.equalTo(_supView);
        make.height.equalTo(@40);
    }];
    UIView *centerCircle = [UIView new];
    centerCircle.backgroundColor = KDSRGBColor(179, 200, 230);
    centerCircle.layer.masksToBounds = YES;
    centerCircle.layer.cornerRadius = 8;
    [topView addSubview:centerCircle];
    [centerCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
        make.height.width.equalTo(@16);
    }];
    UIView *Circle2 = [UIView new];
    Circle2.backgroundColor = KDSRGBColor(179, 200, 230);
    Circle2.layer.masksToBounds = YES;
    Circle2.layer.cornerRadius = 8;
    [topView addSubview:Circle2];
    [Circle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.centerX.equalTo(topView.mas_centerX).offset(-50);
        make.height.width.equalTo(@16);
    }];

    UIView *Circle1 = [UIView new];
    Circle1.backgroundColor = KDSRGBColor(0, 102, 161);
    Circle1.layer.masksToBounds = YES;
    Circle1.layer.cornerRadius = 8;
    [topView addSubview:Circle1];
    [Circle1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.centerX.equalTo(Circle2.mas_centerX).offset(-50);
        make.height.width.equalTo(@16);
    }];

    UIView *Circle4 = [UIView new];
    Circle4.backgroundColor = KDSRGBColor(179, 200, 230);
    Circle4.layer.masksToBounds = YES;
    Circle4.layer.cornerRadius = 8;
    [topView addSubview:Circle4];
    [Circle4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.centerX.equalTo(topView.mas_centerX).offset(50);
        make.height.width.equalTo(@16);
    }];

    UIView *Circle5 = [UIView new];
    Circle5.backgroundColor = KDSRGBColor(179, 200, 230);
    Circle5.layer.masksToBounds = YES;
    Circle5.layer.cornerRadius = 8;
    [topView addSubview:Circle5];
    [Circle5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.centerX.equalTo(Circle4.mas_centerX).offset(50);
        make.height.width.equalTo(@16);
    }];

    // 绘制中间的连线
    UIView *lineView = [UIView new];
    lineView.backgroundColor = KDSRGBColor(0, 102, 161);

    [topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        // make.width.equalTo(@50);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(Circle1.mas_right);
        make.right.equalTo(Circle2.mas_left);
    }];

    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = KDSRGBColor(179, 200, 230);

    [topView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.width.equalTo(@50);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(Circle2.mas_right);
    }];

    UIView *lineView3 = [UIView new];
    lineView3.backgroundColor = KDSRGBColor(179, 200, 230);

    [topView addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.width.equalTo(@50);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(centerCircle.mas_right);
    }];
    UIView *lineView4 = [UIView new];
    lineView4.backgroundColor = KDSRGBColor(179, 200, 230);

    [topView addSubview:lineView4];
    [lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.width.equalTo(@50);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(Circle4.mas_right);
    }];

    // 中间的图片
    UIImageView *promptImg = [UIImageView new];
    promptImg.image = [UIImage imageNamed:@"philips_dms_img_keying"];
    [self.supView addSubview:promptImg];
    [promptImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@156);
        make.width.equalTo(@120);
        make.top.equalTo(topView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX).offset(20);
    }];

    // 底部的文字
    //
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.text = Localized(@"Manager_Tips_One");
    [self.supView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptImg.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    UILabel *tipsLabel2 = [UILabel new];
    tipsLabel2.text = Localized(@"Manager_Tips_Two");
    tipsLabel2.numberOfLines = 0;
    tipsLabel2.lineBreakMode = NSLineBreakByWordWrapping;
    [self.supView addSubview:tipsLabel2];
    [tipsLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    UILabel *tipsLabel3 = [UILabel new];
    tipsLabel3.text =  Localized(@"Manager_Tips_There");
    [self.supView addSubview:tipsLabel3];
    [tipsLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel2.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    // 点击进行下一步的按钮
    _nextButton = [UIButton new];
    [_nextButton setBackgroundColor:KDSRGBColor(179, 200, 230)];
    [_nextButton setTitle:Localized(@"下一步") forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.supView addSubview:_nextButton];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.height.equalTo(@44);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-80);
    }];

    UIView *view = [UIView new];
    // view.backgroundColor = UIColor.whiteColor;
    [self.supView addSubview:view];
    // 添加点击事件
    UITapGestureRecognizer * selectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(visibleBtn)];
    [view addGestureRecognizer:selectTap];
    view.userInteractionEnabled = YES;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_nextButton.mas_top).offset(0);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    
    UILabel *plaseLable = [UILabel new];
    plaseLable.text = Localized(@"Voice_Remind");
    plaseLable.textColor = KDSRGBColor(102, 102, 102);
    plaseLable.font = [UIFont systemFontOfSize:14];
    [view addSubview:plaseLable];
    [plaseLable mas_makeConstraints:^(MASConstraintMaker *make) {
        // make.top.equalTo(nextButton.mas_bottom).offset(10);
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
    }];
    _selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _selectBtn.backgroundColor = [UIColor clearColor];
    [_selectBtn setTintColor:[UIColor clearColor]];
    //self.agreeBtn.selected = YES;
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_default"] forState:UIControlStateNormal];
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_selected"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(visibleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.supView addSubview:_selectBtn];

    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.height.width.equalTo(@18);
        make.right.equalTo(plaseLable.mas_left).offset(-10);
    }];

    _failelabel = [UILabel new];
    _failelabel.text = Localized(@"Voice_Remind_Fail");
    _failelabel.textColor = KDSRGBColor(233, 131, 0);
    _failelabel.font = [UIFont systemFontOfSize:14];
    // 添加一个手势
    UITapGestureRecognizer *failTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(failTap)];
    _failelabel.userInteractionEnabled = YES;
    [_failelabel addGestureRecognizer:failTap];
    [self.supView addSubview:_failelabel];
    [_failelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nextButton.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

#pragma mark --如何修改初始管理密码？
-(void)visibleBtn{
    self.selectBtn.selected = !self.selectBtn.selected;
    //更改按钮的颜色
    if (self.selectBtn.selected) {
        [self.nextButton setBackgroundColor:KDSRGBColor(0, 102, 161)];
    } else {
        [self.nextButton setBackgroundColor:KDSRGBColor(179, 200, 230)];
    }
}
// 是否收到锁端的语音提示
- (void)visibleBtn:(UIButton *)sender {
    NSLog(@"是否收到锁端的语音提示");
    sender.selected = !sender.selected;
    //更改按钮的颜色
    if (sender.selected) {
        [self.nextButton setBackgroundColor:KDSRGBColor(0, 102, 161)];
    } else {
        [self.nextButton setBackgroundColor:KDSRGBColor(179, 200, 230)];
    }
}

- (void)supportedHomeRoutersClickTap:(UITapGestureRecognizer *)btn
{
    KDSVideoWiFiLockUpDataAdminiPwdVC *vc = [KDSVideoWiFiLockUpDataAdminiPwdVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

///下一步
- (void)nextBtnClick:(UIButton *)sender

{
    if (!self.selectBtn.selected) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    if (![KDSUserManager sharedManager].netWorkIsWiFi) {
        weakSelf.alertView.animation = nil;
        weakSelf.alertView.addDevicecontainerView.frame = CGRectMake(0, 0, KDSScreenWidth, KDSScreenHeight);
        weakSelf.successShowView.tipsLable.text = @"WiFi未连接";
        weakSelf.successShowView.image.image = [UIImage imageNamed:@"philips_dms_img_wifi_fail-1"];
        [weakSelf.successShowView.image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@150);
            make.width.equalTo(@52);
        }];
        weakSelf.successShowView.desLablel.text = @"手机未连接WiFi，无法添加设备";
        [weakSelf.successShowView.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [weakSelf.successShowView.rightBtn setTitle:@"去连接" forState:UIControlStateNormal];
        [weakSelf.alertView.addDevicecontainerView addSubview:self.successShowView];
        [weakSelf.successShowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(weakSelf.view);
        }];
        [weakSelf.alertView show];

        return;
    }

    if (![KDSTool determineWhetherTheAPPOpensTheLocation]) {///没有打开定位
        [self setBssi];
        KDSLog(@" kaslog ----666 没有打开定位");
        return;
    }
    
    
    KDSAddVideoWifiLockConfigureWiFiVC *vc = [KDSAddVideoWifiLockConfigureWiFiVC new];
    vc.lock = self.lock;
    vc.isAgainNetwork = self.isAgainNetwork;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)failTap {
   // 跳转到如何修改管理员密码
    KDSBleAndWiFiForgetAdminPwdVC  *forgetVC = [KDSBleAndWiFiForgetAdminPwdVC new];
    [self.navigationController pushViewController:forgetVC animated:YES];
    
}

- (void)navRightClick
{
    KDSXMMediaLockHelpVC *vc = [KDSXMMediaLockHelpVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)networkReachabilityStatusDidChange:(NSNotification *)noti
{
    NSNumber *number = noti.userInfo[AFNetworkingReachabilityNotificationStatusItem];
    AFNetworkReachabilityStatus status = number.integerValue;
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWWAN://2G,3G,4G...
            [KDSUserManager sharedManager].netWorkIsWiFi = NO;
            [KDSUserManager sharedManager].netWorkIsAvailable = YES;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi://wifi网络
            [KDSUserManager sharedManager].netWorkIsWiFi = YES;
            [KDSUserManager sharedManager].netWorkIsAvailable = YES;
            break;
        case AFNetworkReachabilityStatusNotReachable://无网络
            [KDSUserManager sharedManager].netWorkIsAvailable = NO;
            [KDSUserManager sharedManager].netWorkIsWiFi = NO;
            break;
        default://未识别的网络/不可达的网络
            break;
    }
}

#pragma mark - 通知中心

- (void)applicationBecomeActive:(NSNotification *)no {
    [self setBssi];
}

- (void)dealloc {
    [KDSNotificationCenter removeObserver:self];
}

- (void)setBssi
{
    [[KDSAMapLocationManager sharedManager] initWithLocationManager];
}

- (void)showAlerterView
{
    __weak typeof(self) weakSelf = self;
    if (![KDSUserManager sharedManager].netWorkIsWiFi) {
        weakSelf.alertView.animation = nil;
        weakSelf.alertView.addDevicecontainerView.frame = CGRectMake(0, 0, KDSScreenWidth, KDSScreenHeight);
        [weakSelf.alertView.addDevicecontainerView addSubview:self.successShowView];
        [weakSelf.successShowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(weakSelf.view);
        }];
        [weakSelf.alertView show];


        return;
    }
    if (![KDSTool determineWhetherTheAPPOpensTheLocation]) {///没有打开定位
        [self setBssi];
        return;
    }
}

#pragma mark  -  lazy
- (PLPDistributionNetworkPopupsView *)successShowView
{
    __weak typeof(self) weakSelf = self;
    if (_successShowView == nil) {
        _successShowView = [[PLPDistributionNetworkPopupsView alloc] init];
        _successShowView.cancelBtnClickBlock = ^{//取消
            [weakSelf.alertView hide];
            KDSLog(@" xxxx  点击了取消");
        };
        _successShowView.settingBtnClickBlock = ^{//连接
            [weakSelf.alertView hide];
        [KDSTool openSettingsURLString];
        KDSLog(@" xxxx  点击了重新连接");
        };
    }
    return _successShowView;
}

- (SYAlertView *)alertView
{
    if (_alertView == nil) {
        _alertView = [[SYAlertView alloc] init];
        _alertView.isAnimation = YES;
        _alertView.userInteractionEnabled = YES;
    }
    return _alertView;
}

@end
