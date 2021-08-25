//
//  PLPOpenDirectionViewController.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/7/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPOpenDirectionViewController.h"

#import "MBProgressHUD+MJ.h"
#import "KDSCateyeMoreCell.h"
#import "KDSMQTTManager+SmartHome.h"
#import "XMP2PManager.h"
#import "XMUtil.h"

@interface PLPOpenDirectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * dataSourceArr;

//当前开锁验证模式
@property(nonatomic,assign)NSUInteger currentIndex;

//服务器上的原始值
@property(nonatomic,assign)NSUInteger volLevelDataModel;

@end

@implementation PLPOpenDirectionViewController

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
    
    self.navigationTitleLabel.text = @"开门方向";
    
    self.currentIndex = self.lock.wifiDevice.openDirection.intValue;
    self.volLevelDataModel = self.lock.wifiDevice.openDirection.intValue;
    
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
    cell.selectBtn.tag = indexPath.row+1;
    [cell.selectBtn addTarget:self action:@selector(ringNumClick:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row == _currentIndex-1) {
        cell.selectBtn.selected = YES;
    }
    else{
        cell.selectBtn.selected = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentIndex = indexPath.row+1;
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
    if (self.currentIndex == self.volLevelDataModel) {
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
                [[KDSMQTTManager sharedManager] setOpenDirectionWithWf:self.lock.wifiDevice value:(int)self.currentIndex completion:^(NSError * _Nullable error, BOOL success) {
                    [hud hideAnimated:YES];
                    if (success) {
                        [MBProgressHUD showSuccess:Localized(@"Setting_Status_Successful")];
                        self.lock.wifiDevice.openDirection = [NSString stringWithFormat:@"%d",(int)self.currentIndex];
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
        _dataSourceArr = [NSMutableArray arrayWithObjects:@"左开门",@"右开门", nil];
    }
    return _dataSourceArr;
}




@end
