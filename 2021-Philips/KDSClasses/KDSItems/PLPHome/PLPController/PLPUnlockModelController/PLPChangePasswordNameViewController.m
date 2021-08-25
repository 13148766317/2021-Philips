//
//  PLPChangePasswordNameViewController.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/4/29.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPChangePasswordNameViewController.h"
#import "KDSHttpManager+WifiLock.h"
#import "KDSDBManager.h"
#import "UIView+Extension.h"

#define MaxNumberOfDescriptionChars  10

@interface PLPChangePasswordNameViewController ()<UITextFieldDelegate>

//修改密码名称输入框
@property (nonatomic, strong) UITextField *changePasswordNameTextField;

//确认Button
@property (nonatomic, strong) UIButton *confirmBurron;

@end

@implementation PLPChangePasswordNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化主视图
    [self setupMainView];
}

#pragma mark - 初始化主视图
- (void) setupMainView{
    
    self.navigationTitleLabel.text = Localized(@"UnlockModel_Change_Name");
    self.view.backgroundColor = KDSRGBColor(248, 248, 248);
    
    //初始化修改密码输入框背景View
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    //添加密码名称修改输入框
    self.changePasswordNameTextField.text = self.nickName;
    [backView addSubview:self.changePasswordNameTextField];
    
    //添加确认Button
    [self.view addSubview:self.confirmBurron];
    
    //监听键盘弹出状态
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //UIKeyboardWillShowNotification  监听键盘弹出
    [center addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //UIKeyboardWillHideNotification  监听键盘收回
    [center addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 更新昵称接口调试
- (void)updateNickname:(NSString *)nickname
{
    __weak typeof(self) weakSelf = self;
    if (nickname.length == 0) return;
    KDSUserManager *userMgr = [KDSUserManager sharedManager];
    // 用户昵称从本地数据库中查询
    userMgr.userNickname = [[KDSDBManager sharedManager] queryUserNickname];
    KDSPwdListModel * model = self.model;
    NSString * name = model.nickName ?: [NSString stringWithFormat:@"%02d",model.num.intValue];
    model.nickName = nickname;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    [[KDSHttpManager sharedManager] setWifiLockPwd:model withUid:[KDSUserManager sharedManager].user.uid wifiSN:self.lock.wifiDevice.wifiSN userNickname:userMgr.userNickname ?: userMgr.user.name success:^{
        [hud hideAnimated:NO];
        weakSelf.changePasswordNameTextField.text = nickname;
        weakSelf.confirmBurron.userInteractionEnabled = NO;
        [weakSelf.confirmBurron setBackgroundColor:KDSRGBColor(183, 200, 228)];
        [MBProgressHUD showSuccess:Localized(@"UnlockModel_Setting_Sucessful")];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSError * _Nonnull error) {
        [hud hideAnimated:NO];
        [MBProgressHUD showError:error.localizedDescription];
        model.nickName = name;
    } failure:^(NSError * _Nonnull error) {
        [hud hideAnimated:NO];
        [MBProgressHUD showError:error.localizedDescription];
        model.nickName = name;
    }];
}

#pragma mark - 确认Button点击事件
-(void) confirmButtonClick{
    
    [self.changePasswordNameTextField resignFirstResponder];
    [self updateNickname:self.changePasswordNameTextField.text];
}

#pragma mark - UITextFieldDelegate

//锁昵称文本框文字改变后，限制长度不超过10个字符。
- (void)textFieldTextDidChange:(UITextField *)sender{
    
    if (sender.text.length >= 10) {
        sender.text = [sender.text substringToIndex:10];
        //[MBProgressHUD showError:@"超过最大字数限制了"];
    }

    if (sender.text.length > 0 && ![sender.text isEqualToString:self.nickName]) {
        self.confirmBurron.userInteractionEnabled = YES;
        [self.confirmBurron setBackgroundColor:KDSRGBColor(45, 100, 156)];
    }else{
        self.confirmBurron.userInteractionEnabled = NO;
        [self.confirmBurron setBackgroundColor:KDSRGBColor(183, 200, 228)];
    }
}


//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    // 限制输入字符长度
//    if (textField == self.changePasswordNameTextField) {
//
//        NSString *nameStr = self.changePasswordNameTextField.text;
//
//        if (![string isEqualToString:@""]) {
//            nameStr = [self.changePasswordNameTextField.text stringByAppendingString:string];
//        }else{
//            nameStr = [nameStr substringWithRange:NSMakeRange(0, self.changePasswordNameTextField.text.length-1)];
//        }
//
//        if (nameStr.length > 0 && ![nameStr isEqualToString:self.nickName]) {
//            self.confirmBurron.userInteractionEnabled = YES;
//            [self.confirmBurron setBackgroundColor:KDSRGBColor(45, 100, 156)];
//        }else{
//            self.confirmBurron.userInteractionEnabled = NO;
//            [self.confirmBurron setBackgroundColor:KDSRGBColor(183, 200, 228)];
//        }
//
////        if (nameStr.length > 10) {
////
////            return NO;
////        }
//
//        if (self.changePasswordNameTextField.text.length > 10) {
//
//            return NO;
//        }
//
//        if (string.length == 0){
//
//            return YES;
//        }
//    }
//
//    return YES;
//}

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
    
    [self.changePasswordNameTextField becomeFirstResponder];
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

#pragma mark - 重写析构函数
-(void) dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - 懒加载

-(UITextField *)changePasswordNameTextField{
    if (!_changePasswordNameTextField) {
        _changePasswordNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 50)];
        _changePasswordNameTextField.delegate = self;
        _changePasswordNameTextField.backgroundColor = [UIColor whiteColor];
        _changePasswordNameTextField.textColor = [UIColor blackColor];
        //_changePasswordNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _changePasswordNameTextField.textAlignment = NSTextAlignmentLeft;
        [_changePasswordNameTextField addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _changePasswordNameTextField;
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
