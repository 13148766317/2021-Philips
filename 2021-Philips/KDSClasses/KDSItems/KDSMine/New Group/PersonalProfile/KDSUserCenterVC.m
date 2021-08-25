//
//  KDSUserCenterVC.m
//  2021-Philips
//
//  Created by zhaona on 2019/3/31.
//  Copyright © 2019年 com.Kaadas. All rights reserved.
//

#import "KDSUserCenterVC.h"
#import "Masonry.h"
#import "KDSPersonalProfileCell.h"
#import "KDSDBManager.h"
#import "MBProgressHUD+MJ.h"
#import "KDSHttpManager+User.h"
#import "KDSModifyNicknameVC.h"
#import "KDSModifyPwdVC.h"
#import "KDSHttpManager+Login.h"
#import "PLPFormUtils.h"
#import "PLPMineVC.h"
#import "PLPModifyNicknameVC.h"

@interface KDSUserCenterVC () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *logoutBtn;

@end

@implementation KDSUserCenterVC

#pragma mark - 生命周期方法。
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationTitleLabel.text = Localized(@"personalProfile");
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(180);
    }];
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 60;
    self.tableView.bounces = NO;
    
    UIButton *logoutBtn = [PLPFormUtils warningButton:NSLocalizedString(@"logout", nil)];
   
    [logoutBtn addTarget:self action:@selector(clickLogoutBtnLogout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    self.logoutBtn = logoutBtn;
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-80);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        
        make.height.mas_equalTo(44);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.navigationController.navigationBar.barTintColor = KDSRGBColor(242, 242, 242);
    [self getUserNickname];
}

#pragma mark - 控件、手势等事件。
///弹选择图片方式的警告控制器出来时点击屏幕让控制器消失。
- (void)tapToRemoveAlertController:(UITapGestureRecognizer *)tap
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = NSStringFromClass([self class]);
    KDSPersonalProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[KDSPersonalProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    if (indexPath.row == 0)//头像
    {
        cell.title = Localized(@"avatar");
        UIImage *image = cell.image;
        if (!image)
        {
            NSData *data = [[KDSDBManager sharedManager] queryUserAvatarData];
            image = data ? [[UIImage alloc] initWithData:data] : [UIImage imageNamed:@"philips_mine_img_profile"];
        }
        cell.image = image;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 1)//昵称
    {
        cell.title = Localized(@"nickname");
        NSString * tempStr = [KDSUserManager sharedManager].userNickname ?: [KDSUserManager sharedManager].user.name;
        if (tempStr.length > 10) {
            tempStr = [NSString stringWithFormat:@"%@...",[tempStr substringToIndex:10]];
        }
        cell.nickname = tempStr;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 2)//账号
    {
        
        NSString *account = [KDSUserManager sharedManager].user.name;
        BOOL isMail = [KDSTool isValidateEmail:account];
        cell.title = Localized(isMail ? @"email" : @"phoneNumber");
        NSString  * repStr = isMail ? account : [account stringByReplacingCharactersInRange:NSMakeRange(0, KDSTool.crc.length) withString:@""];
        cell.account  =  [repStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    /*
    else//修改密码
    {
        cell.title = Localized(@"modifyPassword");
        cell.isPwdCell = YES;
    }
     */
    cell.hideSeparator = indexPath.row == 3;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)//头像
    {
        __weak typeof(self) weakSelf = self;
        void (^block) (UIImagePickerControllerSourceType) = ^(UIImagePickerControllerSourceType type){
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = weakSelf;
            picker.sourceType = type;
            picker.allowsEditing = YES;
            if (type == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
            {
                picker.navigationBar.translucent = NO;
            }
            [weakSelf presentViewController:picker animated:YES completion:nil];
        };
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *tackPhotoAction = [UIAlertAction actionWithTitle:Localized(@"takePhoto") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            block(UIImagePickerControllerSourceTypeCamera);
        }];
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:Localized(@"selectFromAlbum") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            block(UIImagePickerControllerSourceTypePhotoLibrary);
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [tackPhotoAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
        [photoAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
        [cancelAction setValue:UIColor.blackColor forKey:@"titleTextColor"];
        [alert addAction:photoAction];
        [alert addAction:tackPhotoAction];
        [alert addAction:cancelAction];
        //--防止ipad崩溃--//
        alert.popoverPresentationController.sourceView = self.view;
        alert.popoverPresentationController.sourceRect = CGRectMake(50,50,1.0,1.0);
        
        [self presentViewController:alert animated:YES completion:^{
            NSArray<UIView *> *views = [UIApplication sharedApplication].keyWindow.subviews;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToRemoveAlertController:)];
            [views.lastObject.subviews.firstObject addGestureRecognizer:tap];
        }];
    }
    else if (indexPath.row == 1)//昵称
    {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[PLPMineVC class]]) {
                PLPModifyNicknameVC *A = [[PLPModifyNicknameVC alloc] init];
                [self.navigationController pushViewController:A animated:YES];
                return;
            }
        }
        KDSModifyNicknameVC *vc = [[KDSModifyNicknameVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2)//账号
    {
        
    }
    /*
    else//修改密码
    {
        KDSModifyPwdVC *vc = [[KDSModifyPwdVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
     */
}

#pragma mark - UIImagePickerControllerDelegate，拍照、取照片设置头像。
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    __weak KDSUserCenterVC *weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"ensureModifyAvatar?") message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:Localized(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.removeFromSuperViewOnHide = YES;
            [[KDSHttpManager sharedManager] setUserAvatarImage:image withUid:[KDSUserManager sharedManager].user.uid success:^{
                [[KDSDBManager sharedManager] updateUserAvatarData:UIImagePNGRepresentation(image)];
                KDSPersonalProfileCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                cell.image = image;
                [hud hideAnimated:YES];
                [MBProgressHUD showSuccess:Localized(@"modifyAvatarSuccess")];
            } error:^(NSError * _Nonnull error) {
                [hud hideAnimated:YES];
                [MBProgressHUD showError:[Localized(@"modifyAvatarFailed") stringByAppendingFormat:@": %ld", (long)error.localizedDescription]];
            } failure:^(NSError * _Nonnull error) {
                [hud hideAnimated:YES];
                [MBProgressHUD showError:[Localized(@"modifyAvatarFailed") stringByAppendingFormat:@"，%@", error.localizedDescription]];
            }];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"cancel") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
}
#pragma mark  网络请求的方法
- (void)getUserNickname
{
    __weak  typeof(self)  weakSelf = self;
    KDSUserManager *userMgr = [KDSUserManager sharedManager];
    KDSDBManager *dbMgr = [KDSDBManager sharedManager];
    [[KDSHttpManager sharedManager] getUserNicknameWithUid:userMgr.user.uid success:^(NSString * _Nullable nickname) {
        [dbMgr updateUserNickname:nickname];
        userMgr.userNickname = [[KDSDBManager sharedManager] queryUserNickname];
        [weakSelf.tableView reloadData];
    } error:nil failure:nil];
}

#pragma mark - logout
///点击退出登录按钮发送退出登录通知退出登录。
- (void)clickLogoutBtnLogout:(UIButton *)sender
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:Localized(@"ensureLogout?") message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:Localized(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self userLogoutAcount];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Localized(@"cancel") style:UIAlertActionStyleDefault handler:nil];
    [cancel setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [ac addAction:cancel];
    [ac addAction:ok];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - 网络请求方法。
//用户退出登录
-(void)userLogoutAcount{
    int source = 1;
    NSString *userName = [KDSTool getDefaultLoginAccount];
    if ([KDSTool isValidateEmail:userName])
    {
        source = 2;
    }
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在退出登录" toView:self.view];
    [[KDSHttpManager sharedManager] logout:source username:[KDSTool getDefaultLoginAccount] uid:[KDSUserManager sharedManager].user.uid success:^{
        [hud hideAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:KDSLogoutNotification object:nil userInfo:nil];
    } error:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:error.localizedDescription];
    } failure:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:error.localizedDescription];
    }];
}
@end
