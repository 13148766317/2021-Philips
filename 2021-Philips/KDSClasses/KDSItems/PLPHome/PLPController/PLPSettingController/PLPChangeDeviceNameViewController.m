//
//  PLPChangeDeviceNameViewController.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/11.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPChangeDeviceNameViewController.h"

//#import "KDSHttpManager+VideoWifiLock.h"
#import "KDSHttpManager+WifiLock.h"

@interface PLPChangeDeviceNameViewController ()<UITextFieldDelegate>

//修改密码名称输入框
@property (nonatomic, strong) UITextField *changeWiFiNameTextField;

//确认Button
@property (nonatomic, strong) UIButton *confirmBurron;

@end

@implementation PLPChangeDeviceNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化主视图
    [self setupMainView];
}

#pragma mark - 初始化主视图
- (void) setupMainView{
    
    self.navigationTitleLabel.text = Localized(@"DevicesDetailSetting_Change_Name");
    self.view.backgroundColor = KDSRGBColor(248, 248, 248);
    //self.nameStr = self.lock.wifiDevice.lockNickname ?: self.lock.wifiDevice.wifiSN;
    
    //初始化修改密码输入框背景View
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    //添加密码名称修改输入框
    //[self.changeWiFiNameTextField becomeFirstResponder];
    self.changeWiFiNameTextField.text = self.lock.wifiDevice.lockNickname ?: self.lock.wifiDevice.wifiSN;
    [backView addSubview:self.changeWiFiNameTextField];
    
    //添加确认Button
    //self.confirmBurron.userInteractionEnabled = NO;
    [self.view addSubview:self.confirmBurron];
    
    //监听键盘弹出状态
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //UIKeyboardWillShowNotification  监听键盘弹出
    [center addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //UIKeyboardWillHideNotification  监听键盘收回
    [center addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 确认修改昵称点击事件
-(void) confirmButtonClick{
    
    //收回键盘
    [self.changeWiFiNameTextField resignFirstResponder];
    
    __weak typeof(self)weakSelf = self;
    NSString *newNickname = self.changeWiFiNameTextField.text;
    if (newNickname.length > 0){
        MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"DevicesDetailSetting_Change_LockName") toView:weakSelf.view];
        [[KDSHttpManager sharedManager] alterWifiBindedDeviceNickname:newNickname withUid:[KDSUserManager sharedManager].user.uid wifiModel:self.lock.wifiDevice success:^{
            [hud hideAnimated:NO];
            [MBProgressHUD showSuccess:Localized(@"Message_Save_Successful")];
            weakSelf.lock.wifiDevice.lockNickname = newNickname;
            weakSelf.confirmBurron.userInteractionEnabled = NO;
            [weakSelf.confirmBurron setBackgroundColor:KDSRGBColor(183, 200, 228)];
        
            [self.navigationController popViewControllerAnimated:YES];
        } error:^(NSError * _Nonnull error) {
            [hud hideAnimated:YES];
            [MBProgressHUD showError:[Localized(@"Message_Save_Fail") stringByAppendingString:error.localizedDescription]];
            weakSelf.confirmBurron.userInteractionEnabled = YES;
            [weakSelf.confirmBurron setBackgroundColor:KDSRGBColor(45, 100, 156)];
        } failure:^(NSError * _Nonnull error) {
            [hud hideAnimated:YES];
            [MBProgressHUD showError:[Localized(@"Message_Save_Fail") stringByAppendingString:error.localizedDescription]];
            weakSelf.confirmBurron.userInteractionEnabled = YES;
            [weakSelf.confirmBurron setBackgroundColor:KDSRGBColor(45, 100, 156)];
        }];
    }
}

#pragma mark - 键盘处理
/**
 *  键盘即将弹出
 */
- (void)keyBoardDidShow:(NSNotification *)notice
{
    NSValue * obj = notice.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    
    // 转换成CGRect
    CGRect keyboardRect = [obj CGRectValue];
    
    //获取self.confirmBurron偏移后的 y
    CGFloat distance = keyboardRect.size.height - _confirmBurron.frame.size.height - 20;
    self.confirmBurron.frame = CGRectMake(20,  distance , kScreenWidth-40,40);
}

/**
 *  键盘即将隐藏
 */
- (void)keyBoardDidHide:(NSNotification *)notice
{
    // 让self.confirmBurron回归原位
    self.confirmBurron.frame = CGRectMake(20, kScreenHeight-200, kScreenWidth-40, 40);
}

#pragma mark - 触摸屏幕可视区域，收回键盘
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.changeWiFiNameTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *nameStr = self.changeWiFiNameTextField.text;

    // 限制输入字符长度
    if (textField == self.changeWiFiNameTextField) {

        if (![string isEqualToString:@""]) {
            nameStr = [self.changeWiFiNameTextField.text stringByAppendingString:string];
        }else{
            nameStr = [nameStr substringWithRange:NSMakeRange(0, self.changeWiFiNameTextField.text.length-1)];
        }

        NSString *lockNickname =self.lock.wifiDevice.lockNickname ?: self.lock.wifiDevice.wifiSN;
        if (nameStr.length > 0 && ![nameStr isEqualToString:lockNickname]) {
            _confirmBurron.userInteractionEnabled = YES;
            [_confirmBurron setBackgroundColor:KDSRGBColor(45, 100, 156)];
        }else{
            _confirmBurron.userInteractionEnabled = NO;
            [_confirmBurron setBackgroundColor:KDSRGBColor(183, 200, 228)];
        }

        //限制输入长度
        if (nameStr.length >20) {
            return NO;
        }

        if (string.length == 0){

            return YES;
        }
    }
    
    return YES;
}

#pragma mark - 重写析构函数
-(void) dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - 懒加载

-(UITextField *)changeWiFiNameTextField{
    if (!_changeWiFiNameTextField) {
        _changeWiFiNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 50)];
        _changeWiFiNameTextField.delegate = self;
        _changeWiFiNameTextField.backgroundColor = [UIColor whiteColor];
        _changeWiFiNameTextField.textColor = [UIColor blackColor];
        //_changeWiFiNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _changeWiFiNameTextField.textAlignment = NSTextAlignmentLeft;
    }
    
    return _changeWiFiNameTextField;
}

-(UIButton *) confirmBurron{
    if (!_confirmBurron) {
        _confirmBurron = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBurron setFrame:CGRectMake(20, kScreenHeight-200, kScreenWidth-40, 40)];
        [_confirmBurron setBackgroundColor:KDSRGBColor(183, 200, 228)];
        [_confirmBurron setTitle:Localized(@"UnlockModel_Sure") forState:UIControlStateNormal];
        [_confirmBurron setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBurron addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _confirmBurron;
}


@end
