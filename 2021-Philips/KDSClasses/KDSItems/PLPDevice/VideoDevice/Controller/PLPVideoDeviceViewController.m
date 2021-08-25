//
//  PLPVideoDeviceViewController.m
//  2021-Philips
//
//  Created by Frank Hu on 2021/4/21.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPVideoDeviceViewController.h"

//开锁方式
#import "PLPUnlockModelViewController.h"
#import "KDSWifiLockPwdShareVC.h"

//消息记录
#import "KDSMediaLockRecordDetailsVC.h"

//设置
#import "KDSMediaLockMoreSettingVC.h"

#import "PLPProgressHub.h"
#import "KDSHttpManager+VideoWifiLock.h"
#import "KDSMediaLockParamVC.h"

@interface PLPVideoDeviceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,PLPProgressHubDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

//标题数组和图片数组
@property(nonatomic,strong) NSArray * titles;
@property(nonatomic,strong) NSArray * titleImags;

@property(nonatomic,strong) UILabel * lastRecordText;
@property(nonatomic,strong) UILabel * modelLabel;

//显示电量图片、电量和日期的按钮，设置这些属性时使用方法setPowerWithImage:power:date:@see setPowerWithImage:power:date:
@property (nonatomic, weak) UIButton *powerInfoBtn;

//电量内框图片。
@property (nonatomic, strong) UIImageView *powerIV;

///上个导航控制器的代理。
@property (nonatomic, weak) id<UINavigationControllerDelegate> preDelegate;

@property (nonatomic,strong)PLPVideoDeviceFunctionListModel *PLPVideoDeviceFunctionListModel;

//锁状态。
@property (nonatomic, assign) KDSLockState lockState;

//蒙板
@property (nonatomic, strong) UIView *maskView;

//提示框
@property (nonatomic, strong) PLPProgressHub *progressHub;

@end

@implementation PLPVideoDeviceViewController

#pragma mark - View生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //初始化主视图
    [self setupUI];
}

#pragma mark - 初始化主视图
-(void)setupUI{
    
    //5.14.党万振修改
    //设备名称显示规则 默认显示设备销售型号，修改后，显示修改后的名称
    self.navigationTitleLabel.text = [KDSTool showNameStr:self.lock.wifiDevice.lockNickname Length:10] ?: [KDSTool showNameStr:self.lock.wifiDevice.productModel Length:10];
    
    //右上角设置按钮
    [self setRightButton];
    if (self.lock.wifiDevice.isAdmin.intValue == 1) {//管理员权限
        [self.rightButton setImage:[UIImage imageNamed:@"philips_mine_icon_setting"] forState:UIControlStateNormal];
    }else{//被分享用户权限
        [self.rightButton setImage:[UIImage imageNamed:@"philips_equipment_icon_delete"] forState:UIControlStateNormal];
    }

    //显示wifi的图标
    UIImageView  *wifiImg = [UIImageView new];
    wifiImg.image = [UIImage imageNamed:@"philips_equipment_icon_wifi"];
    [self.view  addSubview:wifiImg];
    [wifiImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(19);// 加上navbar的高度
        make.height.width.equalTo(@20);
        make.width.equalTo(@20);
        make.left.equalTo(self.view).offset(16);
    }];
    
    UIButton *powerInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    powerInfoBtn.enabled = NO;
    _powerInfoBtn = powerInfoBtn;
    _powerInfoBtn.backgroundColor = UIColor.clearColor;
    [self.view  addSubview:_powerInfoBtn];
    [_powerInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(19);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        make.left.equalTo(wifiImg.mas_right).offset(10);
    }];
    //显示电量的图标
    _powerIV = [UIImageView new];
    [self.view  addSubview:_powerIV];
    [_powerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_powerInfoBtn.imageView).offset(1.5);
        make.width.equalTo(@20);
        make.bottom.equalTo(_powerInfoBtn.imageView).offset(-1.5);
    }];
    [self setPowerWithImage:nil power:self.lock.wifiDevice.power date:nil];

    //模式
    _modelLabel = [UILabel new];
    _modelLabel.font= [UIFont systemFontOfSize:15];
    _modelLabel.textColor = KDSRGBColor(33, 32, 57);
    _modelLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_modelLabel];
    [_modelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(23);
        make.width.equalTo(@65);
        make.height.equalTo(@19);
        make.right.equalTo(self.view).offset(-43);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureImageViewUnlock:)];
    //显示门锁大图标
    UIImageView  *middleImg = [UIImageView new];
    [middleImg addGestureRecognizer:tapGesture];
    middleImg.userInteractionEnabled = YES;
    middleImg.image = [UIImage imageNamed:@"philips_equipment_icon_video"];
    [self.view  addSubview:middleImg];
    [middleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(95);// 要加上navbar的高度
        make.height.width.equalTo(@161);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    //记录
    _lastRecordText = [UILabel new];
    _lastRecordText.font = [UIFont systemFontOfSize:14];
    _lastRecordText.textAlignment = NSTextAlignmentCenter;
    _lastRecordText.backgroundColor = [UIColor redColor];
    [self.view addSubview:_lastRecordText];
    [_lastRecordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleImg.mas_bottom).offset(42);
        make.left.equalTo(self.view).offset(60);
        make.right.equalTo(self.view).offset(-60);
    }];
    
    // 使用collectionVeiw 实现 功能按键
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(_lastRecordText.mas_bottom).offset(126);
        make.bottom.equalTo(self.view).offset(-36);
        make.left.equalTo(self.view).offset(15);
        make.size.mas_offset(CGSizeMake(kScreenWidth - 30, 140));
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.preDelegate = self.navigationController.delegate;
    self.navigationController.delegate = self;
    
    [self initializeLockState];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.delegate = self.preDelegate;
}

#pragma mark - UICollectionView 代理的实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.PLPVideoDeviceFunctionListModel.funcListArray.count?:self.PLPVideoDeviceFunctionListModel.funcListArray.count;
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PLPVideoDeviceFunctionListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PLPVideoDeviceFunctionListCell" forIndexPath:indexPath];
    
    cell.functionlabel.text = self.PLPVideoDeviceFunctionListModel.funcListArray[indexPath.row][@"message"];
    
    cell.coverImageView.image =[UIImage imageNamed:self.PLPVideoDeviceFunctionListModel.funcListArray[indexPath.row][@"image"]];
    
    return cell;
}

//collectionView的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PLPVideoDeviceFunctionListCell * cell = (PLPVideoDeviceFunctionListCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.functionlabel.text = self.PLPVideoDeviceFunctionListModel.funcListArray[indexPath.row][@"message"];
    if ([cell.functionlabel.text isEqualToString:Localized(@"RecordMessage")]){
        //动态记录
        KDSMediaLockRecordDetailsVC * vc = [KDSMediaLockRecordDetailsVC new];
        vc.lock = self.lock;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }else if ([cell.functionlabel.text isEqualToString:Localized(@"My_Album")]){
        //相册
        KDSMyAlbumVC * vc = [KDSMyAlbumVC new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.lock = self.lock;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([cell.functionlabel.text isEqualToString:Localized(@"PasswordList")]){
        //密匙
        //KDSWifiLockPwdListVC *vc = [KDSWifiLockPwdListVC new];
        //vc.keyType = KDSBleKeyTypePIN;
        //vc.hidesBottomBarWhenPushed = YES;
        //vc.lock = self.lock;
        //[self.navigationController pushViewController:vc animated:YES];
        
        PLPUnlockModelViewController *unlockModelVC = [PLPUnlockModelViewController new];
        unlockModelVC.hidesBottomBarWhenPushed = YES;
        unlockModelVC.lock = self.lock;
        [self.navigationController pushViewController:unlockModelVC animated:YES];
    }else if ([cell.functionlabel.text isEqualToString:Localized(@"Device_Share")]){
        //设备分享
        KDSLockKeyVC *vc = [KDSLockKeyVC new];
        vc.keyType = KDSBleKeyTypeReserved;
        vc.lock = self.lock;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//两行cell之间的最小间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 12;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
     [navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 通知
//当电量状态刷新时，修改当前页面的电量。
- (void)refreshInterfaceWhenDeviceDidSync:(NSNotification *)noti{
    
    [self setPowerWithImage:nil power:self.lock.wifiDevice.power date:nil];
}

//当状态刷新时，修改当前页面的门锁状态。


//目前飞利浦视频锁定义的模式：安全>布防>节能>正常模式（开锁状态、反锁、面容、锁舌伸出等其他模式）
-(void)initializeLockState{
   
   self.lock.state = KDSLockStateNormal;
    
   if (self.lock.wifiDevice.openStatus == 3
       ||self.lock.wifiDevice.amMode.intValue
       ||self.lock.wifiDevice.operatingMode.intValue) {
       self.lock.state = KDSLockStateNormal;
   }
   if (self.lock.wifiDevice.powerSave.intValue == 1) {
        self.lock.state = KDSLockStateEnergy;
   }if (self.lock.wifiDevice.defences.intValue == 1) {
        self.lock.state = KDSLockStateDefence;
   }if (self.lock.wifiDevice.safeMode.intValue == 1) {
        self.lock.state = KDSLockStateSecurityMode;
   }
    
    [self updateLockState:self.lock.state];
}

//目前飞利浦视频锁定义的模式：正常模式（开锁状态、反锁、面容、锁舌伸出等其他模式）
- (void)updateLockState:(KDSLockState)lockState
{
    _lockState = lockState;
    self.lock.state = lockState;
    switch (lockState)
    {
        case KDSLockStateDefence:
            
            _modelLabel.text = Localized(@"ProtectionMode");//布防模式
            break;
            
        case KDSLockStateSecurityMode:
           
            _modelLabel.text = Localized(@"DualValidationMode");//安全模式
            break;
        case KDSLockStateEnergy:
            
            _modelLabel.text = Localized(@"PowerSavingMode");//节能模式
            break;
        
        default:
            _modelLabel.text = Localized(@"NormalMode");
            break;
    }
}

/**
 *@brief 设置电量图片、电量和日期。
 *@param image 电量图片。如果为空，则根据电量进行选择。
 *@param power 电量，0-100，负数不显示.
 *@param date 日期，格式yyyy/MM/dd。如果为空，则使用手机当前时间。
 */
- (void)setPowerWithImage:(nullable UIImage *)image power:(int)power date:(nullable NSString *)date
{
    float width = power/100.0;
    if (!image){
        image = [UIImage imageNamed:@"philips_equipment_icon_battery"];
    }
    self.powerIV.image = [UIImage imageNamed:power<30 ? @"philips_equipment_icon_battery" : @"philips_equipment_icon_battery"];
    
    [self.powerInfoBtn setImage:image forState:UIControlStateNormal];

    [self.powerIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(17 * width));
    }];
}

#pragma mark - 控件等事件方法。
///长按中间的浅绿色视图开锁。为方便其它页面发起的通知开锁，sender传nil和手势共用一个方法。
- (void)tapGestureImageViewUnlock:(UITapGestureRecognizer *)sender
{
    if (self.lock.wifiDevice.distributionNetwork == 3) {
        if (self.lock.wifiDevice.powerSave.intValue == 1) {
            ///锁已开启节能模式，无法查看门外情况
            UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:Localized(@"PowerSavingMode_UnableToViewOutside") message:Localized(@"ReplaceBattery") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *retryAction = [UIAlertAction actionWithTitle:Localized(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            //修改title Font
            NSMutableAttributedString *alertTitleStr = [[NSMutableAttributedString alloc] initWithString:Localized(@"PowerSavingMode_UnableToViewOutside")];
            [alertTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, alertTitleStr.length)];
            [alerVC setValue:alertTitleStr forKey:@"attributedTitle"];

            //修改message Font
            NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:Localized(@"ReplaceBattery")];
            [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:KDSRGBColor(153, 153, 153) range:NSMakeRange(0, alertControllerMessageStr.length)];
            [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, alertControllerMessageStr.length)];
            
            [alerVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
            [retryAction setValue:KDSRGBColor(32, 150, 248) forKey:@"titleTextColor"];
            
            [alerVC addAction:retryAction];
            [self presentViewController:alerVC animated:YES completion:nil];
            return;
        }
        //跳转到视频连接页面
        XMPlayController *vc = [[XMPlayController alloc] initWithType:XMPlayTypeLive];
        vc.lock = self.lock;
        vc.isActive = YES;
        [self.navigationController pushViewController:vc animated:true];
    }else{
        UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:nil message:Localized(@"DoNotClick") preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alerVC animated:YES completion:nil];
        [self performSelector:@selector(dismiss:) withObject:alerVC afterDelay:2.0];
        return;
    }
}
- (void)dismiss:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 右上角 设置点击事件  
-(void) navRightClick{
    
    if (self.lock.wifiDevice.isAdmin.intValue == 1) {
        KDSMediaLockMoreSettingVC * vc = [KDSMediaLockMoreSettingVC new];
        vc.lock = self.lock;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self showContactView];
    }

    
    //暂时预留，被邀请用户的设置主页
    //if (self.lock.wifiDevice.productModel == nil) {
    //    [MBProgressHUD showError:@"暂无设备信息"];
    //    return;
    //}

    //KDSMediaLockParamVC * vc = [KDSMediaLockParamVC new];
    //vc.lock = self.lock;
    //[self.navigationController pushViewController:vc animated:YES];
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
            [self deleteBindedDevice];
            
            [self dismissContactView];
            
            break;
        }
            
        default:
            break;
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
    
    _progressHub = [[PLPProgressHub alloc] initWithFrame:CGRectMake(50, kScreenHeight/2 - 150/2, kScreenWidth-100, 150) Title:@"确定删除设备吗？"];
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

#pragma mark -删除绑定的设备
- (void)deleteBindedDevice
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"deleting") toView:self.view];
    [[KDSHttpManager sharedManager] unbindXMMediaWifiDeviceWithWifiSN:self.lock.wifiDevice.wifiSN uid:[KDSUserManager sharedManager].user.uid success:^{
        [hud hideAnimated:YES];
        [MBProgressHUD showSuccess:Localized(@"deleteSuccess")];
        [[NSNotificationCenter defaultCenter] postNotificationName:KDSLockHasBeenDeletedNotification object:nil userInfo:@{@"lock" : self.lock}];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } error:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:[Localized(@"deleteFailed") stringByAppendingFormat:@", %@", error.localizedDescription]];
    } failure:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showError:[Localized(@"deleteFailed") stringByAppendingFormat:@", %@", error.localizedDescription]];
    }];
}


#pragma mark - 控件懒加载
- (PLPVideoDeviceFunctionListModel *)PLPVideoDeviceFunctionListModel{
    if (_PLPVideoDeviceFunctionListModel == nil) {

        _PLPVideoDeviceFunctionListModel = [[PLPVideoDeviceFunctionListModel alloc] init];

    }
    return _PLPVideoDeviceFunctionListModel;
}

- (UICollectionView *)collectionView{
    if (_collectionView ==nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (kScreenWidth - 50) / 2;
        CGFloat itemH = 60;
        layout.itemSize = CGSizeMake(itemW, itemH);
        //layout.sectionInset = UIEdgeInsetsMake(40, 5, 40, 5);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
       // layout.minimumLineSpacing = 20;
       // layout.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PLPVideoDeviceFunctionListCell class] forCellWithReuseIdentifier:@"PLPVideoDeviceFunctionListCell"];
    }
    
    return _collectionView;
}
@end
