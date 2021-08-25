//
//  KDSMediaLockInPutAdminPwdVC.m
//  2021-Philips
//  Created by zhaoxueping on 2020/9/18.
//  Copyright © 2020 com.Kaadas. All rights reserved.
#import "KDSMediaLockInPutAdminPwdVC.h"
#import "KDSXMMediaLockHelpVC.h"
#import "KDSAddWiFiLockFailVC.h"
#import "KDSBleAndWiFiUpDataAdminiPwdVC.h"
#import "KDSBleAssistant.h"
#import "NSData+JKEncrypt.h"
#import "NSString+extension.h"
#import "KDSBleAndWiFiForgetAdminPwdVC.h"
#import "NSTimer+KDSBlock.h"
#import "KDSAddWiFiLockSuccessVC.h"
#import "KDSAddVideoWifiLockStep1VC.h"
#import "KDSHttpManager+VideoWifiLock.h"
#import "KDSHomeViewController.h"
#import "PLPAddFailViewController.h"
#import "PLPDistributionNetworkPopupsView.h"
#import "SYAlertView.h"

@interface KDSMediaLockInPutAdminPwdVC ()
///密码输入框
@property (nonatomic, strong) UITextField *pwdTf;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIView *supView;

@property (nonatomic, assign) int inputPwdCount;
@property (nonatomic, strong) NSString *forgetPwdStr;
@property (nonatomic, strong) NSString *inputAgainStr;
///是否已经push过（只能执行一次）
@property (nonatomic, assign) BOOL ispushing;
@property (nonatomic, strong) MBProgressHUD *hud;

///添加成功之后弹出的提示设置开关的视图
@property (nonatomic, strong) PLPDistributionNetworkPopupsView *successShowView;
@property (nonatomic, strong) SYAlertView *alertView;

@end

@implementation KDSMediaLockInPutAdminPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.inputPwdCount = 0;
    self.ispushing = YES;
    self.navigationTitleLabel.text = Localized(@"Confirm_administrator_password");
    // [self setRightButton];
    // [self.rightButton setImage:[UIImage imageNamed:@"questionMark"] forState:UIControlStateNormal];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaLockBindStatus:) name:KDSMQTTEventNotification object:nil];
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
    centerCircle.backgroundColor = KDSRGBColor(0, 102, 161);
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
    Circle4.backgroundColor = KDSRGBColor(0, 102, 161);
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
        make.width.equalTo(@50);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(Circle2.mas_right);
    }];

    UIView *lineView3 = [UIView new];
    lineView3.backgroundColor = KDSRGBColor(0, 102, 161);

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

    UILabel *lable = [UILabel  new];
    lable.text = Localized(@"Enter_the_confirmation_password");
    lable.font = [UIFont systemFontOfSize:16];
    [_supView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(30);
        make.right.equalTo(self.supView.mas_right).offset(-15);
        make.left.equalTo(self.supView.mas_left).offset(15);
    }];
    //输入框
    UIView *inputView = [UIView new];
    inputView.layer.masksToBounds = YES;
    inputView.layer.borderWidth = 1;
    inputView.layer.cornerRadius = 5;
    inputView.layer.borderColor = KDSRGBColor(0, 102, 161).CGColor;
    [self.supView addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lable.mas_bottom).offset(30);
        make.left.equalTo(_supView.mas_left).offset(15);
        make.height.equalTo(@44);
        make.right.equalTo(_supView.mas_right).offset(-15);
    }];
    UIImageView *pwdIconImg = [UIImageView new];
    pwdIconImg.image = [UIImage imageNamed:@"wifi-Lock-pwdIcon"];
    [inputView addSubview:pwdIconImg];
    [pwdIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputView.mas_left).offset(KDSScreenHeight <= 667 ? 10 : 30);
        make.height.width.equalTo(@16);
        make.centerY.equalTo(inputView.mas_centerY);
    }];
    _pwdTf = [UITextField new];
    _pwdTf.placeholder = Localized(@"input6~12NumericPwd");
    _pwdTf.secureTextEntry = YES;
    _pwdTf.borderStyle = UITextBorderStyleNone;
    _pwdTf.textAlignment = NSTextAlignmentLeft;
    _pwdTf.keyboardType = UIKeyboardTypeNumberPad;
    _pwdTf.font = [UIFont systemFontOfSize:13];
    _pwdTf.textColor = UIColor.blackColor;
    [_pwdTf addTarget:self action:@selector(pwdtextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [inputView addSubview:_pwdTf];
    [_pwdTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pwdIconImg.mas_right).offset(7);
        make.right.mas_equalTo(_supView.mas_right).offset(-10);
        make.centerY.equalTo(inputView.mas_centerY);
        make.height.equalTo(@30);
    }];

    UIButton *visBtn = [UIButton new];
    [visBtn setBackgroundImage:[UIImage imageNamed:@"philips_login_icon_hidden"] forState:UIControlStateNormal];
    [visBtn setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_display"] forState:UIControlStateSelected];
    [visBtn addTarget:self action:@selector(visibleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:visBtn];
    [visBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputView.mas_right).offset(-10);
        make.height.width.equalTo(@20);
        make.centerY.equalTo(inputView.mas_centerY);
    }];

    //提示
    UILabel *desLable1 = [UILabel new];
    desLable1.text = Localized(@"Initial_password");
    desLable1.font = [UIFont systemFontOfSize:14];
    desLable1.textColor = KDSRGBColor(102, 102, 102);
    [self.supView addSubview:desLable1];
    [desLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_bottom).offset(5);
        make.left.equalTo(self.supView).offset(15);
    }];
    _nextBtn = [UIButton new];
    [_nextBtn setTitle:Localized(@"nextStep") forState:UIControlStateNormal];
    [_nextBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.nextBtn.userInteractionEnabled = NO;
    _nextBtn.backgroundColor = KDSRGBColor(179, 200, 230);
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.supView.mas_bottom).offset(-73);
        make.left.equalTo(self.supView.mas_left).offset(15);
        make.right.equalTo(self.supView.mas_right).offset(-15);
        make.height.equalTo(@44);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
    }];
    //提示
    UILabel *desLable = [UILabel new];
    desLable.text = Localized(@"Administrator_password_error");
    desLable.font = [UIFont systemFontOfSize:14];
    desLable.textColor = KDSRGBColor(233, 131, 0);
    UITapGestureRecognizer  * desTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(failTap)];
    [desLable  addGestureRecognizer:desTap];
    desLable.userInteractionEnabled = YES;
    [self.supView addSubview:desLable];
    [desLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nextBtn.mas_bottom).offset(5);
        make.height.equalTo(@30);
        make.centerX.equalTo(_supView.mas_centerX);
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:KDSMQTTEventNotification object:nil];
}

#pragma mark 控件点击事件
//- (void)navBackClick{
//     // 返回到首页
//    NSLog(@"zhushiqi返回到首页 ");
//    KDSHomeViewController  * home = [KDSHomeViewController new];
//    [self.navigationController pushViewController:home animated:YES];
//
//}

- (void)visibleBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.pwdTf.secureTextEntry = NO;
    } else {
        self.pwdTf.secureTextEntry = YES;
    }
}

- (void)navRightClick
{
    KDSXMMediaLockHelpVC *vc = [KDSXMMediaLockHelpVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)nextClick:(UIButton *)sender
{
    ///校验管理员密码是否正确
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:sender];
    [self performSelector:@selector(todoSomething:) withObject:sender afterDelay:0.5f];
}

- (void)todoSomething:(UIButton *)sender
{
    NSLog(@"是否点击验证管理员密码");
    self.hud = [MBProgressHUD showMessage:Localized(@"pleaseWait") toView:self.view];
    [self getRandomCodeWidthAdminPwd:self.pwdTf.text resultData:self.crcData];
}

- (void)getRandomCodeWidthAdminPwd:(NSString *)pwd resultData:(NSString *)data
{
    NSLog(@"收到讯美发过来的密码因子16进制字符串：%@", data);
    ///56字符长度的随机数A+8字符长度的CRC32+13字符长度字符串的eSN（WF开头）+ 2字符长度功能集共79个字符长度
    if (data.length >= 79) {
        //32个字节的（28字节随机数+4字节CRC）
        NSData *currentData = [KDSBleAssistant convertHexStrToData:[data substringToIndex:64]];
        NSLog(@"收到讯美发过来的密码因子配网过程将要开始pwd:%@,密码因子data:%@", pwd, currentData);
        if ([self.pwdTf.text isEqualToString:@"12345678"]) {
            UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"" message:@"门锁初始密码不能验证，\n 请修改门锁管理密码或重新输入" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *againInPutAction = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *changePasswordAction = [UIAlertAction actionWithTitle:@"修改密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                KDSBleAndWiFiUpDataAdminiPwdVC *vc = [KDSBleAndWiFiUpDataAdminiPwdVC new];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [changePasswordAction setValue:KDSRGBColor(164, 164, 164) forKey:@"titleTextColor"];
            [alerVC addAction:changePasswordAction];
            [alerVC addAction:againInPutAction];
            [self presentViewController:alerVC animated:YES completion:nil];
            return;
        }
        NSString *wifiSN = [data substringWithRange:NSMakeRange(64, 13)];
        NSString *string = @"";
        for (int i = 0; i < pwd.length; i++) {
            NSString *temstring = [NSString ToHex:[pwd substringWithRange:NSMakeRange(i, 1)].integerValue];
            string = [string stringByAppendingFormat:@"%02ld", (long)temstring.integerValue];
        }
        NSData *datastring = [KDSBleAssistant convertHexStrToData:string];
        NSString *aString = [[NSString alloc] initWithData:datastring encoding:NSUTF8StringEncoding];
        //key AES256后的值
        NSString *Haxi = [NSString sha256HashFor:aString];
        NSData *resultData = [currentData aesWifiLock256_decryptData:[KDSBleAssistant convertHexStrToData:Haxi]];
        int crc = [NSString data2Int:[resultData subdataWithRange:NSMakeRange(28, 4)]];
        //测试数据：随机数A
        int32_t randomCode = [[resultData subdataWithRange:NSMakeRange(0, 28)] crc32];
        ///添加到服务器用到的随机数A
        NSString *randomCodeData = [KDSBleAssistant convertDataToHexStr:[resultData subdataWithRange:NSMakeRange(0, 28)]];
        u_int8_t tt;///wifi的功能集
        NSData *functionSetData = [KDSBleAssistant convertHexStrToData:[data substringWithRange:NSMakeRange(77, 2)]];
        [functionSetData getBytes:&tt length:sizeof(tt)];
        long long int value = randomCode;
        Byte byte[4] = {};
        byte[3] = (Byte)((value >> 24) & 0xFF);
        byte[2] = (Byte)((value >> 16) & 0xFF);
        byte[1] = (Byte)((value >> 8) & 0xFF);
        byte[0] = (Byte)(value & 0xFF);
        if (randomCode != crc) {
            self.inputPwdCount++;
            NSLog(@"随机数生成的CRC：%d原始CRC：%d", randomCode, crc);
            NSString *messageStr = @"请输入正确的管理员密码，当错误超过5次需重新配网";
            self.forgetPwdStr = @"忘记密码";
            self.inputAgainStr = @"重新输入";
            if (self.inputPwdCount == 3) {
              //  messageStr = @"门锁管理密码验证已失败3次，超过5次门锁将退出配网";
            } else if (self.inputPwdCount == 4) {
              //  messageStr = @"门锁管理密码验证已失败4次，超过5次门锁将退出配网";
            } else if (self.inputPwdCount >= 5) {
                messageStr = @"已经输错5次， 请在门锁端修改管理员密码后， 重新配网";
                self.forgetPwdStr = @"确定";
                self.inputAgainStr = @"";
                //更新视图的布局
                self.successShowView.leftBtn.hidden = YES;
                
                [self.successShowView.rightBtn   mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.successShowView.holderview.mas_left).offset(12);
                    make.right.equalTo(self.successShowView.holderview.mas_right).offset(-12);
                }];
                
            }

            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.alertView.animation = nil;
                weakSelf.alertView.addDevicecontainerView.frame = CGRectMake(0, 0, KDSScreenWidth, KDSScreenHeight);
                //输入的描述
                weakSelf.successShowView.desLablel.text = messageStr;
                [weakSelf.successShowView.rightBtn setTitle:self.forgetPwdStr forState:UIControlStateNormal];
                [weakSelf.successShowView.leftBtn setTitle:self.inputAgainStr forState:UIControlStateNormal];
                [weakSelf.alertView.addDevicecontainerView addSubview:self.successShowView];
                [weakSelf.successShowView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.bottom.right.equalTo(weakSelf.view);
                }];
                [weakSelf.alertView show];

//                UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:nil message:messageStr preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction * forgetPwdAction = [UIAlertAction actionWithTitle:forgetPwdStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    if (self.inputPwdCount >= 5) {
//                        ///5次密码错误配网失败 //
//                        [self addDeviceFail];
//                    }else{
//                        ///忘记密码
//                        KDSBleAndWiFiForgetAdminPwdVC * vc = [KDSBleAndWiFiForgetAdminPwdVC new];
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }
//                }];
//                UIAlertAction * inputAgainAction = [UIAlertAction actionWithTitle:inputAgainStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    ///重新输入密码
//                    [self.hud   hideAnimated:YES];
//                }];
//                [inputAgainAction setValue:KDSRGBColor(164, 164, 164) forKey:@"titleTextColor"];
//                if (inputAgainStr.length > 0) {
//                    [alerVC addAction:inputAgainAction];
//                }
//                if (forgetPwdStr.length > 0) {
//                    [alerVC addAction:forgetPwdAction];
//                }
//                [self presentViewController:alerVC animated:YES completion:nil];
            });
        } else {
            ///拿到随机码、wifiSN、绑定设备
            // 视屏绑定成功 收到mqtt的响应后  已经将 P2P的密码保存起来了
            self.model.wifiSN = wifiSN;
            self.model.lockNickname = wifiSN;
            self.model.isAdmin = @"1";
            self.model.randomCode = randomCodeData;
            self.model.functionSet = @(tt).stringValue;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self bindWifiLockWithWifiSN:self.model randomCode:self.model.randomCode];
            });
        }
    } else {
        ///锁下发的密码因子（32+13SN+1功能集）数据错误
        [self addDeviceFail];
    }
}

- (void)bindWifiLockWithWifiSN:(KDSWifiLockModel *)wifiLockModel randomCode:(NSString *)randomCode
{
    NSMutableArray *hasBeensn = [NSMutableArray array];
    //代码分析
    
//    for (KDSLock *lock in [KDSUserManager sharedManager].locks) {
//        if (lock.wifiDevice && lock.wifiDevice.isAdmin.intValue == 1) {
//            [hasBeensn addObject:lock.wifiDevice.wifiSN];
//        }
//    }
    BOOL isContentWifiSN = [hasBeensn containsObject:wifiLockModel.wifiSN];
    ///XMMediawifi配网
    wifiLockModel.distributionNetwork = 3;
    if (isContentWifiSN) {
        ///主用户绑定的是相同的一个锁，更新锁信息
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[KDSHttpManager sharedManager] updateMediaBindWifiDevice:wifiLockModel uid:[KDSUserManager sharedManager].user.uid success:^{
                //处理请求 返回数据
                [self addSuccessWithModel:wifiLockModel];
            } error:^(NSError *_Nonnull error) {
                if (error.code != 202) {
                    //202    已绑定
                    [self addDeviceFail];
                }
            } failure:^(NSError *_Nonnull error) {
                [self addDeviceFail];
            }];
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[KDSHttpManager sharedManager] bindMediaWifiDevice:wifiLockModel uid:[KDSUserManager sharedManager].user.uid success:^{
                //处理请求 返回数据
                [self addSuccessWithModel:wifiLockModel];
            } error:^(NSError *_Nonnull error) {
                if (error.code != 202) {
                    //202    已绑定
                    [self addDeviceFail];
                }
            } failure:^(NSError *_Nonnull error) {
                [self addDeviceFail];
            }];
        });
    }
}

- (void)addDeviceFail
{
    [self.hud hideAnimated:YES];
    if (self.ispushing) {
        self.ispushing = NO;
        [[KDSHttpManager sharedManager] XMMediaBindFailWifiDevice:self.model uid:[KDSUserManager sharedManager].user.uid result:0 success:nil error:nil failure:nil];
        //  KDSAddWiFiLockFailVC * vc = [KDSAddWiFiLockFailVC new];
        PLPAddFailViewController *vc = [PLPAddFailViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)addSuccessWithModel:(KDSWifiLockModel *)wifiLockModel
{
    [self.hud hideAnimated:YES];
    if (self.ispushing) {
        self.ispushing = NO;
        KDSAddWiFiLockSuccessVC *vc = [KDSAddWiFiLockSuccessVC new];
        vc.model = wifiLockModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//- (void)navBackClick
//{
//    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"" message:@"确定重新开始配网吗？" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
//    }];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//            if ([controller isKindOfClass:[KDSAddVideoWifiLockStep1VC class]]) {
//                KDSAddVideoWifiLockStep1VC *A = (KDSAddVideoWifiLockStep1VC *)controller;
//                [self.navigationController popToViewController:A animated:YES];
//            }
//        }
//    }];

//    [cancelAction setValue:KDSRGBColor(164, 164, 164) forKey:@"titleTextColor"];
//    [alerVC addAction:cancelAction];
//    [alerVC addAction:okAction];
//    [self presentViewController:alerVC animated:YES completion:nil];
//}

- (void)pwdtextFieldDidChange:(UITextField *)textField
{
    KDSLog(@"xxxx ==输入的文字的改变事件=== ");
     if (textField.text.length >= 6) {
        self.nextBtn.userInteractionEnabled = YES;
        _nextBtn.backgroundColor = KDSRGBColor(0, 102, 161);
    }
    if (textField.text.length < 6) {
        _nextBtn.backgroundColor = KDSRGBColor(179, 200, 230);
        self.nextBtn.userInteractionEnabled = NO;
    }
    if (textField.text.length > 12) {
        textField.text = [textField.text substringToIndex:12];
        [MBProgressHUD showError:Localized(@"PwdLength6BitsAndNotMoreThan12bits")];
    }
}

#pragma mark --键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    //取出键盘动画的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //取得键盘最后的frame
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.nextBtn.frame.size.height;
    NSLog(@"键盘上移的高度：%f-----取出键盘动画时间：%f", transformY, duration);
//    [UIView animateWithDuration:duration animations:^{
//        [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.supView.mas_top).offset(220);
//            make.width.equalTo(@200);
//            make.height.equalTo(@44);
//            make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
//        }];
//    }];
}
#pragma mark --键盘收回

- (void)keyboardDidHide:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    [UIView animateWithDuration:duration animations:^{
//        [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.supView.mas_bottom).offset(-73);
//            make.width.equalTo(@200);
//            make.height.equalTo(@44);
//            make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
//        }];
//    }];
}

#pragma mark -- 视频锁绑定结果的通知（超时）
- (void)mediaLockBindStatus:(NSNotification *)noti
{
    MQTTSubEvent subevent = noti.userInfo[MQTTEventKey];
    if ([subevent isEqualToString:MQTTSubEventMdeiaLockBindErrorNotity]) {
        //不管超时还是其他错误，都结束配网且失败
        [self addDeviceFail];
    }
}

-(void)failTap{
    [MBProgressHUD  showError:@"管理员密码错误"];
}
#pragma mark  -  lazy
- (PLPDistributionNetworkPopupsView *)successShowView
{
    __weak typeof(self) weakSelf = self;
    if (_successShowView == nil) {
        _successShowView = [[PLPDistributionNetworkPopupsView alloc] init];
        _successShowView.cancelBtnClickBlock = ^{//重新输入
            [weakSelf.hud   hideAnimated:YES];
            [weakSelf.alertView hide];
            if (self.inputAgainStr.length > 0) {
                [weakSelf.alertView show];
            }
            if (self.forgetPwdStr.length > 0) {
                [weakSelf.alertView show];
            }
            KDSLog(@" xxxx 点击了重新输入密码  重新输入密码");
        };
        _successShowView.settingBtnClickBlock = ^{// 忘记密码
            [weakSelf.alertView hide];
            [weakSelf.hud   hideAnimated:YES];
            KDSLog(@" xxxx  点击了忘记密码");
            if ([weakSelf.forgetPwdStr isEqualToString:@"确定"]) {
                ///忘记密码
                KDSBleAndWiFiForgetAdminPwdVC *vc = [KDSBleAndWiFiForgetAdminPwdVC new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
             else {
                ///忘记密码
                KDSBleAndWiFiForgetAdminPwdVC *vc = [KDSBleAndWiFiForgetAdminPwdVC new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
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
