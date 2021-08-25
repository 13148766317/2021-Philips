//
//  KDSAddVideoWifiLockConfigureWiFiVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2020/9/7.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSAddVideoWifiLockConfigureWiFiVC.h"
#import "KDSXMMediaLockHelpVC.h"
#import "KDSHomeRoutersVC.h"
#import "KDSAMapLocationManager.h"
#import "KDSAccordDistributionNetworkVC.h"
#import "KDSAddVideoWifiLockStep5VC.h"
#import <NetworkExtension/NetworkExtension.h>
@interface KDSAddVideoWifiLockConfigureWiFiVC ()
@property (nonatomic, strong) UIButton *connectBtn;
@property (nonatomic, strong) UIView *supView;
///Wi-Fi名称输入框
@property (nonatomic, strong) UITextField *wifiNametf;
///密码输入框
@property (nonatomic, strong) UITextField *pwdtf;
///明文切换的按钮
@property (nonatomic, strong) UIButton *pwdPlaintextSwitchingBtn;
@property (nonatomic, strong) UILabel *tipsLb8;
@property (nonatomic, strong) UIView *routerProtocolView;
///手动编辑前的wifi的ssid
@property (nonatomic, strong) NSString *wifiNametemp;
///wifi的bssid
@property (nonatomic, strong) NSString *bssidLb;

@property (nonatomic, strong) UIButton *nextBtn;

@end

///label之间多行显示的行间距
#define labelWidth 3

@implementation KDSAddVideoWifiLockConfigureWiFiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationTitleLabel.text = Localized(@"addDoorLockwifi");
    [self setRightButton];
    [self.rightButton setImage:[UIImage imageNamed:@"philips_icon_help"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [self setupUI];
    [self getWifiList];
    [self scanWifiInfos];
    
    self.pwdtf.secureTextEntry = YES; // 默认密码为密文
}


//  获取wifi 列表
- (void)getWifiList {

    if (!([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)) {return;}
    
    dispatch_queue_t queue = dispatch_queue_create("com.leopardpan.HotspotHelper", 0);
    [NEHotspotHelper registerWithOptions:nil queue:queue handler: ^(NEHotspotHelperCommand * cmd) {
        if(cmd.commandType == kNEHotspotHelperCommandTypeFilterScanList) {
            for (NEHotspotNetwork* network  in cmd.networkList) {
                NSLog(@"xxx-zhu获取到的wifi列表network.SSID = %@",network.SSID);
            }
        }
    }];
}


- (void)scanWifiInfos{
    NSLog(@"1.Start");

    NSMutableDictionary* options = [[NSMutableDictionary alloc] init];
    [options setObject:@"EFNEHotspotHelperDemo" forKey: kNEHotspotHelperOptionDisplayName];
    dispatch_queue_t queue = dispatch_queue_create("EFNEHotspotHelperDemo", NULL);

    NSLog(@"2.Try");
    BOOL returnType = [NEHotspotHelper registerWithOptions: options queue: queue handler: ^(NEHotspotHelperCommand * cmd) {

        NSLog(@"4.Finish");
        NEHotspotNetwork* network;
        if (cmd.commandType == kNEHotspotHelperCommandTypeEvaluate || cmd.commandType == kNEHotspotHelperCommandTypeFilterScanList) {
            // 遍历 WiFi 列表，打印基本信息
            for (network in cmd.networkList) {
                NSString* wifiInfoString = [[NSString alloc] initWithFormat: @"---------------------------\nSSID: %@\nMac地址: %@\n信号强度: %f\nCommandType:%ld\n---------------------------\n\n", network.SSID, network.BSSID, network.signalStrength, (long)cmd.commandType];
                NSLog(@"%@", wifiInfoString);

                // 检测到指定 WiFi 可设定密码直接连接
                if ([network.SSID isEqualToString: @"测试 WiFi"]) {
                    [network setConfidence: kNEHotspotHelperConfidenceHigh];
                    [network setPassword: @"123456789"];
                    NEHotspotHelperResponse *response = [cmd createResponse: kNEHotspotHelperResultSuccess];
                    NSLog(@"Response CMD: %@", response);
                    [response setNetworkList: @[network]];
                    [response setNetwork: network];
                    [response deliver];
                }
            }
        }
    }];

    // 注册成功 returnType 会返回一个 Yes 值，否则 No
    NSLog(@"3.Result: %@", returnType == YES ? @"Yes" : @"No");
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
    Circle2.backgroundColor = KDSRGBColor(0, 102, 161);
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
        make.width.equalTo(@50);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(Circle1.mas_right);
    }];

    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = KDSRGBColor(0, 102, 161);

    [topView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        //  make.width.equalTo(@50);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(Circle2.mas_right);
        make.right.equalTo(centerCircle.mas_left);
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

    UIImageView *wifiIcon = [UIImageView new];
    //philips_dms_img_wifi 图片名称
    wifiIcon.image = [UIImage imageNamed:@"philips_dms_img_wifi"];
    [self.supView addSubview:wifiIcon];
    [wifiIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(30);
        make.height.equalTo(@56);
        make.width.equalTo(@80);
        make.centerX.equalTo(self.supView.mas_centerX);
    }];
    //添加支持路由器的频段
    UIView *supportView = [UIView new];
    // supportView.backgroundColor = [UIColor greenColor];
    [self.supView addSubview:supportView];
    [supportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wifiIcon.mas_bottom).offset(40);
        make.width.equalTo(@80);
        make.height.equalTo(@25);
        make.centerX.equalTo(self.supView.mas_centerX).offset(-50);
    }];
    UIView *NosupportView = [UIView new];
    // NosupportView.backgroundColor = [UIColor greenColor];
    [self.supView addSubview:NosupportView];
    [NosupportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wifiIcon.mas_bottom).offset(40);
        make.width.equalTo(@80);
        make.height.equalTo(@25);
        make.centerX.equalTo(self.supView.mas_centerX).offset(50);
    }];
    //图片加文字
    UIImageView *supporImg = [UIImageView new];
    supporImg.image = [UIImage imageNamed:@"philips_dms_icon_support"];
    [self.supView addSubview:supporImg];
    [supporImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@20);
        make.centerY.equalTo(supportView.mas_centerY);
        make.left.equalTo(supportView.mas_left).offset(0);
    }];
    UILabel *tipslabel = [UILabel new];
    tipslabel.text = Localized(@"2.4G");
    tipslabel.font = [UIFont systemFontOfSize:18 weight:0.3];
    [supportView addSubview:tipslabel];

    [tipslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(supportView.mas_centerY);
        make.left.equalTo(supporImg.mas_right).offset(5);
    }];
    UILabel *hzlabel = [UILabel new];
    hzlabel.text = Localized(@"HZ");
    hzlabel.font = [UIFont systemFontOfSize:10];
    [supportView addSubview:hzlabel];

    [hzlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(supportView.mas_centerY).offset(3);
        make.left.equalTo(tipslabel.mas_right).offset(0);
    }];
    //图片加文字
    UIImageView *NosupporImg = [UIImageView new];
    NosupporImg.image = [UIImage imageNamed:@"philips_dms_img_doesnotsupport"];
    [self.supView addSubview:NosupporImg];
    [NosupporImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@20);
        make.centerY.equalTo(NosupportView.mas_centerY);
        make.left.equalTo(NosupportView.mas_left).offset(0);
    }];
    UILabel *Notipslabel = [UILabel new];
    Notipslabel.text = Localized(@"5G");
    Notipslabel.font = [UIFont systemFontOfSize:18 weight:0.3];
    [NosupportView addSubview:Notipslabel];

    [Notipslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(NosupportView.mas_centerY);
        make.left.equalTo(NosupporImg.mas_right).offset(5);
    }];
    UILabel *Nohzlabel = [UILabel new];
    Nohzlabel.text = Localized(@"HZ");
    Nohzlabel.font = [UIFont systemFontOfSize:10];
    [NosupportView addSubview:Nohzlabel];
    [Nohzlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(NosupportView.mas_centerY).offset(3);
        make.left.equalTo(Notipslabel.mas_right).offset(0);
    }];

    // 添加输入框
    UIView *wifiInput = [UIView new];
    wifiInput.layer.masksToBounds = YES;
    wifiInput.layer.borderWidth = 1;
    wifiInput.layer.borderColor =  KDSRGBColor(0, 102, 161).CGColor;
    [self.supView addSubview:wifiInput];
    [wifiInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(supportView.mas_bottom).offset(50);
        make.height.equalTo(@44);
        make.left.equalTo(self.supView).offset(15);
        make.right.equalTo(self.supView).offset(-15);
    }];
    // 添加输入视图的 UI
    UIImageView *wifiNameIconImg = [UIImageView new];
    // 进行图片更换
    wifiNameIconImg.image = [UIImage imageNamed:@"philips_dms_icon_wifi"];
    [self.supView addSubview:wifiNameIconImg];
    [wifiNameIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.left.equalTo(wifiInput.mas_left).offset(10);
        make.centerY.equalTo(wifiInput.mas_centerY);
    }];
    _wifiNametf = [UITextField new];
    _wifiNametf.placeholder = @"";
    _wifiNametf.clearButtonMode = UITextFieldViewModeAlways;
    _wifiNametf.textAlignment = NSTextAlignmentLeft;
    _wifiNametf.font = [UIFont systemFontOfSize:13];
    _wifiNametf.textColor = UIColor.blackColor;
    //取消默认大写属性
    _wifiNametf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_wifiNametf addTarget:self action:@selector(wifiNametextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.supView addSubview:_wifiNametf];
    [_wifiNametf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.left.equalTo(wifiNameIconImg.mas_right).offset(20);
        make.centerY.equalTo(wifiInput.mas_centerY);
        make.right.equalTo(wifiInput.mas_right).offset(40);
    }];
    UIImageView *pullImg = [UIImageView new];
    //图片名称更换 没有下拉
    //  pullImg.image = [UIImage imageNamed:@"philips_dms_icon_cbb"];
    [wifiInput addSubview:pullImg];
    [pullImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@20);
        make.right.equalTo(wifiInput.mas_right).offset(-10);
        make.centerY.equalTo(wifiInput.mas_centerY);
    }];
    // 添加输入框
    UIView *passwordInput = [UIView new];
    passwordInput.layer.masksToBounds = YES;
    passwordInput.layer.borderWidth = 1;
    passwordInput.layer.borderColor =  KDSRGBColor(0, 102, 161).CGColor;
    [self.supView addSubview:passwordInput];
    [passwordInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wifiInput.mas_bottom).offset(20);
        make.height.equalTo(@44);
        make.left.equalTo(self.supView).offset(15);
        make.right.equalTo(self.supView).offset(-15);
    }];

    UIImageView *pwdIconImg = [UIImageView new];
    pwdIconImg.image = [UIImage imageNamed:@"philips_dms_icon_password"];
    [self.supView addSubview:pwdIconImg];
    [pwdIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.left.equalTo(passwordInput.mas_left).offset(10);
        make.centerY.equalTo(passwordInput.mas_centerY);
    }];

    self.pwdPlaintextSwitchingBtn = [UIButton new];
    [self.pwdPlaintextSwitchingBtn setImage:[UIImage imageNamed:@"philips_login_icon_hidden"] forState:UIControlStateNormal];
    [self.pwdPlaintextSwitchingBtn setImage:[UIImage imageNamed:@"philips_dms_icon_display"] forState:UIControlStateSelected];
    [self.pwdPlaintextSwitchingBtn addTarget:self action:@selector(plaintextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.supView addSubview:self.pwdPlaintextSwitchingBtn];
    [self.pwdPlaintextSwitchingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.centerY.equalTo(passwordInput.mas_centerY);
        make.right.equalTo(passwordInput.mas_right).offset(-20);
    }];
    _pwdtf = [UITextField new];
    _pwdtf.placeholder = Localized(@"Enter_Your_PIN");
    _pwdtf.secureTextEntry = NO;
    _pwdtf.keyboardType = UIKeyboardTypeDefault;
    _pwdtf.borderStyle = UITextBorderStyleNone;
    _pwdtf.textAlignment = NSTextAlignmentLeft;
    _pwdtf.font = [UIFont systemFontOfSize:13];
    _pwdtf.textColor = UIColor.blackColor;
    //取消默认大写属性
    _pwdtf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_pwdtf addTarget:self action:@selector(pwdtextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.supView addSubview:_pwdtf];
    [_pwdtf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.centerY.equalTo(passwordInput.mas_centerY);
        make.left.equalTo(pwdIconImg.mas_right).offset(20);
        make.right.equalTo(self.pwdPlaintextSwitchingBtn.mas_left);
    }];

    UILabel *desLable = [UILabel new];
    desLable.text = Localized(@"Support_WiFI_Des");
    desLable.font = [UIFont systemFontOfSize:14];
    [self.supView addSubview:desLable];
    [desLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordInput.mas_bottom).offset(5);
        make.left.equalTo(passwordInput.mas_left);
    }];

    _nextBtn = [UIButton new];
    _nextBtn.backgroundColor = KDSRGBColor(179, 200, 230);
    [_nextBtn setTitle:Localized(@"下一步") forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(confirmBtnClicl:) forControlEvents:UIControlEventTouchUpInside];
    [self.supView addSubview:_nextBtn];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.left.equalTo(self.supView).offset(15);
        make.right.equalTo(self.supView).offset(-15);
        make.bottom.equalTo(self.supView).offset(-90);
    }];

    [[KDSAMapLocationManager sharedManager] initWithLocationManager];
    if ([KDSAMapLocationManager sharedManager].ssid.length != 0) {
        _wifiNametf.text = [KDSAMapLocationManager sharedManager].ssid;
        _wifiNametemp = _wifiNametf.text;
    } else {
        _wifiNametf.text = @"";
    }
    self.bssidLb = [KDSAMapLocationManager sharedManager].bssid;
}

- (void)dealloc {
    [KDSNotificationCenter removeObserver:self];
    KDSLog(@"tabbar销毁了")
}

#pragma mark 控件点击事件

- (void)navRightClick
{
    KDSXMMediaLockHelpVC *vc = [KDSXMMediaLockHelpVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

///明文切换
- (void)plaintextClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.pwdtf.secureTextEntry = NO;
    } else {
        self.pwdtf.secureTextEntry = YES;
    }
}

///wifi账户的名称(32个字节)
- (void)wifiNametextFieldDidChange:(UITextField *)textField {
    KDSLog(@"监听到 wifi 输入  ");
    if (textField.text.length > 0) {
        [self.nextBtn setBackgroundColor:KDSRGBColor(0, 102, 161)];
    } else {
        [self.nextBtn setBackgroundColor:KDSRGBColor(179, 200, 230)];
    }

    if (textField.text.length > 32) {
        textField.text = [textField.text substringToIndex:12];
        [MBProgressHUD showError:Localized(@"Error_WiFI_CheckUser32_Message")];
    }
}

///wifi账户的名称的密码（64个字节）
- (void)pwdtextFieldDidChange:(UITextField *)textField {
    KDSLog(@"xxxx  监听到 wifi 输入");
    if (textField.text.length > 0) {
        [self.nextBtn setBackgroundColor:KDSRGBColor(0, 102, 161)];
    } else {
        [self.nextBtn setBackgroundColor:KDSRGBColor(179, 200, 230)];
    }

    if (textField.text.length > 64) {
        textField.text = [textField.text substringToIndex:12];
        [MBProgressHUD showError:Localized(@"Error_WiFI_CheckUser64_Message")];
    }
}
///确认入网按钮
- (void)confirmBtnClicl:(UIButton *)btn
{
    NSLog(@"------ap配网-----");

    if (self.wifiNametf.text.length == 0 && [self.wifiNametf.text isEqualToString:@""]) {
        [MBProgressHUD showError:Localized(@"Error_WIFi_CheckUser0_Message")];
        return;
    }
    if (self.pwdtf.text.length == 0) {
        [MBProgressHUD showError:Localized(@"Error_WIFi_CheckUser0pwd_Message")];
        return;
    }
    KDSAddVideoWifiLockStep5VC *vc = [KDSAddVideoWifiLockStep5VC new];
    vc.ssid = self.wifiNametf.text;
    vc.pwd = self.pwdtf.text;
    vc.lock = self.lock;
    vc.isAgainNetwork = self.isAgainNetwork;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --查看门锁wifi支持的家庭路由器
- (void)supportedHomeRoutersClickTap:(UITapGestureRecognizer *)btn
{
    KDSHomeRoutersVC *VC = [KDSHomeRoutersVC new];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark --键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    //取出键盘动画的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //取得键盘最后的frame
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.connectBtn.frame.size.height;
    NSLog(@"键盘上移的高度：%f-----取出键盘动画时间：%f", transformY, duration);
    [UIView animateWithDuration:duration animations:^{
        [self.connectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipsLb8.mas_bottom).offset(20);
            make.width.equalTo(@200);
            make.height.equalTo(@44);
            make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        }];
    }];
}
#pragma mark --键盘收回
- (void)keyboardDidHide:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.connectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@200);
            make.height.equalTo(@44);
            make.bottom.mas_equalTo(self.routerProtocolView.mas_top).offset(KDSScreenHeight < 667 ? -20 : -40);
            make.centerX.mas_equalTo(self.supView.mas_centerX).offset(0);
        }];
    }];
}
- (void)setLabelSpace:(UILabel *)label withSpace:(CGFloat)space withFont:(UIFont *)font  {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = space; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{ NSFontAttributeName: font, NSParagraphStyleAttributeName: paraStyle, NSKernAttributeName: @0.0f };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:label.text attributes:dic];
    label.attributedText = attributeStr;
}

@end
