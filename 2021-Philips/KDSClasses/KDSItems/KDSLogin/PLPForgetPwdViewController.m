//
//  PLPForgetPwdViewController.m
//  2021-Philips
//
//  Created by kaadas on 2021/5/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPForgetPwdViewController.h"
#import "MBProgressHUD+MJ.h"
#import "Masonry.h"
#import "KDSHttpManager+Login.h"
#import "KDSUserAgreementVC.h"
#import "XWCountryCodeController.h"
#import "NSTimer+KDSBlock.h"
#import "KDSPrivacyPolicyVC.h"
@interface PLPForgetPwdViewController ()
///用户名输入框 手机号/邮箱
@property (strong, nonatomic)  UITextField *userNameTextField;
///验证码输入框
@property (strong, nonatomic)  UITextField *codeTextField;
///密码输入框
@property (strong, nonatomic)  UITextField *pwdTextField;
@property (strong, nonatomic)  UIButton *getCodeBtn;
///密码明文切换
@property (strong, nonatomic)  UIButton *visibleBtn;
@property (strong, nonatomic)  UIView *declarationView;
@property (strong, nonatomic)  UIView *topView;
///注册按钮
@property (strong, nonatomic)  UIButton *signupBtn;
///返回按钮
@property (strong, nonatomic)  UIButton *backUpBtn;
///title
@property (strong, nonatomic)  UILabel *titleLabel;
@property (nonatomic, strong) NSString *countryCodeStr;       //国家代码
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger num;
///显示区域代码的label---默认是86
@property (strong, nonatomic)  UILabel *countryCode;
///显示区域名字---默认是‘中国大陆’
@property (strong, nonatomic)  UILabel *countryLabel;
@property (strong, nonatomic)  UIButton *chooseCountry;

@property (strong, nonatomic)  NSLayoutConstraint *titleTopConstraint;
@property (strong, nonatomic)  NSLayoutConstraint *backUpBtnConstraint;
///是否同意协议按钮
@property (strong, nonatomic)  UIButton *agreeMentBtn;

@property (strong, nonatomic)  UIButton *agreeBtn;
@property (strong, nonatomic)  UILabel *agreementLabel;
///  隐私政策的按钮
@property (strong, nonatomic)  UIButton *privacyPolicyBtn;



@end

@implementation PLPForgetPwdViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.countdown = 59;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationTitleLabel.text = Localized(@"Login_ForgetPasword");
    //监听网络状态
    [[KDSUserManager sharedManager] monitorNetWork];
    [self setupUI];
    if (self.countryName.length)
    {
        self.countryLabel.text = self.countryName;
        self.countryCode.text = self.countryCodeString;
        self.countryCodeStr = [self.countryCodeString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    }
    else
    {
        NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
        NSString *code = [locale objectForKey:NSLocaleCountryCode];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CRCCODE" ofType:@"plist"];
        NSDictionary *codeDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        NSString *telCode = codeDict[code] ?: @"+86";
        self.countryCode.text = telCode;
        NSString *language = [KDSTool getLanguage];
        NSString *sortedName;
        if ([language isEqualToString:JianTiZhongWen])
        {
            sortedName = @"sortedChnames";
        }
        else if ([language isEqualToString:FanTiZhongWen])
        {
            sortedName = @"sortedChFantinames";
        }
        else
        {
            sortedName = @"sortedEnames";
        }
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:sortedName ofType:@"plist"]];
        NSMutableArray *namesAndCodes = [NSMutableArray array];
        for (NSArray *value in dict.allValues)
        {
            [namesAndCodes addObjectsFromArray:value];
        }
        for (NSString *nameAndCode in namesAndCodes)
        {
            if ([nameAndCode hasSuffix:telCode])
            {
                self.countryLabel.text = [[nameAndCode componentsSeparatedByString:@"+"].firstObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                break;
            }
        }
    }
    _num = 60;
    [_pwdTextField addTarget:self action:@selector(pwdtextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_userNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_codeTextField addTarget:self action:@selector(codeTextFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    
    // 添加选择事件
    UITapGestureRecognizer *selectCountryCodeTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCountryCodeClick:)];
    UITapGestureRecognizer *selectCountryCodeTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCountryCodeClick:)];

    self.countryLabel.userInteractionEnabled = YES;
    self.chooseCountry.userInteractionEnabled = YES;

    [self.countryLabel addGestureRecognizer:selectCountryCodeTap1];
    [self.chooseCountry addGestureRecognizer:selectCountryCodeTap2];
    _countryCodeStr = @"86";      //默认中国
    self.countryCode.text = @"+86";
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void) setupUI{
    
    UIView  * accountView = [UIView new];
    accountView.backgroundColor= UIColor.whiteColor;
    accountView.layer.masksToBounds = YES;
    accountView.layer.cornerRadius = 3;
    [self.view addSubview:accountView];
    
    [accountView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@44);
    }];
    _countryCode  = [UILabel new];
    _countryCode.text =@"+86";
    _countryLabel = [UILabel new];
    _countryLabel.text = @"中国";
    [accountView addSubview:_countryLabel];
    
    [_countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountView.mas_left).offset(15);
        make.width.equalTo(@35);
        make.top.bottom.equalTo(accountView);
    }];
    
    _chooseCountry = [UIButton new];
    [_chooseCountry  setBackgroundImage:[UIImage imageNamed:@"philips_login_icon_cbb"] forState:UIControlStateNormal];
    // 添加点击事件
    [accountView addSubview:_chooseCountry];
    [_chooseCountry  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@14);
        make.centerY.equalTo(accountView.mas_centerY);
        make.left.equalTo(_countryLabel.mas_right).offset(10);
    }];
    _userNameTextField = [UITextField new];
    _userNameTextField.placeholder = Localized(@"Login_Enter_Phone_Email");
    [accountView addSubview: _userNameTextField];
    [_userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_chooseCountry.mas_right).offset(15);
        make.top.bottom.right.equalTo(accountView);
    }];
    
    UIView  * verView = [UIView new];
    verView.backgroundColor= UIColor.whiteColor;
    verView.layer.masksToBounds = YES;
    verView.layer.cornerRadius = 3;
    [self.view addSubview:verView];
    [verView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@44);
    }];
    _codeTextField = [UITextField new];
    _codeTextField.placeholder = Localized(@"Login_Enter_Verification");
    [verView addSubview:_codeTextField];
    [_codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(verView);
        make.left.equalTo(verView.mas_left).offset(15);
        make.right.equalTo(verView.mas_right).offset(-110);
    }];
    _getCodeBtn = [UIButton new];
    [_getCodeBtn setTitle:Localized(@"Login_Get_Verification") forState:UIControlStateNormal];
    [_getCodeBtn setBackgroundColor:KDSRGBColor(0, 102, 161)];
    [_getCodeBtn  addTarget:self action:@selector(getCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [verView addSubview:_getCodeBtn];
    [_getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(verView);
        make.left.equalTo(_codeTextField.mas_right);
    }];
    UIView  * passwordView = [UIView new];
    passwordView.backgroundColor= UIColor.whiteColor;
    passwordView.layer.masksToBounds = YES;
    passwordView.layer.cornerRadius = 3;
    [self.view addSubview:passwordView];
    [passwordView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@44);
    }];
    _pwdTextField = [UITextField new];
    _pwdTextField.placeholder = Localized(@"Login_Password");
    [passwordView addSubview:_pwdTextField];
    [_pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(passwordView);
        make.left.equalTo(passwordView.mas_left).offset(15);
        make.right.equalTo(passwordView.mas_right).offset(-40);
    }];
    _visibleBtn = [UIButton new];
    // 默认隐藏密码
    _visibleBtn.selected = YES;
    [_visibleBtn  setBackgroundImage:[UIImage imageNamed:@"philips_login_icon_display"] forState:UIControlStateNormal];
    [_visibleBtn  setBackgroundImage:[UIImage imageNamed:@"philips_login_icon_hidden"] forState:UIControlStateSelected];
    [_visibleBtn addTarget:self action:@selector(visiblebtn:) forControlEvents:UIControlEventTouchUpInside];
    [passwordView addSubview:_visibleBtn];
    
    [_visibleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordView.mas_centerY);
        make.height.width.equalTo(@20);
        make.right.equalTo(passwordView.mas_right).offset(-12);
    }];
    UILabel * passwordDes = [UILabel new];
    passwordDes.text = Localized(@"Login_PasswordDes");
    passwordDes.font = [UIFont  systemFontOfSize:12];
    passwordDes.textColor = KDSRGBColor(153, 153, 153);
    [self.view addSubview:passwordDes];
    [passwordDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).offset(8);
        make.left.equalTo(self.view).offset(15);
    }];
    _signupBtn=  [UIButton new];
    [_signupBtn setTitle:Localized(@"Login_Complet") forState:UIControlStateNormal];
    [_signupBtn setBackgroundColor: KDSRGBColor(179, 200, 230)];
    _signupBtn.layer.masksToBounds = YES;
    _signupBtn.layer.cornerRadius = 3;
    [_signupBtn  addTarget:self action:@selector(signupBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signupBtn];
    [_signupBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@44);
    }];
}
#pragma mark  -  文本输入改变事件

///密码输入框限制条件6～12位
- (void)pwdtextFieldDidChange:(UITextField *)textField{
    
    if (self.pwdTextField.text.length ==0) {
        [self.signupBtn  setBackgroundColor:KDSRGBColor(179, 200, 230)];
    }else{
        [self.signupBtn  setBackgroundColor:KDSRGBColor(0, 102, 161)];
        
    }
    
    textField.text = [[textField.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    if (textField.text.length > 12) {
        textField.text = [textField.text substringToIndex:12];
      
        [TRCustomAlert showMessage:Localized(@"PwdLength6BitsAndNotMoreThan12bits") image:nil];
        
    }
}
///用户名输入框限制条件6～12位
- (void)textFieldDidChange:(UITextField *)textField{
    if (self.userNameTextField.text.length ==0) {
        [self.signupBtn  setBackgroundColor:KDSRGBColor(179, 200, 230)];
    }else{
        [self.signupBtn  setBackgroundColor:KDSRGBColor(0, 102, 161)];
        
    }
   textField.text = [[textField.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
}

///验证码输入框限制条件是6位数字
-(void)codeTextFieldDidChange:(UITextField *)sender
{
    if (self.codeTextField.text.length ==0) {
        [self.signupBtn  setBackgroundColor:KDSRGBColor(179, 200, 230)];
    }else{
        [self.signupBtn  setBackgroundColor:KDSRGBColor(0, 102, 161)];
        
    }
    sender.text = [[sender.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    if (sender.text.length > 6)
    {
        sender.text = [sender.text substringToIndex:6];
    }
}
#pragma mark - 控件点击事件
///注册
- (void)signupBtn:(id)sender {
    if (self.agreeMentBtn.selected == NO && (self.registerType == RegisteredTypeByTel || self.registerType == RegisteredTypeByEmail)) {
    
        [TRCustomAlert showMessage:Localized(@"Login_Aggment") image:nil];
        return;
    }
    if ([self.userNameTextField.text isEqualToString:@""]) {

        [TRCustomAlert showMessage:Localized(@"AccountIsEmpty") image:nil];
        return;
    
    }else if ([self.codeTextField.text isEqualToString:@""]){
        
        [TRCustomAlert showMessage:Localized(@"enterValidationCode") image:nil];
        
        return;
    
    }else if ([self.pwdTextField.text isEqualToString:@""]) {
      
        [TRCustomAlert showMessage:Localized(@"PwdcannotBeEmpty") image:nil];
        
        return;
    }
    
    if (![KDSTool isValidPassword:self.pwdTextField.text])
    {
        [TRCustomAlert showMessage:Localized(@"requireValidPwd") image:nil];
        return;
    }
    
    if (self.registerType == RegisteredTypeByTel || self.registerType == RegisteredTypeByEmail) {
        NSString *username = [self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *crcCode = @"86";
        int source = 1;
        ///用户名是否是邮箱，source=2代表邮箱，source=1代表手机号码
        if ([KDSTool isValidateEmail:username])
        {
            source = 2;
        }
        ///手机号码是否是中国区的号码
        else if (crcCode.intValue != 86 || [KDSTool isValidatePhoneNumber:self.userNameTextField.text])
        {
            username = [crcCode stringByAppendingString:username];
        }
        else
        {

            [TRCustomAlert showMessage:Localized(@"inputValidEmailOrPhoneNumber") image:nil];
            
            return;
        }
        if (!self.agreeMentBtn.selected) {
         
            [TRCustomAlert showMessage:Localized(@"agreeing agreement can register Cadillac APP") image:nil];
            return;
        }
        NSString *msg = Localized(@"signingup");
        MBProgressHUD *hud = [MBProgressHUD showMessage:msg toView:self.view];
        
        [[KDSHttpManager sharedManager] signup:source username:username captcha:self.codeTextField.text password:self.pwdTextField.text success:^{
            [hud hideAnimated:YES];
            [TRCustomAlert showMessage:Localized(@"signupSuccess") image:nil];
            [self dismissViewControllerAnimated:YES completion:^{
                !self.registeredSucessBlock ?: self.registeredSucessBlock(source==2 ? username : [username substringFromIndex:crcCode.length], crcCode, self.pwdTextField.text);
              }];
        } error:^(NSError * _Nonnull error) {
            [hud hideAnimated:YES];
            NSString *msg;
            msg = error.localizedDescription;

            [TRCustomAlert showMessage:msg image:nil];
            
        } failure:^(NSError * _Nonnull error) {
            [hud hideAnimated:YES];
      
            [TRCustomAlert showMessage:error.localizedDescription image:nil];
        }];
    }else{
        //忘记密码
        [self forgetPwd];
    }
    
}
///获取验证码
- (void)getCodeBtn:(UIButton *)sender
{
  
    if (![KDSUserManager sharedManager].netWorkIsAvailable) {
       
        [TRCustomAlert showMessage:Localized(@"networkNotAvailable") image:nil];
        return;
    }
    if (self.userNameTextField.text.length == 0)
    {
       
        [TRCustomAlert showMessage:Localized(@"usernameCan'tBeNull") image:nil];
        return;
    }
    NSString *crcCode = [self.countryCode.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *username = [self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([KDSTool isValidateEmail:username])
    {
        [[KDSHttpManager sharedManager] getCaptchaWithEmail:username success:^{
           
            [TRCustomAlert showMessage:Localized(@"captchaSendSuccess") image:nil];
            sender.enabled = NO;
            __weak typeof(self) weakSelf = self;
            NSTimer *timer = [NSTimer kdsScheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                if (weakSelf.countdown < 0 || !weakSelf)
                {
                    [timer invalidate];
                    weakSelf.countdown = 59;
                    sender.enabled = YES;
                    return;
                }
                [sender setTitle:[NSString stringWithFormat:@"%lds", (long)weakSelf.countdown] forState:UIControlStateDisabled];
                weakSelf.countdown--;
            }];
            [timer fire];
        } error:^(NSError * _Nonnull error) {
            if (error.code == 704)
            {
              
                [TRCustomAlert showMessage:Localized(@"getCaptchaTooOfter") image:nil];
            }
            else
            {
           
                [TRCustomAlert showMessage:[NSString stringWithFormat:@"error: %ld", (long)error.code] image:nil];
            }
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD showError:error.localizedDescription];
            [TRCustomAlert showMessage:error.localizedDescription image:nil];
        }];
    }
    else if (crcCode.intValue != 86 || [KDSTool isValidatePhoneNumber:username])
    {
        [[KDSHttpManager sharedManager] getCaptchaWithTel:username crc:crcCode success:^{
            [TRCustomAlert showMessage:Localized(@"captchaSendSuccess") image:nil];
            sender.enabled = NO;
            __weak typeof(self) weakSelf = self;
            NSTimer *timer = [NSTimer kdsScheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                if (weakSelf.countdown < 0 || !weakSelf)
                {
                    [timer invalidate];
                    weakSelf.countdown = 59;
                    sender.enabled = YES;
                    return;
                }
                [sender setTitle:[NSString stringWithFormat:@"%lds", (long)weakSelf.countdown] forState:UIControlStateDisabled];
                weakSelf.countdown--;
                //        NSLog(@"--{Kaadas}--countdown=%ld",(long)weakSelf.countdown);
            }];
            [timer fire];
        } error:^(NSError * _Nonnull error) {
            //服务器返回的说明
            [TRCustomAlert showMessage:[NSString stringWithFormat:@"error: %@", error.localizedDescription] image:nil];
        } failure:^(NSError * _Nonnull error) {
        
            [TRCustomAlert showMessage:error.localizedDescription image:nil];
        }];
    }
    else
    {
     
        [TRCustomAlert showMessage:Localized(@"inputValidEmailOrPhoneNumber") image:nil];
        return;
    }
    
}
- (void)backUpBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)UserAgreementBtn:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
}


///密码明文切换
- (void)visiblebtn:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.pwdTextField.secureTextEntry = NO;
    }else{
        self.pwdTextField.secureTextEntry = YES;
    }
    [self.pwdTextField becomeFirstResponder];
    
}
///选中国家区域代码
-(void)selectCountryCodeClick:(UITapGestureRecognizer *)tap
{
    XWCountryCodeController *countryCodeVC = [[XWCountryCodeController alloc] init];
    countryCodeVC.returnCountryCodeBlock = ^(NSString *countryCodeStr) {
        NSArray<NSString *> *comps = [countryCodeStr componentsSeparatedByString:@"+"];
        self.countryCode.text = [@"+" stringByAppendingString:comps.lastObject];
        self.countryLabel.text = comps.firstObject;
    };
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:countryCodeVC];
    [self presentViewController:navi animated:YES completion:nil];
}

//60s倒计时
- (void)updataTimer:(NSTimer *)timer
{
    _num--;
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_num] forState:UIControlStateNormal];
    _getCodeBtn.enabled = NO;
    if (_num == 1) {
        _num = 60;
        [_getCodeBtn setTitle:Localized(@"GetAuthenticationCode") forState:UIControlStateNormal];
        _getCodeBtn.enabled = YES;
        [timer invalidate];
    }
}

- (void)forgetPwd{
    
    NSString *name = _userNameTextField.text;
    int source = 1;
    NSString *crcCode = [self.countryCode.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    ///用户名是否是邮箱，source=2代表邮箱，source=1代表手机号码
    if ([KDSTool isValidateEmail:name])
    {
        source = 2;
    }
    ///手机号码是否是中国区的号码
    else if (crcCode.intValue != 86 || [KDSTool isValidatePhoneNumber:self.userNameTextField.text])
    {
        name = [crcCode stringByAppendingString:name];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"requestingResetPwd") toView:self.view];
    __weak typeof(self) weakSelf = self;
    [[KDSHttpManager sharedManager] forgotPwd:source name:name captcha:self.codeTextField.text newPwd:self.pwdTextField.text success:^{
        [TRCustomAlert showMessage:Localized(@"resetPwdSuccess") image:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
        if ([weakSelf.markSecuritySetting isEqualToString:@"KDSGesturePwdVC"]) {
            //退出登录
            int source = 1;
            NSString *userName = [KDSTool getDefaultLoginAccount];
            if ([KDSTool isValidateEmail:userName])
            {
                source = 2;
            }
            [[KDSHttpManager sharedManager] logout:source username:[KDSTool getDefaultLoginAccount] uid:[KDSUserManager sharedManager].user.uid success:^{
               [hud hideAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:KDSLogoutNotification object:nil userInfo:nil];
            } error:^(NSError * _Nonnull error) {
                [MBProgressHUD hideHUD];
            
                [TRCustomAlert  showMessage:error.localizedDescription image:nil];
            } failure:^(NSError * _Nonnull error) {
                [MBProgressHUD hideHUD];
                [TRCustomAlert showMessage:error.localizedDescription image:nil];
            }];
            
        }else{
            [hud hideAnimated:YES];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    } error:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        NSString *msg;
        msg = error.localizedDescription;
        [TRCustomAlert   showMessage:msg image:nil];
        
    } failure:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:error.localizedDescription];
        [TRCustomAlert showMessage:error.localizedDescription image:nil];
    }];
}
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