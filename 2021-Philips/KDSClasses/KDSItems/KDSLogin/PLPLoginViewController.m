//
//  PLPLoginViewController.m
//  2021-Philips
//
//  Created by kaadas on 2021/5/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPLoginViewController.h"
// 网络请求
#import "KDSHttpManager+Login.h"
#import "MBProgressHUD+MJ.h"
#import "KDSDBManager.h"
#import "KDSTabBarController.h"
#import "KDSNavigationController.h"
#import "XWCountryCodeController.h"
#import <objc/runtime.h>
// 立即注册  忘记密码
#import "PLPForgetPwdViewController.h"
#import "PLPSignUpViewController.h"
// 短信登录
#import "PLPLoginWIthMessage.h"
#import "PLPLoginWithWieiXin.h"
#import "KDSUserAgreementVC.h"
#import "KDSPrivacyPolicyVC.h"
//苹果登录
#import <AuthenticationServices/AuthenticationServices.h>
@interface PLPLoginViewController ()<UITextFieldDelegate,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
@property (strong, nonatomic)  UIView *supView;
///用户名的输入框
@property (strong, nonatomic)  UITextField *userNameTextField;
///密码的输入框
@property (strong, nonatomic)  UITextField *pwdTextField;
///登录按钮
@property (strong, nonatomic)  UIButton *loginBtn;
///注册按钮
@property (strong, nonatomic)  UIButton *registBtn;
///您还没有账号label
@property (strong, nonatomic)  UILabel *arlterLabel;
@property (nonatomic, strong) NSString *code;//国际代码
///忘记密码按钮
@property (strong, nonatomic)  UIButton *forgetPwdBtn;
///密码明文切换
@property (strong, nonatomic)  UIButton *visibleBtn;
@property (strong, nonatomic)  UILabel *countryLabel;
@property (strong, nonatomic)  UILabel *countryCode;
@property (strong, nonatomic)  UIButton *selectCountry;
//  获取绑定微信的电话号码
@property (strong,nonatomic) NSString  * WXTel ;

///是否同意协议按钮
@property (strong, nonatomic)  UIButton *agreeMentBtn;
///  隐私政策的按钮
@property (strong, nonatomic)  UIButton *privacyPolicyBtn;

@end

@implementation PLPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.code = @"86";
    //self.supView.backgroundColor = KDSRGBColor(17, 117, 231);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];

    [self setupUI];

    // 添加国家的选择事件
    UITapGestureRecognizer *selectCountryCodeTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCountryCodeClick:)];
    UITapGestureRecognizer *selectCountryCodeTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCountryCodeClick:)];

    self.countryLabel.userInteractionEnabled = YES;
    self.selectCountry.userInteractionEnabled = YES;

    [self.countryLabel addGestureRecognizer:selectCountryCodeTap1];
    [self.selectCountry addGestureRecognizer:selectCountryCodeTap2];
    //用户登录过 保存用户名
    NSArray<NSString *> *comps = [self.code componentsSeparatedByString:@"+"];
    NSString *account = [KDSTool getDefaultLoginAccount];
    if (comps.lastObject && [account hasPrefix:comps.lastObject]) {
        account = [account substringFromIndex:comps.lastObject.length];
    }
    if (comps.count > 0) {
        self.userNameTextField.text = account;
    } else {
        self.userNameTextField.placeholder = Localized(@"Login_Enter_Phone_Email");
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiChatOK) name:@"weiChatOK" object:NULL];
    
    self.pwdTextField.secureTextEntry =  YES;
}

// 设置UI
- (void)setupUI {
    _supView = [UIView new];
    [self.view addSubview:_supView];
    [_supView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // 背景图
    UIImageView *loginBg = [UIImageView new];
    [loginBg setImage:[UIImage imageNamed:@"loginBg"]];
    [_supView addSubview:loginBg];
    [loginBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_supView);
    }];
    //  logo
    UIImageView *logoImg = [UIImageView new];
    logoImg.image = [UIImage imageNamed:@"philips_login_logo"];
    [_supView addSubview:logoImg];

    [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_supView).offset(80);
        make.height.width.equalTo(@96);
        make.centerX.equalTo(_supView.mas_centerX);
    }];
    // 说明的文字
    UILabel *desLabel = [UILabel new];
    desLabel.text = @"Philips EasyKey+";
    desLabel.textColor = KDSRGBColor(0, 102, 161);
    desLabel.font = [UIFont systemFontOfSize:20 weight:0.3];
    [_supView addSubview:desLabel];

    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImg.mas_bottom).offset(80);
        make.centerX.equalTo(_supView.mas_centerX);
    }];
    UIView *usernameView = [UIView new];
    usernameView.backgroundColor = UIColor.whiteColor;
    usernameView.layer.masksToBounds = YES;
    usernameView.layer.cornerRadius = 3;
    [self.view addSubview:usernameView];
    [usernameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLabel.mas_bottom).offset(56);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@44);
    }];
    // 国家的编码
    _countryCode = [UILabel new];
    _countryCode.text = @"+86"; //设置一个默认的值
    // 添加国家的选择
    _countryLabel = [UILabel new];
    _countryLabel.text = @"中国";
    [usernameView addSubview:_countryLabel];
    [_countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(usernameView.mas_left).offset(15);
        make.width.equalTo(@35);
        make.top.bottom.equalTo(usernameView);
    }];

    _selectCountry = [UIButton new];
    [_selectCountry setBackgroundImage:[UIImage imageNamed:@"philips_login_icon_cbb"] forState:UIControlStateNormal];
    [usernameView addSubview:_selectCountry];
    [_selectCountry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@14);
        make.centerY.equalTo(usernameView.mas_centerY);
        make.left.equalTo(_countryLabel.mas_right).offset(10);
    }];
    _userNameTextField = [UITextField new];
    _userNameTextField.placeholder = Localized(@"Login_Enter_Phone_Email");
    _userNameTextField.delegate =self;
    // 添加监听事件
    [_userNameTextField addTarget:self action:@selector(nameTextChange) forControlEvents:UIControlEventEditingChanged];
    [usernameView addSubview:_userNameTextField];
    [_userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_selectCountry.mas_right).offset(15);
        make.top.bottom.right.equalTo(usernameView);
    }];

    UIView *passwordView = [UIView new];
    passwordView.backgroundColor = UIColor.whiteColor;
    passwordView.layer.masksToBounds = YES;
    passwordView.layer.cornerRadius = 3;
    [self.view addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(usernameView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@44);
    }];

    _pwdTextField = [UITextField new];
    _pwdTextField.placeholder = Localized(@"Login_Password");
    _pwdTextField.delegate =self;
    [_pwdTextField addTarget:self action:@selector(passwordTextChange) forControlEvents:UIControlEventEditingChanged];
    [passwordView addSubview:_pwdTextField];

    [_pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordView.mas_left).offset(15);
        make.top.bottom.equalTo(passwordView);
        make.right.equalTo(passwordView.mas_right).offset(-40);
    }];

    _visibleBtn = [UIButton new];
    [_visibleBtn setBackgroundImage:[UIImage imageNamed:@"philips_login_icon_display"] forState:UIControlStateNormal];
    [_visibleBtn setBackgroundImage:[UIImage imageNamed:@"philips_login_icon_hidden"] forState:UIControlStateSelected];
    [_visibleBtn addTarget:self action:@selector(visibleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [passwordView addSubview:_visibleBtn];

    [_visibleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordView.mas_centerY);
        make.height.width.equalTo(@20);
        make.right.equalTo(passwordView.mas_right).offset(-12);
    }];

    // 忘记密码立即注册
    _forgetPwdBtn = [UIButton  new];
    [_forgetPwdBtn setTitle:Localized(@"Login_ForgetPasword") forState:UIControlStateNormal];
    [_forgetPwdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_forgetPwdBtn setFont:[UIFont systemFontOfSize:14]];
    [_forgetPwdBtn setBackgroundColor:[UIColor clearColor]];
    [_forgetPwdBtn addTarget:self action:@selector(forgetPwd:) forControlEvents:UIControlEventTouchUpInside];
    [_supView addSubview:_forgetPwdBtn];
    [_forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).offset(8);
        make.left.equalTo(passwordView.mas_left);
        make.height.equalTo(@20);
    }];

    _registBtn = [UIButton  new];
    [_registBtn setTitle:Localized(@"Login_Register") forState:UIControlStateNormal];
    [_registBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_registBtn setFont:[UIFont systemFontOfSize:14]];
    [_registBtn setBackgroundColor:[UIColor clearColor]];
    [_registBtn addTarget:self action:@selector(registBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_supView addSubview:_registBtn];
    [_registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).offset(8);
        make.right.equalTo(passwordView.mas_right);
        make.height.equalTo(@20);
    }];

    // 登录的按钮
    _loginBtn = [UIButton new];
    [_loginBtn setBackgroundColor:KDSRGBColor(179, 200, 230)];
    [_loginBtn addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn setTitle:Localized(@"Login_Logining") forState:UIControlStateNormal];
    [_supView addSubview:_loginBtn];

    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@44);
    }];
 //  添加隐私政策 和用户协议
   _agreeMentBtn = [UIButton new];
   [_agreeMentBtn setTitle:Localized(@"Login_Usage") forState:UIControlStateNormal];
   [_agreeMentBtn setTitleColor:KDSRGBColor(0, 102, 161) forState:UIControlStateNormal];
   [_agreeMentBtn setFont:[UIFont systemFontOfSize:12]];
   [_agreeMentBtn  addTarget:self action:@selector(agreeMentBtn:) forControlEvents:UIControlEventTouchUpInside];
   [self.view addSubview:_agreeMentBtn];
   [_agreeMentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(_loginBtn.mas_bottom).offset(12);
       make.left.equalTo(self.view).offset(16);
       
   }];
    _privacyPolicyBtn = [UIButton new];
    [_privacyPolicyBtn setTitle:Localized(@"Login_Privacy") forState:UIControlStateNormal];
    [_privacyPolicyBtn setTitleColor:KDSRGBColor(0, 102, 161) forState:UIControlStateNormal];
    [_privacyPolicyBtn setFont:[UIFont systemFontOfSize:12]];
    [_privacyPolicyBtn  addTarget:self action:@selector(privacyPolicyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_privacyPolicyBtn];
    [_privacyPolicyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).offset(12);
        make.left.equalTo(_agreeMentBtn.mas_right).offset(16);
    }];
    UILabel * tipsLabel2 = [UILabel new];
    tipsLabel2.text =Localized(@"Login_And");
    tipsLabel2.font = [UIFont systemFontOfSize:12];
    tipsLabel2.textColor = KDSRGBColor(102, 102, 102);
    tipsLabel2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipsLabel2];
    [tipsLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).offset(12);
        make.centerY.equalTo(_agreeMentBtn.mas_centerY);
        make.left.equalTo(_agreeMentBtn.mas_right).offset(0);
    }];
    
    
    UIView *funView = [UIView new];
    funView.backgroundColor = UIColor.clearColor;
    // 点击短信登录
    UITapGestureRecognizer *tapMessage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTapMessage)];
    [funView addGestureRecognizer:tapMessage];
    funView.userInteractionEnabled = YES;
    [_supView addSubview:funView];

    [funView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@80);
        make.width.equalTo(@44);
        make.top.equalTo(_privacyPolicyBtn.mas_bottom).offset(12);
        make.centerX.equalTo(_supView.mas_centerX).offset(-95);
    }];
    UIImageView *funimg = [UIImageView new];
    funimg.image = [UIImage imageNamed:@"philips_login_icon_verificationcode"];
    [funView addSubview:funimg];
    [funimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(funView);
    }];
    UILabel *funlabel = [UILabel new];
    funlabel.text = Localized(@"Login_Verification_Code");
    funlabel.textColor = KDSRGBColor(103, 103, 103);
    funlabel.font = [UIFont systemFontOfSize:12];
    funlabel.textAlignment = NSTextAlignmentCenter;
    [funView addSubview:funlabel];
    [funlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(funimg.mas_bottom).offset(8);
        make.left.right.equalTo(funView);
    }];

    UIView *funView2 = [UIView new];
    funView2.backgroundColor = UIColor.clearColor;
    //微信登录
    UITapGestureRecognizer *wiexinTap = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(sendWXAuthReq)];
    [funView2 addGestureRecognizer:wiexinTap ];
    funView2.userInteractionEnabled = YES;
    [_supView addSubview:funView2];

    [funView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@80);
        make.width.equalTo(@44);
        make.top.equalTo(_privacyPolicyBtn.mas_bottom).offset(12);
        make.centerX.equalTo(_supView.mas_centerX).offset(0);
    }];

    UIImageView *funimg2 = [UIImageView new];
    funimg2.image = [UIImage imageNamed:@"philips_login_icon_wechat"];
    [funView2 addSubview:funimg2];
    [funimg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(funView2);
    }];
    UILabel *funlabel2 = [UILabel new];
    funlabel2.text = Localized(@"Login_WeChat");
    funlabel2.textColor = KDSRGBColor(103, 103, 103);
    funlabel2.font = [UIFont systemFontOfSize:12];
    funlabel2.textAlignment = NSTextAlignmentCenter;
    [funView2 addSubview:funlabel2];
    [funlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(funimg2.mas_bottom).offset(8);
        make.left.right.equalTo(funView2);
    }];
    
  //  苹果登录
    UIView *funView3 = [UIView new];
    funView3.backgroundColor = UIColor.clearColor;
    UITapGestureRecognizer *AppleTap1 = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(signInWithApple)];
    [funView3 addGestureRecognizer:AppleTap1 ];
    funView3.userInteractionEnabled = YES;
    [_supView addSubview:funView3];

    [funView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@80);
        make.width.equalTo(@44);
        make.top.equalTo(_privacyPolicyBtn.mas_bottom).offset(12);
        make.centerX.equalTo(_supView.mas_centerX).offset(95);
    }];
    
    UIImageView *funimg3 = [UIImageView new];
    funimg3.image = [UIImage imageNamed:@"philips_login_icon_Ap'p'le"];
    [funView3 addSubview:funimg3];
    [funimg3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(funView3);
    }];
    UILabel *funlabel3 = [UILabel new];
    funlabel3.text = Localized(@"Apple");
    funlabel3.textColor = KDSRGBColor(103, 103, 103);
    funlabel3.font = [UIFont systemFontOfSize:12];
    funlabel3.textAlignment = NSTextAlignmentCenter;
    [funView3 addSubview:funlabel3];
    [funlabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(funimg3.mas_bottom).offset(8);
        make.left.right.equalTo(funView3);
    }];
    
    
    
    
}

#pragma mark  -  按钮点击事件
///   登录按钮
- (void)loginBtn:(id)sender {
    if ([self.userNameTextField.text isEqualToString:@""]) {
       
        [TRCustomAlert  showMessage:Localized(@"AccountIsEmpty") image:nil];
        return;
    }
    if (self.pwdTextField.text.length == 0) {
   
        [TRCustomAlert  showMessage:Localized(@"PwdcannotBeEmpty") image:nil];
        return;
    }
    if (self.userNameTextField.text.length == 0) {
        [TRCustomAlert  showMessage:Localized(@"usernameCan'tBeNull") image:nil];
        
        return;
    }
    if (![KDSTool isValidPassword:self.pwdTextField.text]) {
      
        [TRCustomAlert  showMessage:Localized(@"requireValidPwd") image:nil];
        return;
    }
    int source = 1;
    NSString *username = [self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];// self.userNameTextField.text;
    NSString *passWord = self.pwdTextField.text;
    NSString *crcCode = [self.countryCode.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    if ([KDSTool isValidateEmail:username]) {
        source = 2;
    } else if (crcCode.intValue != 86 || [KDSTool isValidatePhoneNumber:username]) {
        username = [crcCode stringByAppendingString:username];
    } else {
        [TRCustomAlert  showMessage:Localized(@"inputValidEmailOrPhoneNumber") image:nil];
        return;
    }

    MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"logining") toView:self.view];

    [[KDSHttpManager sharedManager] login:source username:username password:passWord success:^(KDSUser *_Nonnull user) {
        NSLog(@"userid==%@", user.uid);
        NSString *account = [KDSTool getDefaultLoginAccount];
        if (![account isEqualToString:username]) {
            [[KDSDBManager sharedManager] resetDatabase];
        }
        [KDSTool setDefaultLoginAccount:username];
        [KDSTool setDefaultLoginPassWord:passWord];
        KDSTool.crc = crcCode;
        [KDSUserManager sharedManager].user = user;
        [[KDSDBManager sharedManager] updateUser:user];

        [KDSUserManager sharedManager].userNickname = [[KDSDBManager sharedManager] queryUserNickname];
        [KDSHttpManager sharedManager].token = user.token;
        [hud hideAnimated:YES];
        KDSTabBarController *tab = [KDSTabBarController new];
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    } error:^(NSError *_Nonnull error) {
        [hud hideAnimated:YES];
        NSString *msg;
        msg = error.localizedDescription;
        [TRCustomAlert  showMessage:msg image:nil];
    } failure:^(NSError *_Nonnull error) {
        [hud hideAnimated:YES];
        [TRCustomAlert  showMessage:error.localizedDescription image:nil];
    }];
    [self.view endEditing:YES];
}

///  立即注册
- (void)registBtn:(id)sender {
    KDSLog(@"点击了立即注册 ");
    PLPSignUpViewController *signupVc = [PLPSignUpViewController new];
    // 参数的传递
    signupVc.countryCodeString = self.countryCode.text;
    signupVc.countryName = self.countryLabel.text;
    KDSNavigationController *nav = [[KDSNavigationController alloc ] initWithRootViewController:signupVc];
    [self presentViewController:nav animated:YES completion:nil];
}
///  忘记密码
- (void)forgetPwd:(UIButton *)sender {
    KDSLog(@"点击了忘记密码 ");
    PLPForgetPwdViewController *forgetVC = [PLPForgetPwdViewController new];
    forgetVC.registerType = RegisteredTypeForgetPwd;
    forgetVC.countryCodeString = self.countryCode.text;
    forgetVC.countryName = self.countryLabel.text;
    __weak typeof(self) safaSelf = self;
    forgetVC.registeredSucessBlock = ^(NSString *username, NSString *code, NSString *pwd) {
        safaSelf.userNameTextField.text = username;
        safaSelf.pwdTextField.text = pwd;
        safaSelf.code = code;
    };
    KDSNavigationController *nav = [[KDSNavigationController alloc ] initWithRootViewController:forgetVC];
    // [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
- (void)visibleBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.pwdTextField.secureTextEntry = NO;
    } else {
        self.pwdTextField.secureTextEntry = YES;
    }
    [self.pwdTextField becomeFirstResponder];
}

#pragma mark  - 值改变的监听事件
-  (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
// 用户名称的改变事件
-(void)nameTextChange{
    if (self.userNameTextField.text.length ==0) {
        [self.loginBtn setBackgroundColor:KDSRGBColor(179, 200, 230)];
    }else{
        [self.loginBtn setBackgroundColor:KDSRGBColor(10, 102, 161)];
    }
    
}
// 密码的值改变事件
-(void)passwordTextChange{

    if (self.pwdTextField.text.length ==0) {
        [self.loginBtn setBackgroundColor:KDSRGBColor(179, 200, 230)];
    }else{
        [self.loginBtn setBackgroundColor:KDSRGBColor(10, 102, 161)];
    }
    
}


#pragma mark   -  其他的登录方式

/// 短信验证码
- (void)clickTapMessage {
    PLPLoginWIthMessage *messageVc = [PLPLoginWIthMessage new];
    messageVc.countryCodeString = self.countryCode.text;
    messageVc.countryName = self.countryLabel.text;
    KDSNavigationController *nav = [[KDSNavigationController alloc ] initWithRootViewController:messageVc];
    [self presentViewController:nav animated:YES completion:nil];
}

///  微信
- (void)sendWXAuthReq {//复制即可
    if ([WXApi isWXAppInstalled]) {//判断用户是否已安装微信App
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.state = @"wx_oauth_authorization_state";//用于保持请求和回调的状态，授权请求或原样带回
        req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
        [WXApi sendReq:req completion:^(BOOL success) {
        }];
    } else {
        [TRCustomAlert  showMessage:@"温馨提示 ， 未安装微信应用 或版本过低" image:nil];
    }
}

- (void)weiChatOK {//第三方登录
    NSLog(@"我收到微信登录的信息 通知了---%@", [KDSUserManager sharedManager].weixinInfo);
    NSDictionary *weChatDic = [KDSUserManager sharedManager].weixinInfo;
    NSString *openid = weChatDic[@"openId"];
    __weak  typeof(self)  weakself = self;
    [[ KDSHttpManager  sharedManager] getTelByOpenId:openid success:^(NSString *_Nonnull tel) {
        KDSLog(@"kaadas 微信用户手机号码 ==%@", tel);
        weakself.WXTel  = tel;
        [weakself  weixinLogin:tel];
    } error:^(NSError *_Nonnull error) {
        if ( error.code == 448) { // 未绑定手机或openId不存在
            // 获取电话号码成功  如果电话号码有值 就进行号码填充 没有就不填充
            PLPLoginWithWieiXin *winXinVC = [PLPLoginWithWieiXin new];
            winXinVC.countryCodeString = self.countryCode.text;
            winXinVC.countryName = self.countryLabel.text;
            KDSNavigationController *nav = [[KDSNavigationController alloc ] initWithRootViewController:winXinVC];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [TRCustomAlert  showMessage:@"请求错误" image:nil];
        }
        
        
    } failure:^(NSError *_Nonnull error) {
        [TRCustomAlert  showMessage:@"请求电话号码错误" image:nil];
    }];
}
//  微信一键登录
- (void)weixinLogin:(NSString *) tel{
    NSDictionary  * dict = [KDSUserManager sharedManager].weixinInfo;
     NSString  * openid  = dict[@"openId"];
    [[KDSHttpManager  sharedManager] getUserByOpenId:openid tel: tel success:^(KDSUser * _Nonnull user) {
        [MBProgressHUD showSuccess:@"登录成功"];
        NSLog(@"xxxzhu=微信登录返回的userid==%@", user.uid);
        NSLog(@"xxxzhu=微信登录返回的token==%@", user.token);
        user.name = tel;
        ///微信登录成功，服务端没有返回user的name数据，暂时赋值为手机号码，后期应该要服务端返回才对
               NSString *account = [KDSTool getDefaultLoginAccount];
               if (![account isEqualToString:tel]) {
                   [[KDSDBManager sharedManager] resetDatabase];
               }
               [KDSTool setDefaultLoginAccount:tel];
       
               [KDSUserManager sharedManager].user = user;
               [[KDSDBManager sharedManager] updateUser:user];
       
               [KDSUserManager sharedManager].userNickname = [[KDSDBManager sharedManager] queryUserNickname];
               [KDSHttpManager sharedManager].token = user.token;
              
               KDSTabBarController *tab = [KDSTabBarController new];
               [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    
        } error:^(NSError * _Nonnull error) {
            NSString *msg;
            msg = error.localizedDescription;
            [TRCustomAlert  showMessage:msg image:nil];
        } failure:^(NSError * _Nonnull error) {
    
            [TRCustomAlert  showMessage:error.localizedDescription image:nil];
        }];
}

#pragma  mark  苹果自动登录
- (void)signInWithApple{
    
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider   *appleIDProvider = [[ASAuthorizationAppleIDProvider  alloc] init];
        ASAuthorizationAppleIDRequest  * appleIDResquest = [appleIDProvider  createRequest];
        ASAuthorizationPasswordRequest  * passwordRequest = [[[ASAuthorizationPasswordProvider alloc] init ] createRequest];
        NSMutableArray<ASAuthorizationRequest *>  *array = [NSMutableArray  arrayWithCapacity:2];
        if (appleIDResquest ) {
            [array  addObject:appleIDResquest];
        }
        NSArray <ASAuthorizationRequest *> * requests = [array copy];
           ASAuthorizationController * authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
           authorizationController.delegate = self;
           authorizationController.presentationContextProvider = self;
           [authorizationController performRequests];
        
    } else {
        [TRCustomAlert  showMessage:@"系统不支持Apple登录" image:nil];
    }
   
}
#pragma mark  苹果自动登录代理
-  (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
    if (@available(iOS 13.0, *)) {
        if ([authorization.credential  isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
            
            ASAuthorizationAppleIDCredential *credential = authorization.credential;
                    NSString *state = credential.state;
                    NSString *userID = credential.user;
                    NSPersonNameComponents *fullName = credential.fullName;
                    NSString *email = credential.email;
                    NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding]; // refresh token
                    NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding]; // access token
                    ASUserDetectionStatus realUserStatus = credential.realUserStatus;
                   // 保存用户信息
            [KDSTool setDefaultLoginApple:userID];
            NSDictionary  * dict = @{
                                     @"state": state,
                                     @"userID":userID,
                                     @"email":email,
                                     @"authorizationCode":authorizationCode,
                                     @"identityToken":identityToken,
                                     @"realUserStatus":@(realUserStatus)
                                     };
            
            [KDSTool  setDefaultLoginAppleDic:dict];
                    NSLog(@"state: %@", state);
                    NSLog(@"userID: %@", userID);
                    NSLog(@"fullName: %@", fullName);
                    NSLog(@"email: %@", email);
                    NSLog(@"authorizationCode: %@", authorizationCode);
                    NSLog(@"identityToken: %@", identityToken);
                    NSLog(@"realUserStatus: %@", @(realUserStatus));
            //   先判断用户是否已经绑定
            NSString  * appleid = [KDSTool  getDefaultLoginApple];
            NSLog(@"xxxzhu =appid=%@",appleid);
            NSDictionary  * dicts = [KDSTool getDefaultLoginAppleDic];
            NSLog(@"xxxzhu=state: %@", dicts[@"state"]);
            NSLog(@"xxxzhu=userID: %@", dicts[@"userID"]);
            NSLog(@"xxxzhu=fullName: %@", dicts[@"fullName"]);
            NSLog(@"xxxzhu=email: %@",dicts[@"email"] );
            __weak typeof(self) weakSelf = self;
            if (appleid) {
                [[KDSHttpManager  sharedManager]  getTelByAppleId:appleid success:^(NSString * _Nonnull tel) {
                    KDSLog(@"kaadas appleID用户手机号码 ==%@", tel);
                    // 用户apple一键登录的
                    [weakSelf  appleWithLogin:tel];
                    
                        } error:^(NSError * _Nonnull error) {
                            if ( error.code == 454) { // 未绑定手机或openId不存在
                                // 获取电话号码成功  如果电话号码有值 就进行号码填充 没有就不填充
                                PLPLoginWithWieiXin *winXinVC = [PLPLoginWithWieiXin new];
                                winXinVC.IsAppleID = YES;
                                winXinVC.countryCodeString = self.countryCode.text;
                                winXinVC.countryName = self.countryLabel.text;
                                KDSNavigationController *nav = [[KDSNavigationController alloc ] initWithRootViewController:winXinVC];
                                [self presentViewController:nav animated:YES completion:nil];
                            }else{
                                [TRCustomAlert  showMessage:@"请求错误" image:nil];
                            }
                            
                        } failure:^(NSError * _Nonnull error) {
                            
                            [TRCustomAlert  showMessage:error.localizedDescription image:nil];
                        }];
                
            }
            
        }
    }else {
        [TRCustomAlert  showMessage:@"系统不支持Apple登录" image:nil];
    }
}

//授权失败
-   (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    NSString  * errorMsg  = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
            
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
        default:
            break;
    }
    
    [TRCustomAlert  showMessage:errorMsg image:nil];
}

#pragma mark   -  ASAuthorztionControllerPresentationContextProviding

-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    return self.view.window;
    
}

// 苹果一键登录
- (void)appleWithLogin:(NSString *) tel{
     
    NSString  * appleid  = [KDSTool getDefaultLoginApple];;
    [[KDSHttpManager  sharedManager] getUserByAppleId:appleid tel:tel success:^(KDSUser * _Nonnull user) {
        [MBProgressHUD showSuccess:@"登录成功"];
            NSLog(@"userid==%@", user.uid);
        ///微信登录成功，服务端没有返回user的name数据，暂时赋值为手机号码，后期应该要服务端返回才对
                user.name = tel;
        NSString *account = [KDSTool getDefaultLoginAccount];
        if (![account isEqualToString:tel]) {
            [[KDSDBManager sharedManager] resetDatabase];
        }
        
        [KDSTool setDefaultLoginAccount:tel];
        [KDSUserManager sharedManager].user = user;
        [[KDSDBManager sharedManager] updateUser:user];
        [KDSUserManager sharedManager].userNickname = [[KDSDBManager sharedManager] queryUserNickname];
        [KDSHttpManager sharedManager].token = user.token;
        
        KDSTabBarController *tab = [KDSTabBarController new];
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
        } error:^(NSError * _Nonnull error) {
            NSString *msg;
                       msg = error.localizedDescription;
                       [TRCustomAlert  showMessage:msg image:nil];
            
        } failure:^(NSError * _Nonnull error) {
            [TRCustomAlert  showMessage:error.localizedDescription image:nil];
        }];
    
}



#pragma mark   输入条件的限制
- (void)selectCountryCodeClick:(UITapGestureRecognizer *)tap
{
    XWCountryCodeController *countryCodeVC = [[XWCountryCodeController alloc] init];
    countryCodeVC.returnCountryCodeBlock = ^(NSString *countryCodeStr) {
        NSArray<NSString *> *comps = [countryCodeStr componentsSeparatedByString:@"+"];
        self.countryCode.text = comps.count > 1 ? [@"+" stringByAppendingString:comps.lastObject] : @"+86";
        self.countryLabel.text = comps.count > 1 ? comps.firstObject : @"中国大陆";
    };
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:countryCodeVC];
    [self presentViewController:navi animated:YES completion:nil];
}

///用户名输入框限制条件
- (void)userNameTextFieldDidChange:(UITextField *)sender
{
    sender.text = [[sender.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
}

///密码输入框限制条件6~12位数字+密码
- (void)pwdtextFieldDidChange:(UITextField *)textField {
    textField.text = [[textField.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    if (textField.text.length > 12) {
        textField.text = [textField.text substringToIndex:12];

        [TRCustomAlert showMessage:Localized(@"PwdLength6BitsAndNotMoreThan12bits") image:nil];
    }
}

+ (BOOL)isValidPassword:(NSString *)text
{
    NSString *expr = @"^(?=.*\\d)(?=.*[a-zA-Z])[0-9a-zA-Z]{6,12}$";
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", expr];
    return [p evaluateWithObject:text];
}


#pragma mark --键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    //取出键盘动画的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //取得键盘最后的frame
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.supView.frame.size.height;
    NSLog(@"键盘上移的高度：%f-----取出键盘动画时间：%f", transformY, duration);
    [UIView animateWithDuration:duration animations:^{
        [self.supView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.mas_equalTo(self.view.mas_top).offset(KDSScreenHeight <= 667 ? -130 : -100);
            make.height.equalTo(@(KDSScreenHeight));
        }];
    }];
}

#pragma mark --键盘收回
- (void)keyboardDidHide:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.supView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];
    }];
}


#pragma mark -  用户政策和隐私协议
///用户协议
- (void)agreeMentBtn:(id)sender {
    KDSUserAgreementVC * userAgreeMentVC = [[KDSUserAgreementVC alloc] init];
    [self.navigationController pushViewController:userAgreeMentVC animated:YES];
}
///隐私政策点击事件
- (void)privacyPolicyBtn:(id)sender {
    KDSPrivacyPolicyVC * vc = [KDSPrivacyPolicyVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
