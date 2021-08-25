//
//  KDSVideoLockDistributionNetworkVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2020/9/10.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSVideoLockDistributionNetworkVC.h"
#import "KDSXMMediaLockHelpVC.h"
#import "KDSAddWiFiLockFailVC.h"
#import "KDSMediaLockInPutAdminPwdVC.h"
#import "KDSAddVideoWifiLockStep1VC.h"
#import "KDSAddVideoWifiLockStep3VC.h"

#import "HWCircleView.h"
@interface KDSVideoLockDistributionNetworkVC ()


///是否允许跳转到下一个页面默认允许
@property (nonatomic,assign)BOOL isJumped;
///交换数据后如果15秒内有网络且请求成功即成功反之失败（绑定过程会切换两次网络，交换数据用锁广播的热点）
@property (nonatomic,strong)NSString * currentSsid;

///是否已经push过（只能执行一次）
@property (nonatomic, assign) BOOL ispushing;
// 自定义进度条
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) HWCircleView *circleView;

// 按钮是否选中控制
@property (nonatomic ,strong) UIButton  * btnone ;

@property (nonatomic ,strong) UIButton  * btntwo ;

@property (nonatomic ,strong) UIButton  * btnthere ;
// 文字颜色控制

@property (nonatomic ,strong) UILabel  * sendone ;

@property (nonatomic ,strong) UILabel  * sendtwo ;

@property (nonatomic ,strong) UILabel  * sendthere ;

@end

@implementation KDSVideoLockDistributionNetworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationTitleLabel.text = Localized(@"配网中");
    [self setRightButton];
    [self setUI];
    
   
    [self.rightButton setImage:[UIImage imageNamed:@"philips_icon_help"] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.ispushing = YES;
   
    //添加定时器
    [self addTimer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaLockBindStatus:) name:KDSMQTTEventNotification object:nil];
}
#pragma makr  -   进度条的设置
- (void)addTimer
{
//创建定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction
{
    _circleView.progress -= 0.01;
    NSLog(@"zhuxxx 进度条的值==%f",_circleView.progress);
    // 配网40%时，显示正在发送数据
  //  配网70%时，显示配网成功
  //  配网100时，显示绑定成功
    NSString  *  value = [self formatFloat:_circleView.progress];
    NSLog(@"zhuxxx 进度条的String值==%@",value);
    if ([value  isEqualToString:@"0.8"]) {
        self.sendone.textColor  = [UIColor  blackColor];
        self.btnone.selected = YES;
    }
        //改变视图的颜色和图片
    if ([value  isEqualToString:@"0.6"]) {
        self.sendtwo.textColor  = [UIColor  blackColor];
        self.btntwo.selected = YES;
    }
    
    if ([value  isEqualToString:@"0.2"]) {
        //60秒超时没有收到mqtt上报锁添加消息即失败
        KDSAddWiFiLockFailVC * vc = [KDSAddWiFiLockFailVC new];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self.navigationController pushViewController:vc animated:YES];
        });
    }
        
    if (_circleView.progress <= 0.01) {
        [self removeTimer];
        NSLog(@"完成");
    }
}
- (NSString *)formatFloat:(float)f{
    if (fmodf(f, 1)==0) { //无有效小数位
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {//如果有两位或以上小数点
        return [NSString stringWithFormat:@"%.2f",f];
    }
}
- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KDSMQTTEventNotification object:nil];
}

-(void)setUI
{
    UIView * supView = [UIView new];
    supView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:supView];
    [supView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    // 添加顶部的视图
    UIView *topView = [UIView  new];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.right.left.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    UIView *centerCircle = [UIView new];
    centerCircle.backgroundColor = KDSRGBColor(0, 102, 161);
    centerCircle.layer.masksToBounds = YES;
    centerCircle.layer.cornerRadius = 8;
    [topView addSubview:centerCircle];
    [centerCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
        make.height.width.equalTo(@16);
    }];
    UIView *Circle2 = [UIView new];
    Circle2.backgroundColor = KDSRGBColor(0, 102, 161);
    Circle2.layer.masksToBounds = YES;
    Circle2.layer.cornerRadius = 8;
    [topView addSubview:Circle2];
    [Circle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.centerX.equalTo(topView.mas_centerX).offset(-50);
        make.height.width.equalTo(@16);
    }];

    UIView *Circle1 = [UIView new];
    Circle1.backgroundColor = KDSRGBColor(0, 102, 161);
    Circle1.layer.masksToBounds = YES;
    Circle1.layer.cornerRadius = 8;
    [topView addSubview:Circle1];
    [Circle1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.centerX.equalTo(Circle2.mas_centerX).offset(-50);
        make.height.width.equalTo(@16);
    }];

    UIView *Circle4 = [UIView new];
    Circle4.backgroundColor = KDSRGBColor(179, 200, 230);
    Circle4.layer.masksToBounds = YES;
    Circle4.layer.cornerRadius = 8;
    [topView addSubview:Circle4];
    [Circle4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.centerX.equalTo(topView.mas_centerX).offset(50);
        make.height.width.equalTo(@16);
    }];

    UIView *Circle5 = [UIView new];
    Circle5.backgroundColor = KDSRGBColor(179, 200, 230);
    Circle5.layer.masksToBounds = YES;
    Circle5.layer.cornerRadius = 8;
    [topView addSubview:Circle5];
    [Circle5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.centerX.equalTo(Circle4.mas_centerX).offset(50);
        make.height.width.equalTo(@16);
    }];

    // 绘制中间的连线
    UIView *lineView = [UIView new];
    lineView.backgroundColor = KDSRGBColor(0, 102, 161);
    [topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.width.equalTo(@50);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(Circle1.mas_right);
    }];

    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = KDSRGBColor(0, 102, 161);

    [topView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.width.equalTo(@50);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(Circle2.mas_right);
    }];

    UIView *lineView3 = [UIView new];
    lineView3.backgroundColor = KDSRGBColor(179, 200, 230);

    [topView addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
      // make.width.equalTo(@50);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(centerCircle.mas_right);
        make.right.equalTo(Circle4.mas_left);
    }];
    UIView *lineView4 = [UIView new];
    lineView4.backgroundColor = KDSRGBColor(179, 200, 230);

    [topView addSubview:lineView4];
    [lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.width.equalTo(@50);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(Circle4.mas_right);
    }];
    
    NSInteger    topValue =  0;
    if (kScreenHeight >  677) {
        topValue = 180;
    }
    if (KDSScreenHeight > 876) {
        topValue = 230;
    }
    
    HWCircleView *circleView = [[HWCircleView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-200)/2, ([UIScreen mainScreen].bounds.size.height-200)/2-topValue, 200, 200)];
    
    [self.view addSubview:circleView];
    self.circleView = circleView;;
    
    UILabel * tipsLb1 = [UILabel new];
    tipsLb1.text = @"将门锁与路由器约10米内进行连接";
    tipsLb1.textColor = [UIColor blackColor];
    tipsLb1.textAlignment = NSTextAlignmentCenter;
    tipsLb1.font = [UIFont systemFontOfSize:16];
    [supView addSubview:tipsLb1];
    [tipsLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleView.mas_bottom).offset(30);
        make.height.equalTo(@20);
        make.centerX.equalTo(supView);
    }];
     // 添加提示的视图
    UIView  *  alertView = [UIView new];
    alertView.backgroundColor = [UIColor blueColor];
    
    [supView addSubview:alertView];
    
    [alertView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.top.equalTo(tipsLb1.mas_bottom).offset(65);
        make.left.equalTo(supView.mas_left).offset(60);
    }];
    
   _btnone = [UIButton new];
    [_btnone setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_default"] forState:UIControlStateNormal];
    [_btnone setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_selected"] forState:UIControlStateSelected];
    [alertView addSubview:_btnone];
    [_btnone  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertView.mas_right);
        make.centerY.equalTo(alertView.mas_centerY);
        make.width.height.equalTo(@14);
    }];
    _sendone = [UILabel new];
    _sendone.text =@"正在发送数据";
    _sendone.textColor  = KDSRGBColor(153, 153, 153);
    _sendone.font = [UIFont  systemFontOfSize:14];
    [alertView addSubview:_sendone];
    [_sendone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_btnone.mas_right).offset(8);
        make.centerY.equalTo(alertView.mas_centerY);
    }];
    
    UIView  *  alertView2 = [UIView new];
    alertView2.backgroundColor = [UIColor greenColor];
    [supView addSubview:alertView2];
    
    [alertView2  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.top.equalTo(alertView.mas_bottom).offset(15);
        make.left.equalTo(supView.mas_left).offset(60);
    }];
    
   _btntwo = [UIButton new];
    [_btntwo setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_default"] forState:UIControlStateNormal];
    [_btntwo setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_selected"] forState:UIControlStateSelected];
   
    [alertView2 addSubview:_btntwo];
    [_btntwo  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertView2.mas_right);
        make.centerY.equalTo(alertView2.mas_centerY);
        make.width.height.equalTo(@14);
    }];
   _sendtwo = [UILabel new];
    _sendtwo.text =@"正在连接数据";
    _sendtwo.textColor  = KDSRGBColor(153, 153, 153);
    _sendtwo.font = [UIFont  systemFontOfSize:14];
    [alertView2 addSubview:_sendtwo];
    [_sendtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_btntwo.mas_right).offset(8);
        make.centerY.equalTo(alertView2.mas_centerY);
    }];
    
    
    UIView  *  alertView3 = [UIView new];
    alertView3.backgroundColor = [UIColor greenColor];
    [supView addSubview:alertView3];
    
    [alertView3  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.top.equalTo(alertView2.mas_bottom).offset(15);
        make.left.equalTo(supView.mas_left).offset(60);
    }];
   _btnthere = [UIButton new];
    [_btnthere setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_default"] forState:UIControlStateNormal];
    [_btnthere setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_selected"] forState:UIControlStateSelected];
 
    [alertView3 addSubview:_btnthere];
    [_btnthere  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertView3.mas_right);
        make.centerY.equalTo(alertView3.mas_centerY);
        make.width.height.equalTo(@14);
    }];

   _sendthere = [UILabel new];
    _sendthere.text =@"绑定成功";
    _sendthere.textColor  = KDSRGBColor(153, 153, 153);
    _sendthere.font = [UIFont systemFontOfSize:14];
    [alertView3 addSubview:_sendthere];
    [_sendthere mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_btnthere.mas_right).offset(8);
        make.centerY.equalTo(alertView3.mas_centerY);
    }];
    
}



#pragma mark 控件点击事件

-(void)navRightClick
{
    KDSXMMediaLockHelpVC * vc = [KDSXMMediaLockHelpVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navBackClick
{
    UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:@"" message:@"确定重新开始配网吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
    
            
            if ([controller isKindOfClass:[KDSAddVideoWifiLockStep3VC class]]) {
                KDSAddVideoWifiLockStep3VC *A =(KDSAddVideoWifiLockStep3VC *)controller;
                [self.navigationController popToViewController:A animated:YES];
            }
        }
    }];
    [cancelAction setValue:KDSRGBColor(164, 164, 164) forKey:@"titleTextColor"];
    [alerVC addAction:cancelAction];
    [alerVC addAction:okAction];
    [self presentViewController:alerVC animated:YES completion:nil];
}

#pragma mark -- 视频锁绑定结果的通知
- (void)mediaLockBindStatus:(NSNotification *)noti
{
    KDSWifiLockModel * model = [KDSWifiLockModel new];
    MQTTSubEvent  subevent = noti.userInfo[MQTTEventKey];
    NSDictionary *param = noti.userInfo[MQTTEventParamKey];
    if ([subevent isEqualToString:MQTTSubEventMdeiaLockBindSucces]) {//视频锁绑定成功
        model.device_sn = param[@"device_sn"];
        model.mac = param[@"mac"];
        model.device_did = param[@"device_did"];
        model.p2p_password = param[@"p2p_password"];
        model.wifiName = self.ssid;
        model.wifiSN = param[@"wfId"];
        
        //改变视图的颜色和图片
        self.sendone.textColor  = [UIColor  blackColor];
        self.sendtwo.textColor  = [UIColor  blackColor];
        self.sendthere.textColor  = [UIColor  blackColor];
        self.btnone.selected = YES;
        self.btntwo.selected = YES;
        self.btnthere.selected = YES;
        //    视屏验证管理员密码
        KDSMediaLockInPutAdminPwdVC * vc = [KDSMediaLockInPutAdminPwdVC new];
        vc.model = model;
        vc.crcData = param[@"randomCode"];
        if (self.ispushing) {
            self.ispushing = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([subevent isEqualToString:MQTTSubEventMdeiaLockBindErrorNotity]){
        //不管超时还是其他错误，都结束配网且失败
        [self removeTimer];
        self.btnone.selected = NO;
        self.btntwo.selected = NO;
        self.btnthere.selected = NO;
       // [self.btnone setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_Failure"]  forState:UIControlStateNormal];
        [self.btntwo setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_Failure"]  forState:UIControlStateNormal];
        [self.btnthere setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_Failure"]  forState:UIControlStateNormal];
        
        KDSAddWiFiLockFailVC * vc = [KDSAddWiFiLockFailVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
