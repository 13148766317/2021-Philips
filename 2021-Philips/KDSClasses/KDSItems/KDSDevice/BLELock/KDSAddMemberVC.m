//
//  KDSAddMemberVC.m
//  xiaokaizhineng
//
//  Created by wzr on 2019/2/18.
//  Copyright © 2019 shenzhen kaadas intelligent technology. All rights reserved.
//

#import "KDSAddMemberVC.h"
#import "XWCountryCodeController.h"
#import "MBProgressHUD+MJ.h"
#import "KDSHttpManager+User.h"
#import "KDSHttpManager+WifiLock.h"
#import "KDSDBManager.h"


@interface KDSAddMemberVC ()<UITextFieldDelegate>

//国家/区域电话代码按钮。
@property (strong, nonatomic) UIButton *crcBtn;

//新用户账号输入框
@property (strong, nonatomic) UITextField *accountTextField;

//新用户备注名称输入框
@property (nonatomic, strong) UITextField *nameTextField;

//确认按钮
@property (strong, nonatomic) UIButton *okBtn;

@end

@implementation KDSAddMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化主视图
    [self setupMainView];
}

#pragma mark - 初始化主视图
-(void) setupMainView{
    
    self.navigationTitleLabel.text = Localized(@"DeviceShare_Add_User");
    
    //头部背景View
    UIView *headBackView = [UIView new];
    headBackView.backgroundColor = KDSRGBColor(0xf2, 0xf2, 0xf2);
    [self.view addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.size.mas_offset(CGSizeMake(kScreenWidth,40));
    }];
    
    //已添加新用户标题
    UILabel *headTitleLabel = [UILabel new];
    NSString *nameStr = [KDSTool showNameStr:self.lock.wifiDevice.lockNickname Length:10];
    headTitleLabel.text = [NSString stringWithFormat:@"%@  \"%@\"  %@",Localized(@"DeviceShare_Devices"),nameStr,Localized(@"DeviceShare_shareed")];
    headTitleLabel.textColor = [UIColor blackColor];
    headTitleLabel.textAlignment = NSTextAlignmentLeft;
    headTitleLabel.font = [UIFont systemFontOfSize:15];
    [headBackView addSubview:headTitleLabel];
    [headTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headBackView).offset(15);
        make.top.equalTo(headBackView).offset(10);
        make.size.mas_offset(CGSizeMake(300,20));
    }];
    
    //输入框背景View
    UIView *textfieldBackView = [UIView new];
    textfieldBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textfieldBackView];
    [textfieldBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(headBackView.mas_bottom).offset(0);
        make.size.mas_offset(CGSizeMake(kScreenWidth,110));
    }];
    
    //用户账号输入框
    _accountTextField = [UITextField new];
    _accountTextField.delegate = self;
    _accountTextField.backgroundColor = [UIColor whiteColor];
    _accountTextField.textColor = [UIColor blackColor];
    _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountTextField.textAlignment = NSTextAlignmentLeft;
    _accountTextField.placeholder = Localized(@"DeviceShare_Account");
    //_accountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [textfieldBackView addSubview:_accountTextField];
    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textfieldBackView).offset(15);
        make.top.equalTo(textfieldBackView).offset(0);
        make.size.mas_offset(CGSizeMake(kScreenWidth - 30,50));
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = KDSRGBColor(0xf2, 0xf2, 0xf2);
    [textfieldBackView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textfieldBackView).offset(0);
        make.top.equalTo(_accountTextField.mas_bottom).offset(0);
        make.size.mas_offset(CGSizeMake(kScreenWidth ,10));
    }];
    
    //用户备注名称输入框
    _nameTextField = [UITextField new];
    _nameTextField.delegate = self;
    _nameTextField.backgroundColor = [UIColor whiteColor];
    _nameTextField.textColor = [UIColor blackColor];
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameTextField.textAlignment = NSTextAlignmentLeft;
    _nameTextField.placeholder = Localized(@"DeviceShare_SubTitle_Name");
    [textfieldBackView addSubview:_nameTextField];
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textfieldBackView).offset(15);
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.size.mas_offset(CGSizeMake(kScreenWidth - 30,50));
    }];
    
    _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_okBtn setBackgroundColor:KDSRGBColor(183, 200, 228)];
    [_okBtn setTitle:Localized(@"DeviceShare_Add") forState:UIControlStateNormal];
    _okBtn.userInteractionEnabled = NO;
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_okBtn];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.view).offset(-80);
        make.size.mas_offset(CGSizeMake(kScreenWidth - 30,40));
    }];
    
    NSString *title = KDSTool.crc;
    if (!title){
        
        NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
        NSString *code = [locale objectForKey:NSLocaleCountryCode];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CRCCODE" ofType:@"plist"];
        NSDictionary *codeDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        title = codeDict[code] ?: @"+86";
    }else{
        title = [@"+" stringByAppendingString:title];
    }
    
    [self.crcBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark - 控件等事件方法。
- (void)saveClick:(id)sender {
    
    NSString *username = self.accountTextField.text;
    NSString *lastStr = @"86";
    NSArray<NSString *> *comps = [self.crcBtn.currentTitle componentsSeparatedByString:@"+"];
    ///如果用户名是邮箱地址
    if ([KDSTool isValidateEmail:username]){
        
    }else if (comps.lastObject.intValue != 86 || [KDSTool isValidatePhoneNumber:self.accountTextField.text]){//如果用户名是中国区手机号码
        username = [lastStr stringByAppendingString:username];
    }else{//不是邮箱且不是手机号码
        [MBProgressHUD showError:Localized(@"Write_Valid_EmailOrPhoneNum")];
        return;
    }
    
    ///如果输入的手机号码或者邮箱是本人的则提示不能添加自己
    if ([username isEqualToString:[KDSUserManager sharedManager].user.name])
    {
        [MBProgressHUD showError:Localized(@"DeviceShare_Not_AddAmdia")];
        return;
    }
    
    KDSUserManager *userMgr = [KDSUserManager sharedManager];
    userMgr.userNickname = [[KDSDBManager sharedManager] queryUserNickname];
    KDSAuthMember *member = [KDSAuthMember new];
    member.jurisdiction = @"3";
    member.beginDate = @"2000-01-01 00:00:00";
    member.endDate = @"2099-01-01 00:00:00";
    member.uname = username;
    member.unickname = self.nameTextField.text;
    member.userNickname = self.nameTextField.text;
    member.adminname = userMgr.userNickname ?: userMgr.user.name;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    if (self.lock.device) {
        [[KDSHttpManager sharedManager] addAuthorizedUser:member withUid:[KDSUserManager sharedManager].user.uid device:self.lock.device success:^{
            [hud hideAnimated:NO];
            [MBProgressHUD showSuccess:Localized(@"Add_a_success")];
            !self.memberDidAddBlock ?: self.memberDidAddBlock(member);
            if (self.navigationController.topViewController == self)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } error:^(NSError * _Nonnull error) {
            [hud hideAnimated:NO];
            [MBProgressHUD showError:error.localizedDescription];
        } failure:^(NSError * _Nonnull error) {
            [hud hideAnimated:NO];
            [MBProgressHUD showError:error.localizedDescription];
        }];
    }else if (self.lock.wifiDevice){
        [[KDSHttpManager sharedManager] addWifiLockAuthorizedUser:member withUid:[KDSUserManager sharedManager].user.uid wifiSN:self.lock.wifiDevice.wifiSN success:^{
            [hud hideAnimated:NO];
            [MBProgressHUD showSuccess:Localized(@"Add_a_success")];
            !self.memberDidAddBlock ?: self.memberDidAddBlock(member);
            if (self.navigationController.topViewController == self)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } error:^(NSError * _Nonnull error) {
            [hud hideAnimated:NO];
            [MBProgressHUD showError:error.localizedDescription];
        } failure:^(NSError * _Nonnull error) {
            [hud hideAnimated:NO];
            [MBProgressHUD showError:error.localizedDescription];
        }];
    }else{
        [[KDSMQTTManager sharedManager] shareGatewayBindingWithGW:self.catEye.gw.model ?: self.lock.gw.model device:self.catEye.gatewayDeviceModel ?: self.lock.gwDevice userAccount:username userNickName:@"" shareFlag:1 type:2 completion:^(NSError * _Nullable error, BOOL success) {
            [hud hideAnimated:NO];
            if (success) {
                [MBProgressHUD showSuccess:Localized(@"Add_a_success")];
                if (self.navigationController.topViewController == self)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else if (error.code == 402){
                
                [MBProgressHUD showError:Localized(@"DeviceShare_No_Account")];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if (error.code == 738){
                
                [MBProgressHUD showError:Localized(@"DeviceShare_Share_Error")];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [MBProgressHUD showError:Localized(@"DeviceShare_Share_Error")];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

///点击国家/区域码按钮选择国家/区域码。
- (void)crcBtnClickSelectCode:(UIButton *)sender
{
    XWCountryCodeController *countryCodeVC = [[XWCountryCodeController alloc] init];
    countryCodeVC.returnCountryCodeBlock = ^(NSString *countryCodeStr) {
        NSArray<NSString *> *comps = [countryCodeStr componentsSeparatedByString:@"+"];
        [self.crcBtn setTitle:[@"+" stringByAppendingString:comps.lastObject] forState:UIControlStateNormal];
    };
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:countryCodeVC];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    // 限制输入字符长度
    if (textField == self.accountTextField) {
        if (string.length == 0){
            
            return YES;
        }
    }else{
        if (string.length == 0){
            
            return YES;
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    //计算输入的用户账号长度
    NSInteger accountLengther = [self inputStrLength:self.accountTextField.text];
    
    //计算输入的用户名的长度
    NSInteger nameLengther = [self inputStrLength:self.nameTextField.text];
    
    //判断添加按钮是否可用
    if (accountLengther >= 1 && nameLengther >0) {
        self.okBtn.userInteractionEnabled = YES;
        [self.okBtn setBackgroundColor:KDSRGBColor(45, 100, 158)];
    }else{
        self.okBtn.userInteractionEnabled =NO;
        [self.okBtn setBackgroundColor:KDSRGBColor(183, 200, 228)];
    }
    
    if (textField == self.accountTextField) {
        if (accountLengther > 11) {
            //self.accountTextField.text = [self.accountTextField.text substringToIndex:25];
        }
    }
}

///被授权的账号限制输入长度
- (void)textFieldTextDidChange:(UITextField *)sender
{
    if (sender.text.length > 11){
        //sender.text = [sender.text substringToIndex:25];
    }
}

#pragma mark - 计算输入字符长度，规则：一个中文占2个字符，数字和英文都占1个字符
- (NSInteger )inputStrLength:(NSString *)str {

    NSInteger length = 0;
    for(int i=0; i< [str length];i++) {

        int a = [str characterAtIndex:i];

        if( a > 0x4e00 && a < 0x9fff){//判断输入的是否是中文

            length = length + 2;

        } else {
            length = length + 1;
        }
    }

    return length;
}

@end
