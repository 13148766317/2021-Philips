//
//  PLPDuressPasswordDetailViewController.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/12.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPDuressPasswordDetailViewController.h"
#import "PLPDuressAlarmCell.h"
#import "PLPDuressPasswordCell.h"
#import "PLPDuressSettingAccountController.h"
#import "PLPDuressAlarmHub.h"
#import "KDSHttpManager+WifiLock.h"


@interface PLPDuressPasswordDetailViewController ()<UITableViewDelegate,UITableViewDataSource,PLPDuressAlarmHubDelegate>

//开锁方式主UITableView
@property (nonatomic, strong) UITableView *tableView;

//数据源
@property (nonatomic, strong) NSArray *dataArr;

//蒙板
@property (nonatomic, strong) UIView *maskView;

//提示框
@property (nonatomic, strong) PLPDuressAlarmHub *duressAlarmHub;

@end

@implementation PLPDuressPasswordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化主视图
    [self setupMainView];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //刷新数据列表
    [self loadPwdbListData];
}

#pragma mark - 初始化主界面
-(void) setupMainView{
    
    self.navigationTitleLabel.text = Localized(@"DevicesDetailSetting_Setting_DuressAlarm");
    self.view.backgroundColor = KDSRGBColor(248, 248, 248);

    //设置右Button 胁迫报警提示
    [self setRightButton];
    [self.rightButton setImage:[UIImage imageNamed:@"philips_icon_help"] forState:UIControlStateNormal];
    
    //初始化UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = KDSRGBColor(248, 248, 248);
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - 修改胁迫报警属性接口
-(void) loadNewData:(int)index{
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"UnlockModel_Uploading") toView:self.view];
    [[KDSHttpManager sharedManager] setDuressAlarmSinglePwdSwitchWithUid:[KDSUserManager sharedManager].user.uid WifiSN:self.lock.wifiDevice.wifiSN PwdType:self.model.pwdType Num:self.model.num.intValue PwdDuressSwitch:index success:^{
        [hud hideAnimated:YES];
        [MBProgressHUD showSuccess:Localized(@"Message_Save_Successful")];
        
        [self loadPwdbListData];
    } error:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:error.localizedDescription];
    } failure:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:error.localizedDescription];
    }];
}

#pragma mark - loading密码、指纹、卡片 密码列表数据
- (void)loadPwdbListData
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"UnlockModel_Uploading") toView:self.view];
    
    [[KDSHttpManager sharedManager] getWifiLockPwdListWithUid:[KDSUserManager sharedManager].user.uid wifiSN:self.lock.wifiDevice.wifiSN success:^(NSArray<KDSPwdListModel *> * _Nonnull pwdList, NSArray<KDSPwdListModel *> * _Nonnull fingerprintList, NSArray<KDSPwdListModel *> * _Nonnull cardList, NSArray<KDSPwdListModel *> * _Nonnull faceList, NSArray<KDSPwdListModel *> * _Nonnull pwdNicknameArr, NSArray<KDSPwdListModel *> * _Nonnull fingerprintNicknameArr, NSArray<KDSPwdListModel *> * _Nonnull cardNicknameArr, NSArray<KDSPwdListModel *> * _Nonnull faceNicknameArr, NSArray<KDSPwdListModel *> * _Nonnull pwdDuressArr, NSArray<KDSPwdListModel *> * _Nonnull fingerprintDuressArr) {
        //停止菊花转动
        [hud hideAnimated:YES];
        
        if (self.accountType == 1) {//密码列表
            [self updatePwdListDataSource:pwdList PwdDuressArr:pwdDuressArr];
        }else{
            [self updatePwdListDataSource:fingerprintList PwdDuressArr:fingerprintDuressArr];
        }
        
        //刷新列表
        [self.tableView reloadData];
    } error:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:error.localizedDescription];
    } failure:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:error.localizedDescription];
    }];
}

#pragma mark - 更新数据 -- 密码列表
-(void) updatePwdListDataSource:(NSArray *) pwdListArr PwdDuressArr:(NSArray *)duressArr{
    
    //填充数据--密码列表
    for (NSInteger i=0; i< duressArr.count; i++) {
        KDSPwdListModel *duressModel = duressArr[i];
        if ([duressModel.num isEqualToString:self.model.num]) {
            self.model.pwdDuressSwitch = duressModel.pwdDuressSwitch;
            break;
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        return 100;
    }else{
        return 65;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return 40;
    }else{
        
        return 15;;
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.model.pwdDuressSwitch == 1) {
        return 3;
    }else{
        return 1;
    }
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KDSScreenWidth, 40)];
        headerView.backgroundColor = self.view.backgroundColor;
        
        //显示密码类型
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = Localized(@"DevicesDetailSetting_Receive_DuressAlarm");
        [headerView addSubview:titleLabel];
        
        return headerView;
    }else{
        
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KDSScreenWidth, 15)];
        headerView.backgroundColor = self.view.backgroundColor;
        
        return headerView;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        
        static NSString *cellId = @"PLPDuressAlarmCell";
        PLPDuressAlarmCell *cell = (PLPDuressAlarmCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"PLPDuressAlarmCell" owner:nil options:nil];
            cell = [nibArr objectAtIndex:0];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
        if (indexPath.section == 0) {
            cell.markImageView.hidden = YES;
            cell.alarmSwitch.hidden = NO;
            cell.titleLabel.text = self.dataArr[indexPath.row];
            cell.subtitleLabel.text = Localized(@"DevicesDetailSetting_Open_Fingerprint");
            cell.alarmSwitch.on = self.model.pwdDuressSwitch;
            [cell.alarmSwitch addTarget:self action:@selector(alarmSwitchClick:) forControlEvents:UIControlEventValueChanged];
        }else{
            cell.markImageView.hidden = NO;
            cell.alarmSwitch.hidden = YES;
            cell.titleLabel.text = Localized(@"MessageRecord_APP_Receive");
            cell.subtitleLabel.text = Localized(@"DevicesDetailSetting_DuressAlarm_Message");
        }
        
        return cell;
    }else{
        
        static NSString *cellIdOne = @"PLPDuressPasswordCell";
        PLPDuressPasswordCell *cellOne = (PLPDuressPasswordCell *)[tableView dequeueReusableCellWithIdentifier:cellIdOne];
        if (!cellOne) {
            NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"PLPDuressPasswordCell" owner:nil options:nil];
            cellOne = [nibArr objectAtIndex:0];
            cellOne.backgroundColor = [UIColor whiteColor];
            cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
        cellOne.markImageView.hidden = YES;
        cellOne.alarmNumberLabel.hidden = YES;
        cellOne.alarmNumberTitleLabel.hidden = YES;
        cellOne.nameLabel.text = [NSString stringWithFormat:@"%2@",self.model.num] ?: @"";
        cellOne.alarmTypeLabel.text = Localized(@"UnlockModel_Add_Time");
        cellOne.alarmStatusLabel.text = [KDSTool timeStringYYMMDDFromTimestamp:[NSString stringWithFormat:@"%f",self.model.createTime]] ?: @"";

        return cellOne;
    }
}

#pragma mark - UITableView 点击代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
    
        PLPDuressSettingAccountController *settingAccountVC = [PLPDuressSettingAccountController new];
        settingAccountVC.lock = self.lock;
        settingAccountVC.model = self.model;
        [self.navigationController pushViewController:settingAccountVC animated:YES];
    }
}

#pragma mark - 顶部导航栏右Button点击事件
-(void) navRightClick{
    
    [self showContactView];
}

#pragma mark - 顶部胁迫报警开关按钮
-(void) alarmSwitchClick:(UISwitch *)sender{
    
    //提交数据
    [self loadNewData:sender.on ? 1 : 0];
}

#pragma mark - PLPDuressAlarmHub显示视图
-(void)showContactView{
    
    [_maskView removeFromSuperview];
    [_duressAlarmHub removeFromSuperview];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _maskView.alpha = 0.5;
    _maskView.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    
    _duressAlarmHub = [[PLPDuressAlarmHub alloc] initWithFrame:CGRectMake(15, kNavBarHeight + kStatusBarHeight, kScreenWidth-30, kScreenHeight - kNavBarHeight - kStatusBarHeight)];
    _duressAlarmHub.backgroundColor = [UIColor clearColor];
    _duressAlarmHub.duressAlarmHubDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_duressAlarmHub];
}

#pragma mark - PLPDuressAlarmHub删除视图
-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.maskView removeFromSuperview];
        [weakSelf.duressAlarmHub removeFromSuperview];
    }];
}

#pragma mark -PLPDuressAlarmHub代理事件
-(void) removeDuressAlarmHub{
    
    [self dismissContactView];
}

#pragma mark - 懒加载

-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[Localized(@"DevicesDetailSetting_DuressAlarm")];
    }
    
    return _dataArr;
}


@end
