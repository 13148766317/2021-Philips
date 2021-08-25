//
//  PLPScreenLightTimeViewController.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/7/29.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPScreenLightTimeViewController.h"

#import "MBProgressHUD+MJ.h"
#import "KDSCateyeMoreCell.h"
#import "KDSMQTTManager+SmartHome.h"
#import "XMP2PManager.h"
#import "XMUtil.h"
#import "KDSMediaSettingCell.h"

@interface PLPScreenLightTimeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * dataSourceArr;
////当前显示屏亮度时间
@property(nonatomic,assign)NSUInteger currentIndex;
///服务器上的原始显示屏亮度时间
@property(nonatomic,assign)NSUInteger screenLightTimeRawData;

@property (nonatomic,strong)NSArray *screenLightTimesArr;

//自动亮屏
@property (nonatomic,assign) int lightUpScreen;

@end

@implementation PLPScreenLightTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setDataArray];
    
    //初始化主视图
    [self setMainView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = KDSRGBColor(242, 242, 242);
}

#pragma mark - 初始化主视图
- (void)setMainView{
    
    self.navigationTitleLabel.text = @"显示屏时间";
    
    self.lightUpScreen = self.lock.wifiDevice.screenLightSwitch;
    self.currentIndex = self.lock.wifiDevice.screenLightTime.integerValue;
    self.screenLightTimeRawData = self.lock.wifiDevice.screenLightTime.integerValue;
   
    self.tableView.backgroundColor = KDSRGBColor(248, 248, 248);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.view).offset(15);
        make.height.mas_equalTo(300);
    }];
}

-(void)setDataArray{
    
    self.screenLightTimesArr = @[@(5),@(10),@(15)];

    if (_dataSourceArr == nil) {
        _dataSourceArr = [NSMutableArray array];
    }
    [_dataSourceArr addObject:@"5秒"];
    [_dataSourceArr addObject:@"10秒"];
    [_dataSourceArr addObject:@"15秒"];

}
#pragma UITableviewdelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.lightUpScreen == 1) {
        return 2;
    }else {
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else {
        return self.dataSourceArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  65;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        NSString *reuseId = @"自动亮屏";
        KDSMediaSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!cell){
            cell = [[KDSMediaSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.title = reuseId;
        cell.hideSeparator = YES;
        cell.clipsToBounds = YES;

        cell.subtitle = nil;
        cell.hideSwitch = NO;
        cell.switchEnable = YES;
        cell.selectButton.hidden = YES;
        cell.switchOn = self.lightUpScreen == 1 ? YES : NO;
        cell.explain = @"开启后，按门铃时显示屏将自动点亮";
        __weak typeof(self) weakSelf = self;
        cell.switchXMStateDidChangeBlock = ^(UISwitch * _Nonnull sender) {
            [weakSelf lightUpScreenStatus:sender];
        };

        return cell;
    }else {

        KDSCateyeMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:KDSCateyeMoreCell.ID];
        if (!cell)
        {
            cell = [[KDSCateyeMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KDSCateyeMoreCell.ID];
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.titleNameLb.text = self.dataSourceArr[indexPath.row];
        cell.selectBtn.tag = [self.screenLightTimesArr[indexPath.row] integerValue];
        [cell.selectBtn addTarget:self action:@selector(ringNumClick:) forControlEvents:UIControlEventTouchUpInside];

        if (indexPath.row == [self titleIndexFromscreenLightTime:_currentIndex]) {
            cell.selectBtn.selected = YES;
        }
        else{
            cell.selectBtn.selected = NO;
        }
        cell.hideSeparator = YES;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSNumber *currentNumber = self.screenLightTimesArr[indexPath.row];
    _currentIndex = currentNumber.integerValue;
    
    [self.tableView reloadData];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }else {
        return 0;
    }
    
}
#pragma mark 手势
-(void)ringNumClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _currentIndex = sender.tag;
    [self.tableView reloadData];
    
}
- (void)lightUpScreenStatus:(UISwitch *)sender
{
    
    self.lightUpScreen = sender.on?1:0;

    [self.tableView reloadData];
}


///返回按钮：返回即触发设置事件
-(void)navBackClick
{
    __weak typeof(self) weakSelf = self;

    if (self.lightUpScreen == self.lock.wifiDevice.screenLightSwitch && self.currentIndex == self.lock.wifiDevice.screenLightTime.integerValue) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:Localized(@"pleaseWait") toView:self.view];
    [XMP2PManager sharedXMP2PManager].model = self.lock.wifiDevice;
    [[XMP2PManager sharedXMP2PManager] connectDevice];
    [XMP2PManager sharedXMP2PManager].XMP2PConnectDevStateBlock = ^(NSInteger resultCode) {
        if (resultCode > 0) {
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                NSString *message = [NSString stringWithFormat:@"无法连接到设备，原因是：%@", [XMUtil checkPPCSErrorStringWithRet:resultCode]];
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:true];
                }];
                UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重新连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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

    [XMP2PManager sharedXMP2PManager].XMMQTTConnectDevOutTimeBlock = ^{
        ///超时
        [hud hideAnimated:YES];
        NSString *message = [NSString stringWithFormat:@"连接服务器超时，稍后再试"];
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重新连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
            ///讯美登录MQTT成功
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"MQTT 登录成功");
                
                [[KDSMQTTManager sharedManager] setScreenLightWithWf:self.lock.wifiDevice lightUpSwitch:weakSelf.lightUpScreen lightTime:(int)self.currentIndex completion:^(NSError * _Nullable error, BOOL success) {
                    [hud hideAnimated:YES];
                    if (success) {
                        [MBProgressHUD showSuccess:@"设置成功"];
                        self.lock.wifiDevice.screenLightTime = [NSString stringWithFormat:@"%d",(int)self.currentIndex];
                    }else{
                        [MBProgressHUD showError:@"设置失败"];
                    }
                    [[XMP2PManager sharedXMP2PManager] releaseLive];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            });
        }else{
            [hud hideAnimated:YES];
            [MBProgressHUD showError:@"设置失败"];
            [[XMP2PManager sharedXMP2PManager] releaseLive];
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
}

#pragma mark -获取显示屏时间对应标题序号
-(NSInteger) titleIndexFromscreenLightTime:(NSUInteger) hoverAlarmLevel {
    
    __block NSUInteger result = NSNotFound;
    
    [self.screenLightTimesArr enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
            tv;
        });
    }
    return _tableView;
    
}

@end
