//
//  PLPScreenLightLevelViewController.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/7/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPScreenLightLevelViewController.h"

#import "MBProgressHUD+MJ.h"
#import "KDSCateyeMoreCell.h"
#import "KDSMQTTManager+SmartHome.h"
#import "XMP2PManager.h"
#import "XMUtil.h"

@interface PLPScreenLightLevelViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView * tableView;

@property(nonatomic, strong) NSMutableArray * dataSourceArr;

@property(nonatomic, strong) NSMutableArray * screenLightLevelArr;

//当前开锁验证模式
@property(nonatomic,assign)NSUInteger currentIndex;

//服务器上的原始值
@property(nonatomic,assign)NSUInteger screenLightLevelRawData;

@end

@implementation PLPScreenLightLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //初始化UI
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = KDSRGBColor(242, 242, 242);
}

#pragma mark - 初始化主视图
- (void)setUI{
    
    self.navigationTitleLabel.text = @"显示屏亮度";
    
    self.currentIndex = self.lock.wifiDevice.screenLightLevel.intValue;
    self.screenLightLevelRawData = self.lock.wifiDevice.screenLightLevel.intValue;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.view).offset(15);
        make.height.mas_equalTo(self.dataSourceArr.count * 60);
    }];
}

#pragma UITableviewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KDSCateyeMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:KDSCateyeMoreCell.ID];
    cell.titleNameLb.text = self.dataSourceArr[indexPath.row];
    cell.hideSeparator = YES;
    cell.selectBtn.tag = [self.screenLightLevelArr[indexPath.row] integerValue];
    [cell.selectBtn addTarget:self action:@selector(ringNumClick:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row == [self titleIndexFromScreenLightLevel:_currentIndex]) {
        cell.selectBtn.selected = YES;
    }
    else{
        cell.selectBtn.selected = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *currentNumber = self.screenLightLevelArr[indexPath.row];
    _currentIndex = currentNumber.integerValue;
    
    [self.tableView reloadData];
}

#pragma mark - 手势
-(void)ringNumClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _currentIndex = sender.tag;
    [self.tableView reloadData];
}

#pragma mark - 返回按钮：返回即触发设置事件
-(void)navBackClick
{
    if (self.currentIndex == self.screenLightLevelRawData) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //计划开始转动菊花
    MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"UnlockModel_Uploading") toView:self.view];
    
    //开始连接
    [XMP2PManager sharedXMP2PManager].model = self.lock.wifiDevice;
    [[XMP2PManager sharedXMP2PManager] connectDevice];
    [XMP2PManager sharedXMP2PManager].XMP2PConnectDevStateBlock = ^(NSInteger resultCode) {
        if (resultCode > 0) {
        }else{//连接失败
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                NSString *message = [NSString stringWithFormat:@"%@ %@",Localized(@"RealTimeVideo_Disconnect_Device"), [XMUtil checkPPCSErrorStringWithRet:resultCode]];
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:Localized(@"Message_Progress") message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"RealTimeVideo_Close") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:true];
                }];
                UIAlertAction *retryAction = [UIAlertAction actionWithTitle:Localized(@"RealTimeVideo_Reconnecting") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [XMP2PManager sharedXMP2PManager].model = self.lock.wifiDevice;
                    [[XMP2PManager sharedXMP2PManager] connectDevice];
                    [hud showAnimated:YES];
                }];
                [cancelAction setValue:KDSRGBColor(154, 154, 154) forKey:@"titleTextColor"];
                [retryAction setValue:KDSRGBColor(32, 150, 248) forKey:@"titleTextColor"];
                [controller addAction:cancelAction];
                [controller addAction:retryAction];
                [self presentViewController:controller animated:true completion:nil];
                return;
                
            });
        }
    };
    
    //讯美服务器连接超时
    [XMP2PManager sharedXMP2PManager].XMMQTTConnectDevOutTimeBlock = ^{
        [hud hideAnimated:YES];
        NSString *message = [NSString stringWithFormat:Localized(@"Connect_Sever_Overtime")];
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"RealTimeVideo_Close") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:Localized(@"RealTimeVideo_Reconnecting") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [XMP2PManager sharedXMP2PManager].model = self.lock.wifiDevice;
            [[XMP2PManager sharedXMP2PManager] connectDevice];
            [hud showAnimated:YES];
        }];
        [cancelAction setValue:KDSRGBColor(154, 154, 154) forKey:@"titleTextColor"];
        [retryAction setValue:KDSRGBColor(32, 150, 248) forKey:@"titleTextColor"];
        [controller addAction:cancelAction];
        [controller addAction:retryAction];
        [self presentViewController:controller animated:true completion:nil];
        return;
           
    };
    
    [XMP2PManager sharedXMP2PManager].XMMQTTConnectDevStateBlock = ^(BOOL isCanBeDistributed) {
        if (isCanBeDistributed == YES) {
            //讯美登录MQTT成功
            dispatch_async(dispatch_get_main_queue(), ^{
                [[KDSMQTTManager sharedManager] setScreenBrightnessWithWf:self.lock.wifiDevice brightness:(int)self.currentIndex completion:^(NSError * _Nullable error, BOOL success) {
                    [hud hideAnimated:YES];
                    if (success) {
                        [MBProgressHUD showSuccess:Localized(@"Setting_Status_Successful")];
                        self.lock.wifiDevice.screenLightLevel = [NSString stringWithFormat:@"%d",(int)self.currentIndex];
                    }else{
                        [MBProgressHUD showError:Localized(@"Setting_Status_Fail")];
                    }
                    [[XMP2PManager sharedXMP2PManager] releaseLive];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            });
        }else{
            [hud hideAnimated:YES];
            [MBProgressHUD showError:Localized(@"Setting_Status_Fail")];
            [[XMP2PManager sharedXMP2PManager] releaseLive];
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
}

#pragma mark - 获取显示屏亮度对应标题序号
-(NSInteger) titleIndexFromScreenLightLevel:(NSUInteger) hoverAlarmLevel {
    
    __block NSUInteger result = NSNotFound;
    
    [self.screenLightLevelArr enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj unsignedIntegerValue] == hoverAlarmLevel) {
            result = idx;
            *stop = YES;
        }
        
    }];
    return result;
}

#pragma mark -- lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = ({
            UITableView *tv = [[UITableView alloc] initWithFrame:CGRectZero];
            tv.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tv registerClass:[KDSCateyeMoreCell class] forCellReuseIdentifier:KDSCateyeMoreCell.ID];
            tv.tableFooterView = [UIView new];
            tv.delegate = self;
            tv.dataSource = self;
            tv.scrollEnabled = NO;
            tv.rowHeight = 60;
            tv;
        });
    }
    return _tableView;
}


-(NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray arrayWithObjects:@"高",@"中",@"低", nil];
    }
    return _dataSourceArr;
}

-(NSMutableArray *)screenLightLevelArr{
    if (!_screenLightLevelArr) {
        _screenLightLevelArr = [NSMutableArray arrayWithObjects:@(80),@(50),@(30), nil];
    }
    return _screenLightLevelArr;
}

@end
