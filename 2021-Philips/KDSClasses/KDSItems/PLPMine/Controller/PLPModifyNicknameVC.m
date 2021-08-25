//
//  PLPModifyNicknameVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/8.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPModifyNicknameVC.h"
#import "KDSDBManager.h"
#import "KDSHttpManager+User.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+Extension.h"

@interface PLPModifyNicknameVC ()
///输入新昵称的文本框。
@property (nonatomic, readwrite, strong) UITextField *nicknameTF;
///确定按钮
@property (nonatomic, readwrite, strong) UIButton * sureBtn;


@end

@implementation PLPModifyNicknameVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = KDSRGBColor(242, 242, 242);//设置名字
    self.navigationTitleLabel.text = Localized(@"setName");
    UIView * supView = [UIView new];
    supView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:supView];
    [supView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.top.mas_equalTo(self.view.mas_top).offset(15);
        make.height.equalTo(@56);
    }];
    [supView addSubview:self.nicknameTF];
    [self.nicknameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(supView.mas_left).offset(20);
        make.right.mas_equalTo(supView.mas_right).offset(0);
        make.bottom.mas_equalTo(supView.mas_bottom).offset(0);
        make.top.mas_equalTo(supView.mas_top).offset(0);
        
    }];
    [self.view addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@44);
        make.top.mas_equalTo(supView.mas_bottom).offset(200);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor = KDSRGBColor(242, 242, 242);
}

#pragma mark -- 控件点击事件
///个人信息昵称文本框文字改变后，限制长度不超过16。
- (void)textFieldTextDidChange:(UITextField *)sender
{
//    [sender trimTextToLength:-1];
    if (sender.text.length >= 20) {
        sender.text = [sender.text substringToIndex:20];
        [MBProgressHUD showError:@"超过最大字数限制了"];
    }
    
    if (sender.text.length >= 1) {
         self.sureBtn.backgroundColor = KDSRGBColor(0, 102, 161);
        self.sureBtn.userInteractionEnabled = YES;
    }else{
        self.sureBtn.backgroundColor = KDSRGBColor(179, 200, 230);
        self.sureBtn.userInteractionEnabled = NO;
    }
}

- (void)shureBtnClick:(UIButton *)sender
{
    KDSLog(@"点击了确定按钮");
    
    if (self.nicknameTF.text.length == 0) {
        [MBProgressHUD showError:Localized(@"Nicknames are not empty")];
        return;
    }
    if ([self.nicknameTF.text isEqualToString:[KDSUserManager sharedManager].userNickname]) {
        [MBProgressHUD showSuccess:Localized(@"No modification nickname")];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    [[KDSHttpManager sharedManager] setUserNickname:self.nicknameTF.text withUid:[KDSUserManager sharedManager].user.uid success:^{
        [self  selectNiceNameFromDBManager];
        [hud hideAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD showSuccess:Localized(@"modifyNicknameSuccess")];
    } error:^(NSError *_Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:[Localized(@"modifyNicknameFailed") stringByAppendingFormat:@": %ld", (long)error.localizedDescription]];
    } failure:^(NSError *_Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:[Localized(@"modifyNicknameFailed") stringByAppendingFormat:@"，%@", error.localizedDescription]];
    }];
}
// 从服务器查询修改后的昵称  然后在进行保存
- (void)selectNiceNameFromDBManager {
    [[KDSHttpManager  sharedManager] getUserNicknameWithUid:[KDSUserManager sharedManager].user.uid success:^(NSString *_Nullable nickname) {
        NSLog(@"zhu == nickname ==%@", nickname);
        if (nickname) {
            [[KDSDBManager sharedManager] updateUserNickname:nickname];
            [KDSUserManager sharedManager].userNickname = nickname;
        }
    } error:^(NSError *_Nonnull error) {
    } failure:^(NSError *_Nonnull error) {
    }];
}

#pragma mark -- Lazy load
- (UITextField *)nicknameTF
{
    if (!_nicknameTF) {
        _nicknameTF = ({
            UITextField *tf = [UITextField new];
            tf.font = [UIFont systemFontOfSize:15];
            tf.placeholder = Localized(@"inputNewNickname");
            [tf addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
            tf.backgroundColor = [UIColor clearColor];
            tf.textColor = KDSRGBColor(142, 142, 147);
            tf.textAlignment = NSTextAlignmentLeft;
            tf.clearsOnBeginEditing = YES;
            tf.text = [KDSUserManager sharedManager].userNickname;
            tf;
        });
    }

    return _nicknameTF;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = ({
            UIButton * sBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [sBtn setTitle:Localized(@"sure") forState:UIControlStateNormal];
            [sBtn addTarget:self action:@selector(shureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            sBtn.backgroundColor = KDSRGBColor(179, 200, 230);
            sBtn.userInteractionEnabled = NO;
            sBtn;
        });
    }
    
    return _sureBtn;
}


@end
