//
//  PLPPermanentPasswordViewController PermanentPasswordViewController.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/4/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPPermanentPasswordViewController.h"
#import "PLPChangePasswordNameViewController.h"
#import "PLPPermanentPasswordCell.h"
#import "PLPProgressHub.h"
#import "KDSPwdListModel.h"
#import "PLPPasswordListModel.h"
#import "KDSHttpManager+WifiLock.h"
#import "PLPEmptyDataHub.h"


@interface PLPPermanentPasswordViewController()<UITableViewDelegate,UITableViewDataSource,PLPProgressHubDelegate>

//永久密码UITableView
@property (nonatomic, strong) UITableView *tableView;

//底部删除Button
@property (nonatomic, strong) UIButton *bottomRmoveButton;

//蒙板
@property (nonatomic, strong) UIView *maskView;

//提示框
@property (nonatomic, strong) PLPProgressHub *progressHub;

//接口数据源
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@property (nonatomic, strong) NSMutableArray *nickNameArr;

@property (nonatomic, strong) NSMutableArray *passwordDataArr;

//在数据空的情况下提示框
@property (nonatomic, strong) PLPEmptyDataHub *emptyDataHub;

@end

@implementation PLPPermanentPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化主视图
    [self setupMainView];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadNewData];
}

#pragma mark - 初始化主视图
- (void) setupMainView{
    
    switch (self.keyType) {
        case KDSBleKeyTypePIN:
            self.navigationTitleLabel.text = Localized(@"UnlockModel_Permanent_Pwd");
            break;
        case KDSBleKeyTypeFingerprint:
            self.navigationTitleLabel.text = Localized(@"MessageRecord_Fingerprint");
            break;
        case KDSBleKeyTypeRFID:
            self.navigationTitleLabel.text = Localized(@"MessageRecord_Card");
            break;
        default:
            break;
    }
    
    if (self.keyType == KDSBleKeyTypePIN || self.keyType == KDSBleKeyTypeFingerprint) {
        
        //设置导航栏右Button
        //[self setRightTextButton];
        //self.rightTextButton.selected = NO;
        //[self.rightTextButton setTitle:@"删除" forState:UIControlStateNormal];
        //[self.rightTextButton setTitleColor:KDSRGBColor(46, 101, 158) forState:UIControlStateNormal];
    }
    
    //初始化UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavBarHeight-kStatusBarHeight-60) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = KDSRGBColor(248, 248, 248);
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //添加底部删除Button
    [self.view addSubview:self.bottomRmoveButton];
}

#pragma mark - loading密码、指纹、卡片 密码列表数据
- (void)loadNewData
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"UnlockModel_Uploading") toView:self.view];//pleaseWait
    [[KDSHttpManager sharedManager] getWifiLockPwdListWithUid:[KDSUserManager sharedManager].user.uid wifiSN:self.lock.wifiDevice.wifiSN success:^(NSArray<KDSPwdListModel *> * _Nonnull pwdList, NSArray<KDSPwdListModel *> * _Nonnull fingerprintList, NSArray<KDSPwdListModel *> * _Nonnull cardList, NSArray<KDSPwdListModel *> * _Nonnull faceList, NSArray<KDSPwdListModel *> * _Nonnull pwdNicknameArr, NSArray<KDSPwdListModel *> * _Nonnull fingerprintNicknameArr, NSArray<KDSPwdListModel *> * _Nonnull cardNicknameArr, NSArray<KDSPwdListModel *> * _Nonnull faceNicknameArr, NSArray<KDSPwdListModel *> * _Nonnull pwdDuressArr, NSArray<KDSPwdListModel *> * _Nonnull fingerprintDuressArr) {
        [hud hideAnimated:YES];
        [self.dataSourceArr removeAllObjects];
        [self.nickNameArr removeAllObjects];
        switch (self.keyType) {
            case KDSBleKeyTypePIN://密码
                [self.dataSourceArr addObjectsFromArray:pwdList];
                [self.nickNameArr addObjectsFromArray:pwdNicknameArr];
                
                [self reloadDate];
                break;
            case KDSBleKeyTypeFingerprint://指纹
                [self.dataSourceArr addObjectsFromArray:fingerprintList];
                [self.nickNameArr addObjectsFromArray:fingerprintNicknameArr];
                
                [self reloadDate];
                break;
            case KDSBleKeyTypeRFID://卡片
                [self.dataSourceArr addObjectsFromArray:cardList];
                [self.nickNameArr addObjectsFromArray:cardNicknameArr];
                
                [self reloadDate];
                break;
        
            default:
                break;
        }
    } error:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:error.localizedDescription];
    } failure:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:error.localizedDescription];
    }];
}

#pragma mark - 删除密码接口
-(void)deletePasswordList:(NSArray *)pwdList{
    
    KDSPwdListModel * model = nil;
    model.pwdType = self.keyType;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    [[KDSHttpManager sharedManager] deleteWifiLockPwd:model withUid:[KDSUserManager sharedManager].user.uid wifiSN:self.lock.wifiDevice.wifiSN pwdList:pwdList success:^{
        [hud hideAnimated:NO];
        [MBProgressHUD showSuccess:Localized(@"UnlockModel_Setting_Sucessful")];
    } error:^(NSError * _Nonnull error) {
        [hud hideAnimated:NO];
        [MBProgressHUD showError:error.localizedDescription];
    } failure:^(NSError * _Nonnull error) {
        [hud hideAnimated:NO];
        [MBProgressHUD showError:error.localizedDescription];
    }];
}

#pragma mark - 更新数据源
-(void) reloadDate{
    
    [self.passwordDataArr removeAllObjects];
    
    //数据处理
    for (NSInteger i=0; i< self.dataSourceArr.count; i++) {
        KDSPwdListModel *oldMode = self.dataSourceArr[i];

        PLPPasswordListModel *newModel = [PLPPasswordListModel new];
        newModel.passwordNum = oldMode.num;
        newModel.passwordcreateTime = oldMode.createTime;
        newModel.isSelect = NO;
        newModel.passwordNickName = oldMode.num;
        
        if (self.nickNameArr.count > 0) {
            for (NSInteger j=0; j<self.nickNameArr.count; j++) {
                KDSPwdListModel *nickNameModl = self.nickNameArr[j];
                if ([nickNameModl.num isEqualToString:oldMode.num]) {
                    newModel.passwordNickName = nickNameModl.nickName ?: nickNameModl.num;
                }
            }
        }else{
            newModel.passwordNickName = oldMode.num;
        }
      
        [self.passwordDataArr addObject:newModel];
    }
    
    if (!self.passwordDataArr.count ) {
        [self showEmptyDataHub];
    }else{
        [self dismissEmptyDataHub];
    }
    
    [self.tableView reloadData];
}

#pragma mark - 导航栏右Button点击事件
-(void) navRightTextClick{
    
    self.rightTextButton.selected = !self.rightTextButton.selected;
    
    if (self.rightTextButton.selected) {
        [self.rightTextButton setTitle:Localized(@"MediaLibrary_Cancel") forState:UIControlStateNormal];
        self.bottomRmoveButton.hidden = NO;
    }else{
        [self.rightTextButton setTitle:Localized(@"MessageRecord_Delete") forState:UIControlStateNormal];
        self.bottomRmoveButton.hidden = YES;
    }
    
    //刷新tableView
    [self.tableView reloadData];
}

#pragma mark - 底部删除Button点击事件
-(void) confirmButtonClick{
    
    if ([self pwdListForSelect].count > 0) {
        
        [self showContactView];
    }else{
        [MBProgressHUD showError:Localized(@"UnlockModel_Choicing_DeletePwd")];
    }
}

#pragma mark - 筛选出选中将要删除的密码
-(NSArray *)pwdListForSelect{
    
    NSMutableArray *selectPwdList = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i=0; i<self.passwordDataArr.count; i++) {
        PLPPasswordListModel *listModel = self.passwordDataArr[i];
        if (listModel.isSelect) {
            NSDictionary *dic = @{@"num":@([listModel.passwordNickName intValue])};
            [selectPwdList addObject:dic];
        }
    }
    
    NSArray *pwdList = selectPwdList;
    
    return pwdList;
}

#pragma mark -PLPProgressHubDelegate(弹窗)
-(void) informationBtnClick:(NSInteger)index{
    
    switch (index) {
        case 10://取消
        {
            [self dismissContactView];
            
            break;
        }
        case 11://删除
        {
            //调用删除密码接口
            [self deletePasswordList:[self pwdListForSelect]];
            
            //将弹框收回
            [self dismissContactView];
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 170;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.passwordDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"PLPPermanentPasswordCell";
    PLPPermanentPasswordCell *cell = (PLPPermanentPasswordCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"PLPPermanentPasswordCell" owner:nil options:nil];
        cell = [nibArr objectAtIndex:0];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    PLPPasswordListModel *model = self.passwordDataArr[indexPath.row];
    
    if (self.keyType == KDSBleKeyTypePIN) {//密码
        cell.passwordTitleLabel.text = [NSString stringWithFormat:@"%@:%02d",Localized(@"MessageRecord_Password"),model.passwordNum.intValue  ?: @"".intValue];
    }else if (self.keyType == KDSBleKeyTypeFingerprint){//指纹
        cell.passwordTitleLabel.text = [NSString stringWithFormat:@"%@:%@",Localized(@"MessageRecord_Fingerprint"),model.passwordNum ?: @""];
    }else{//卡片
        cell.passwordTitleLabel.text = [NSString stringWithFormat:@"%@:%@",Localized(@"MessageRecord_Card"),model.passwordNum ?: @""];
    }
    cell.passwordNameLabel.text = [KDSTool showNameStr:model.passwordNickName Length:5] ?: @"";
    cell.addTimeTltleLabel.text = Localized(@"UnlockModel_Add_Time");
    cell.addTimeLabel.text  = [KDSTool timeStringYYMMDDFromTimestamp:[NSString stringWithFormat:@"%f",model.passwordcreateTime]];
    
    if (self.keyType == KDSBleKeyTypePIN || self.keyType == KDSBleKeyTypeFingerprint) {
        if (self.rightTextButton.selected) {
            cell.removeButton.hidden = NO;
            if (model.isSelect) {
                [cell.removeButton setBackgroundImage:[UIImage imageNamed:@"philips_icon_selected"] forState:UIControlStateNormal];
            }else{
                [cell.removeButton setBackgroundImage:[UIImage imageNamed:@"philips_icon_default"] forState:UIControlStateNormal];
            }
        }else{
            cell.removeButton.hidden = YES;
        }
    }else{
        cell.removeButton.hidden = YES;
    }
    
    return cell;
}

#pragma mark - UITableView 点击代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PLPChangePasswordNameViewController *changePasswordVC = [PLPChangePasswordNameViewController new];
    changePasswordVC.lock = self.lock;
    PLPPasswordListModel *model = self.passwordDataArr[indexPath.row];
    
    KDSPwdListModel *newModel = self.dataSourceArr[indexPath.row];
    
    if (self.keyType == KDSBleKeyTypePIN || self.keyType == KDSBleKeyTypeFingerprint || self.keyType == KDSBleKeyTypeRFID) {
        if (self.rightTextButton.selected) {//选择删除
            model.isSelect = !model.isSelect;
            [self.tableView reloadData];
        }else{
            changePasswordVC.keyType = self.keyType;
            changePasswordVC.model = newModel;
            changePasswordVC.nickName = model.passwordNickName;
            [self.navigationController pushViewController:changePasswordVC animated:YES];
        }
    }else{//临时密码跳转
        changePasswordVC.keyType = self.keyType;
        [self.navigationController pushViewController:changePasswordVC animated:YES];
    }
}

#pragma mark - PLPProgressHub显示视图
-(void)showContactView{
    
    [_maskView removeFromSuperview];
    [_progressHub removeFromSuperview];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _maskView.alpha = 0.5;
    _maskView.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    
    NSString *progressStr = nil;
    switch (self.keyType) {
        case KDSBleKeyTypePIN:
            progressStr = Localized(@"UnlockModel_Delete_Pwd");
            break;
        case KDSBleKeyTypeFingerprint:
            progressStr = Localized(@"UnlockModel_Delete_Fingerprint");
            break;
        case KDSBleKeyTypeRFID:
            progressStr = Localized(@"UnlockModel_Delete_Card");
            break;
        default:
            break;
    }
    
    _progressHub = [[PLPProgressHub alloc] initWithFrame:CGRectMake(50, kScreenHeight/2 - 150/2, kScreenWidth-100, 150) Title:progressStr];
    _progressHub.backgroundColor = [UIColor whiteColor];
    _progressHub.progressHubDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_progressHub];
}

#pragma mark - PLPProgressHub删除视图
-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.maskView removeFromSuperview];
        [weakSelf.progressHub removeFromSuperview];
    }];
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismissContactView];
}

#pragma mark - 在数据为空时提示视图加载
-(void) showEmptyDataHub{
    
    [self.emptyDataHub removeFromSuperview];
    
    self.emptyDataHub = [[PLPEmptyDataHub alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavBarHeight-kStatusBarHeight-60) HeadImage:[UIImage imageNamed:@"PLPEmptyData_Normal"] Title:Localized(@"UnlockModel_No_Record")];
    [self.tableView addSubview:self.emptyDataHub];
}

-(void)dismissEmptyDataHub
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
       
    } completion:^(BOOL finished) {
        [weakSelf.emptyDataHub removeFromSuperview];
    }];
}

#pragma mark - 懒加载

-(NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataSourceArr;
}

-(NSMutableArray *)nickNameArr{
    if (!_nickNameArr) {
        _nickNameArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _nickNameArr;
}

-(NSMutableArray *) passwordDataArr{
    if (!_passwordDataArr) {
        _passwordDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _passwordDataArr;
}

-(UIButton *)bottomRmoveButton{
    if (!_bottomRmoveButton) {
        _bottomRmoveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomRmoveButton setFrame:CGRectMake(10, self.tableView.frame.origin.y + self.tableView.frame.size.height + 10, kScreenWidth-20, 40)];
        [_bottomRmoveButton setBackgroundColor:KDSRGBColor(45, 100, 158)];
        [_bottomRmoveButton setTitle:Localized(@"MessageRecord_Delete") forState:UIControlStateNormal];
        _bottomRmoveButton.hidden = YES;
        [_bottomRmoveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomRmoveButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _bottomRmoveButton;;
}

@end
