//
//  KDSWifiLockKeyDetailsVC.m
//  2021-Philips
//
//  Created by zhaona on 2019/12/26.
//  Copyright © 2019 com.Kaadas. All rights reserved.
//

#import "KDSWifiLockKeyDetailsVC.h"
#import "KDSAuthMember.h"
#import "UIView+Extension.h"
#import "KDSHttpManager+WifiLock.h"
#import "KDSDBManager.h"

@interface KDSWifiLockKeyDetailsVC ()<UITextFieldDelegate>

///编辑按钮旁边的可编辑的昵称标签。
@property (nonatomic, weak) UILabel *editNicknameLabel;
///A date formatter with format yyyy-MM-dd HH:mm:ss
@property (nonatomic, strong) NSDateFormatter *dateFmt;

@property (nonatomic, strong) UILabel * nickNameTipsLb;

@end

@implementation KDSWifiLockKeyDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化主视图 
     [self setupUI];
}

#pragma mark - 初始化主视图
- (void)setupUI
{
    self.navigationTitleLabel.text = Localized(@"DeviceShare_Account_Detail");
    
    KDSAuthMember * model = self.model;
    
    //删除用户Button
    UIButton * deleteBtn = [UIButton new];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleteBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [deleteBtn setTitle:Localized(@"DeviceShare_Delete_User") forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleClick:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.backgroundColor = KDSRGBColor(259, 59, 48);
    [self.view addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-80);
        make.left.equalTo(self.view).offset(15);
        make.size.mas_offset(CGSizeMake(kScreenWidth - 30,40));
    }];
    
    //授权账户名称修改背景View
    UIView *firstBackView = [UIView new];
    firstBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstBackView];
    [firstBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.equalTo(self.view).offset(0);
        make.size.mas_offset(CGSizeMake(kScreenWidth,60));
    }];
    
    //设备名称
    _nickNameTipsLb = [UILabel new];
    _nickNameTipsLb.font = [UIFont systemFontOfSize:15];
    _nickNameTipsLb.textColor = UIColor.blackColor;
    _nickNameTipsLb.text =model.userNickname; //[KDSTool showNameStr:model.userNickname Length:10];
    _nickNameTipsLb.textAlignment = NSTextAlignmentLeft;
    [firstBackView addSubview:_nickNameTipsLb];
    [_nickNameTipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstBackView).offset(20);
        make.left.equalTo(firstBackView).offset(15);
        make.size.mas_offset(CGSizeMake(100,20));
    }];
    
    //修改设备名称Button
    UIButton * eitBtn = [UIButton new];
    [eitBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [eitBtn addTarget:self action:@selector(clickEditBtnEditNickname:) forControlEvents:UIControlEventTouchUpInside];
    [firstBackView addSubview:eitBtn];
    [eitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstBackView).offset(10);
        make.right.equalTo(firstBackView).offset(-15);
        make.size.mas_offset(CGSizeMake(60,40));
    }];
    
    //分割线
    UIView *lineView = [UIView new];
    lineView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstBackView.mas_bottom).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.size.mas_offset(CGSizeMake(kScreenWidth,10));
    }];
    
    //授权账号+授权时间背景View
    UIView * tipsView = [UIView new];
    tipsView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:tipsView];
    [tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.equalTo(@120);
    }];

    //授权账号名称
    UILabel * nickTitleNameTipsLb = [UILabel new];
    nickTitleNameTipsLb.font = [UIFont systemFontOfSize:15];
    nickTitleNameTipsLb.textColor = UIColor.blackColor;
    nickTitleNameTipsLb.text = Localized(@"DeviceShare_Empower");
    nickTitleNameTipsLb.textAlignment = NSTextAlignmentLeft;
    [tipsView addSubview:nickTitleNameTipsLb];
    [nickTitleNameTipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipsView.mas_top).offset(20);
        make.left.mas_equalTo(tipsView.mas_left).offset(15);
        make.height.equalTo(@20);
        make.width.equalTo(@80);
    }];

    //账号名称
    UILabel * nickTitleNameLb = [UILabel new];
    nickTitleNameLb.font = [UIFont systemFontOfSize:15];
    //nickTitleNameLb.textColor = KDSRGBColor(153, 153, 153);
    nickTitleNameLb.textAlignment = NSTextAlignmentRight;
    nickTitleNameLb.text = model.uname ?: @"";
    //self.editNicknameLabel = nickNameLb;
    [tipsView addSubview:nickTitleNameLb];
    [nickTitleNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipsView.mas_top).offset(20);
        make.right.mas_equalTo(tipsView).offset(-15);
        make.size.mas_offset(CGSizeMake(200,20));
    }];


    //授权时间--标题
    UILabel * authorizedTimeTipsLb = [UILabel new];
    authorizedTimeTipsLb.font = [UIFont systemFontOfSize:15];
    authorizedTimeTipsLb.textColor = UIColor.blackColor;
    authorizedTimeTipsLb.textAlignment = NSTextAlignmentLeft;
    authorizedTimeTipsLb.text = Localized(@"UnlockModel_Add_Time");
    [tipsView addSubview:authorizedTimeTipsLb];
    [authorizedTimeTipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nickTitleNameLb.mas_bottom).offset(40);
        make.left.mas_equalTo(tipsView.mas_left).offset(15);
        make.height.equalTo(@20);
        make.width.equalTo(@80);
    }];

    //授权时间--具体时间
    UILabel * authorizedTimeLb = [UILabel new];
    authorizedTimeLb.font = [UIFont systemFontOfSize:15];
    //authorizedTimeLb.textColor = KDSRGBColor(153, 153, 153);
    authorizedTimeLb.textAlignment = NSTextAlignmentRight;
    authorizedTimeLb.text = [self.dateFmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.createTime]];
    [tipsView addSubview:authorizedTimeLb];
    [authorizedTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nickTitleNameLb.mas_bottom).offset(40);
        make.right.mas_equalTo(tipsView).offset(-15);
        make.size.mas_offset(CGSizeMake(200,20));
    }];
}

#pragma 点击事件

-(void)deleClick:(UIButton *)sender
{
    KDSAuthMember *member = self.model;
    KDSUserManager *userMgr = [KDSUserManager sharedManager];
    userMgr.userNickname = [[KDSDBManager sharedManager] queryUserNickname];
    member.adminname = userMgr.userNickname ?: userMgr.user.name;
    NSString *title = Localized(@"DeviceShare_Delete_SureUser");
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Localized(@"MediaLibrary_Cancel") style:UIAlertActionStyleDefault handler:nil];
    [cancel setValue:KDSRGBColor(0x33, 0x33, 0x33) forKey:@"titleTextColor"];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:Localized(@"UnlockModel_Sure") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"DeviceShare_Deleting") toView:self.view];
        [[KDSHttpManager sharedManager] deleteWifiLockAuthorizedUser:member withUid:[KDSUserManager sharedManager].user.uid wifiSN:self.lock.wifiDevice.wifiSN success:^{
            [hud hideAnimated:YES];
            [MBProgressHUD showSuccess:Localized(@"DeviceShare_Delete_Successful")];
            [self.navigationController popViewControllerAnimated:YES];
        } error:^(NSError * _Nonnull error) {
            [hud hideAnimated:YES];
            [MBProgressHUD showError:Localized(@"DeviceShare_Delete_Error")];
        } failure:^(NSError * _Nonnull error) {
            [hud hideAnimated:YES];
            [MBProgressHUD showError:Localized(@"DeviceShare_Delete_Error")];
        }];
    }];
    [ac addAction:cancel];
    [ac addAction:ok];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - 修改设备名称点击事件
-(void)clickEditBtnEditNickname:(UIButton *)sender{
   
    NSString *title = Localized(@"DeviceShare_Write_Name");
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    NSString *placeholder = self.editNicknameLabel.text;
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textAlignment = NSTextAlignmentCenter;
        textField.font = [UIFont systemFontOfSize:12];
        textField.placeholder = placeholder;
        textField.delegate = self;
        [textField addTarget:weakSelf action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Localized(@"MediaLibrary_Cancel") style:UIAlertActionStyleDefault handler:nil];
    [cancel setValue:KDSRGBColor(0x33, 0x33, 0x33) forKey:@"titleTextColor"];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:Localized(@"UnlockModel_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf updateNickname:ac.textFields.firstObject.text];
    }];
    [ac addAction:cancel];
    [ac addAction:ok];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *nameStr = textField.text;

    // 限制输入字符长度
    if (![string isEqualToString:@""]) {
        nameStr = [textField.text stringByAppendingString:string];
    }else{
        nameStr = [nameStr substringWithRange:NSMakeRange(0, textField.text.length-1)];
    }

    //限制输入长度
    if (nameStr.length >10) {
        return NO;
    }

    if (string.length == 0){

        return YES;
    }
    
    return YES;
}

///编辑昵称时输入框文字改变。
- (void)textFieldTextChanged:(UITextField *)sender
{
    //[sender trimTextToLength:-1];
}

///更新昵称。
- (void)updateNickname:(NSString *)nickname
{
    if (nickname.length == 0) return;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    KDSAuthMember *member = self.model;
    NSString *name = member.unickname;
    member.unickname = nickname;
    [[KDSHttpManager sharedManager] updateWifiLockAuthorizedUserNickname:member wifiSN:self.lock.wifiDevice.wifiSN success:^{
         [hud hideAnimated:NO];
         self.editNicknameLabel.text = nickname;
         self.nickNameTipsLb.text = nickname;
         [MBProgressHUD showSuccess:Localized(@"UnlockModel_Setting_Sucessful")];
    } error:^(NSError * _Nonnull error) {
        [hud hideAnimated:NO];
        [MBProgressHUD showError:error.localizedDescription];
        member.unickname = name;
    } failure:^(NSError * _Nonnull error) {
        [hud hideAnimated:NO];
        [MBProgressHUD showError:error.localizedDescription];
        member.unickname = name;
    }];
}

#pragma mark - 懒加载

- (NSDateFormatter *)dateFmt
{
    if (!_dateFmt)
    {
        _dateFmt = [[NSDateFormatter alloc] init];
        _dateFmt.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFmt;
}



@end
