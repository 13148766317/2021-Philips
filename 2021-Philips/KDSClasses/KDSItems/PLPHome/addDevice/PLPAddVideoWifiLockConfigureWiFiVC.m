//
//  PLPAddVideoWifiLockConfigureWiFiVC.m
//  2021-Philips
//
//  Created by kaadas on 2021/4/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPAddVideoWifiLockConfigureWiFiVC.h"
#import "KDSXMMediaLockHelpVC.h"
#import "KDSHomeRoutersVC.h"
#import "KDSAMapLocationManager.h"
#import "KDSAccordDistributionNetworkVC.h"
#import "KDSAddVideoWifiLockStep5VC.h"

@interface PLPAddVideoWifiLockConfigureWiFiVC ()
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

@end

@implementation PLPAddVideoWifiLockConfigureWiFiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationTitleLabel.text = Localized(@"连接wifi");
    [self setRightButton];
    [self.rightButton setImage:[UIImage imageNamed:@"icon_help"] forState:UIControlStateNormal];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];

    // [self setUI];
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
    // 添加顶部的滚动条
    UIView *topView =  [UIView  new];
    topView.backgroundColor = UIColor.grayColor;
    [self.supView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.right.top.equalTo(self.supView);
    }];
    UIImageView *wifiIcon = [UIImageView new];
    //philips_dms_img_wifi 图片名称
    wifiIcon.image = [UIImage imageNamed:@"home_icon_wifi"];
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
    supporImg.image = [UIImage imageNamed:@"home_icon_wifi"];
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
    NosupporImg.image = [UIImage imageNamed:@"home_icon_wifi"];
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
    UIView *   wifiInput = [UIView new];
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
    wifiNameIconImg.image = [UIImage imageNamed:@"wifi-Lock-NameIcon"];
    [self.supView addSubview:wifiNameIconImg];
    [wifiNameIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.left.equalTo(wifiInput.mas_left).offset(10);
        make.centerY.equalTo(wifiInput.mas_centerY);
        
    }];
    _wifiNametf = [UITextField new];
    _wifiNametf.placeholder = @"PL6025";
    _wifiNametf.clearButtonMode = UITextFieldViewModeAlways;
    _wifiNametf.textAlignment = NSTextAlignmentLeft;
    _wifiNametf.font = [UIFont systemFontOfSize:13];
    _wifiNametf.textColor = UIColor.blackColor;
    //取消默认大写属性
    _wifiNametf.autocapitalizationType = UITextAutocapitalizationTypeNone;
   // [_wifiNametf addTarget:self action:@selector(wifiNametextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.supView addSubview:_wifiNametf];
    [_wifiNametf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.left.equalTo(wifiNameIconImg.mas_right).offset(20);
        make.centerY.equalTo(wifiInput.mas_centerY);
        make.right.equalTo(wifiInput.mas_right).offset(40);
    }];
    UIImageView * pullImg = [UIImageView new];
    //图片名称更换
    pullImg.image = [UIImage imageNamed:@"icon_back"];
    [wifiInput addSubview:pullImg];
    [pullImg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@20);
        make.right.equalTo(wifiInput.mas_right).offset(-10);
        make.centerY.equalTo(wifiInput.mas_centerY);
    }];
    // 添加输入框
    UIView *   passwordInput = [UIView new];
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
    pwdIconImg.image = [UIImage imageNamed:@"wifi-Lock-pwdIcon"];
    [self.supView addSubview:pwdIconImg];
    [pwdIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.left.equalTo(passwordInput.mas_left).offset(10);
        make.centerY.equalTo(passwordInput.mas_centerY);
      
    }];
    self.pwdPlaintextSwitchingBtn = [UIButton new];
    [self.pwdPlaintextSwitchingBtn setImage:[UIImage imageNamed:@"眼睛闭Default"] forState:UIControlStateNormal];
    [self.pwdPlaintextSwitchingBtn setImage:[UIImage imageNamed:@"眼睛开Default"] forState:UIControlStateSelected];
  //  [self.pwdPlaintextSwitchingBtn addTarget:self action:@selector(plaintextClick:) forControlEvents:UIControlEventTouchUpInside];
    self.pwdPlaintextSwitchingBtn.selected = YES;
    [self.supView addSubview:self.pwdPlaintextSwitchingBtn];
    [self.pwdPlaintextSwitchingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@18);
        make.height.equalTo(@11);
        make.centerY.equalTo(passwordInput.mas_centerY);
        make.right.equalTo(passwordInput.mas_right).offset(-20);
        
    }];
    _pwdtf = [UITextField new];
    _pwdtf.placeholder = @"请输入密码";
    _pwdtf.secureTextEntry = NO;
    _pwdtf.keyboardType = UIKeyboardTypeDefault;
    _pwdtf.borderStyle = UITextBorderStyleNone;
    _pwdtf.textAlignment = NSTextAlignmentLeft;
    _pwdtf.font = [UIFont systemFontOfSize:13];
    _pwdtf.textColor = UIColor.blackColor;
    //取消默认大写属性
    _pwdtf.autocapitalizationType = UITextAutocapitalizationTypeNone;
 //   [_pwdtf addTarget:self action:@selector(pwdtextFieldDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.supView addSubview:_pwdtf];
    [_pwdtf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.centerY.equalTo(passwordInput.mas_centerY);
        make.left.equalTo(pwdIconImg.mas_right).offset(20);
    }];

    UILabel * desLable = [UILabel new];
    desLable.text = @"仅支持2.4G网络，不支持使用公共网络";
    desLable.font = [UIFont systemFontOfSize:14];
    [self.supView addSubview:desLable];
    [desLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordInput.mas_bottom).offset(5);
        make.left.equalTo(passwordInput.mas_left);
    }];

    UIButton  * nextBtn = [UIButton new];
    nextBtn.backgroundColor = KDSRGBColor(0, 102, 161);
    [nextBtn setTitle:Localized(@"下一步") forState:UIControlStateNormal];
    [nextBtn  addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.supView addSubview:nextBtn];
    [nextBtn   mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.left.equalTo(self.supView).offset(15);
        make.right.equalTo(self.supView).offset(-15);
        make.bottom.equalTo(self.supView).offset(-90);
    }];
    
}

#pragma mark - 点击了一下步

- (void)nextBtnClick{
    KDSLog(@"点击了进行进行下一步");
}
- (void)setUI
{
    self.supView = [UIView new];
    self.supView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.supView];
    [self.supView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];

    ///第三步
    UILabel *tipMsgLabe1 = [UILabel new];
    tipMsgLabe1.text = @"第四步：配置连接Wi-Fi ";
    tipMsgLabe1.font = [UIFont systemFontOfSize:18];
    tipMsgLabe1.textColor = UIColor.blackColor;
    tipMsgLabe1.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tipMsgLabe1];
    [tipMsgLabe1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(KDSScreenHeight > 667 ? 51 : 20);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.view).offset(KDSScreenWidth / 4);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    UILabel *tipMsgLabe = [UILabel new];
    tipMsgLabe.text = @"① 请输入要连接的Wi-Fi信息";
    tipMsgLabe.font = [UIFont systemFontOfSize:14];
    tipMsgLabe.textColor = KDSRGBColor(126, 126, 126);
    tipMsgLabe.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tipMsgLabe];
    [tipMsgLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipMsgLabe1.mas_bottom).offset(KDSScreenHeight < 667 ? 20 : 35);
        make.height.mas_equalTo(16);
        make.left.mas_equalTo(self.view).offset(KDSScreenWidth / 4);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];

    UILabel *tipMsg1Labe = [UILabel new];
    tipMsg1Labe.text = @"② 暂不支持5G频段的Wi-Fi以及酒店机场需认证的Wi-Fi";
    tipMsg1Labe.font = [UIFont systemFontOfSize:14];
    tipMsg1Labe.textColor = KDSRGBColor(126, 126, 126);
    tipMsg1Labe.textAlignment = NSTextAlignmentLeft;
    tipMsg1Labe.numberOfLines = 0;

    [self.view addSubview:tipMsg1Labe];
    [tipMsg1Labe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipMsgLabe.mas_bottom).offset(0);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(self.view.mas_left).offset(KDSScreenWidth / 4);
        make.right.mas_equalTo(self.view.mas_right).offset(-(KDSScreenWidth / 4));
    }];
    
    
    
    UIView *line = [UIView new];
    line.backgroundColor = KDSRGBColor(220, 220, 220);
    [_supView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipMsg1Labe.mas_bottom).offset(70);
        make.left.equalTo(_supView.mas_left).offset(30);
        make.right.equalTo(_supView.mas_right).offset(-30);
        make.height.equalTo(@1);
    }];
    
    
    
    UIImageView *wifiNameIconImg = [UIImageView new];
    wifiNameIconImg.image = [UIImage imageNamed:@"wifi-Lock-NameIcon"];
    [self.supView addSubview:wifiNameIconImg];
    [wifiNameIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.left.mas_equalTo(self.supView.mas_left).offset(33);
        make.bottom.mas_equalTo(line.mas_bottom).offset(-5);
    }];
    _wifiNametf = [UITextField new];
    _wifiNametf.placeholder = @"输入区分大小写";
    _wifiNametf.clearButtonMode = UITextFieldViewModeAlways;
    _wifiNametf.textAlignment = NSTextAlignmentLeft;
    _wifiNametf.font = [UIFont systemFontOfSize:13];
    _wifiNametf.textColor = UIColor.blackColor;
    //取消默认大写属性
    _wifiNametf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_wifiNametf addTarget:self action:@selector(wifiNametextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.supView addSubview:_wifiNametf];
    [_wifiNametf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wifiNameIconImg.mas_right).offset(7);
        make.right.mas_equalTo(self.supView.mas_right).offset(-25.0);
        make.bottom.mas_equalTo(line.mas_bottom).offset(0);
        make.height.equalTo(@30);
    }];
    UIView *line2 = [UIView new];
    line2.backgroundColor = KDSRGBColor(220, 220, 220);
    [self.supView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(54);
        make.left.equalTo(_supView.mas_left).offset(30);
        make.right.equalTo(_supView.mas_right).offset(-30);
        make.height.equalTo(@1);
    }];
    
    
    self.tipsLb8 = [UILabel new];
    self.tipsLb8.text = @"请使用手机连接2.4G Wi-Fi";
    self.tipsLb8.textColor = KDSRGBColor(31, 150, 247);
    self.tipsLb8.textAlignment = NSTextAlignmentLeft;
    self.tipsLb8.font = [UIFont systemFontOfSize:12];
    [self.supView addSubview:self.tipsLb8];
    [self.tipsLb8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.supView.mas_left).offset(30);
        make.height.equalTo(@20);
        make.top.equalTo(line2.mas_bottom).offset(10);
        make.right.equalTo(self.supView.mas_right).offset(-20);
    }];

    UIImageView *pwdIconImg = [UIImageView new];
    pwdIconImg.image = [UIImage imageNamed:@"wifi-Lock-pwdIcon"];
    [self.supView addSubview:pwdIconImg];
    [pwdIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.left.mas_equalTo(self.supView.mas_left).offset(33);
        make.bottom.mas_equalTo(line2.mas_bottom).offset(-5);
    }];
    
    self.pwdPlaintextSwitchingBtn = [UIButton new];
    [self.pwdPlaintextSwitchingBtn setImage:[UIImage imageNamed:@"眼睛闭Default"] forState:UIControlStateNormal];
    [self.pwdPlaintextSwitchingBtn setImage:[UIImage imageNamed:@"眼睛开Default"] forState:UIControlStateSelected];
    [self.pwdPlaintextSwitchingBtn addTarget:self action:@selector(plaintextClick:) forControlEvents:UIControlEventTouchUpInside];
    self.pwdPlaintextSwitchingBtn.selected = YES;
    [self.supView addSubview:self.pwdPlaintextSwitchingBtn];
    [self.pwdPlaintextSwitchingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@18);
        make.height.equalTo(@11);
        make.right.mas_equalTo(self.supView.mas_right).offset(-25.0);
        make.bottom.mas_equalTo(line2.mas_bottom).offset(-5);
    }];
    _pwdtf = [UITextField new];
    _pwdtf.placeholder = @"请输入密码";
    _pwdtf.secureTextEntry = NO;
    _pwdtf.keyboardType = UIKeyboardTypeDefault;
    _pwdtf.borderStyle = UITextBorderStyleNone;
    _pwdtf.textAlignment = NSTextAlignmentLeft;
    _pwdtf.font = [UIFont systemFontOfSize:13];
    _pwdtf.textColor = UIColor.blackColor;
    //取消默认大写属性
    _pwdtf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_pwdtf addTarget:self action:@selector(pwdtextFieldDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.supView addSubview:_pwdtf];
    [_pwdtf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pwdIconImg.mas_right).offset(7);
        make.right.mas_equalTo(self.pwdPlaintextSwitchingBtn.mas_left).offset(-5);
        make.bottom.mas_equalTo(line2.mas_bottom).offset(0);
        make.height.equalTo(@30);
    }];

    self.routerProtocolView = [UIView new];
    self.routerProtocolView.backgroundColor = UIColor.clearColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(supportedHomeRoutersClickTap:)];
    [self.routerProtocolView addGestureRecognizer:tap];
    [self.supView addSubview:self.routerProtocolView];
    [self.routerProtocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.left.right.equalTo(self.supView);
        make.bottom.equalTo(self.supView.mas_bottom).offset(-45 - kBottomSafeHeight);
    }];

    UILabel *routerProtocolLb = [UILabel new];
    routerProtocolLb.text = @"查看门锁Wi-Fi支持家庭路由器";
    routerProtocolLb.textColor = KDSRGBColor(31, 150, 247);
    routerProtocolLb.textAlignment = NSTextAlignmentCenter;
    routerProtocolLb.font = [UIFont systemFontOfSize:14];
    [self.routerProtocolView addSubview:routerProtocolLb];
    //取消下划线
//    NSRange strRange = {0,[routerProtocolLb.text length]};
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:routerProtocolLb.text];
//    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
//    routerProtocolLb.attributedText = str;
    [routerProtocolLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.routerProtocolView);
    }];
    
    _connectBtn = [UIButton new];
    _connectBtn.backgroundColor = KDSRGBColor(31, 150, 247);
    _connectBtn.layer.masksToBounds = YES;
    _connectBtn.layer.cornerRadius = 22;
    [_connectBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_connectBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _connectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_connectBtn addTarget:self action:@selector(confirmBtnClicl:) forControlEvents:UIControlEventTouchUpInside];
    [self.supView addSubview:_connectBtn];
    [_connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.height.equalTo(@44);
        make.bottom.mas_equalTo(self.routerProtocolView.mas_top).offset(-20);
        make.centerX.mas_equalTo(self.supView.mas_centerX).offset(0);
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
@end
