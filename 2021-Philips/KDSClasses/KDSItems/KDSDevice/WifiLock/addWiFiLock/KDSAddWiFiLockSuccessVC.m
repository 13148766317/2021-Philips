//
//  KDSAddWiFiLockSuccessVC.m
//  2021-Philips
//
//  Created by zhaona on 2019/12/13.
//  Copyright © 2019 com.Kaadas. All rights reserved.
//
#import "KDSAddWiFiLockSuccessVC.h"
#import "UIButton+Color.h"
#import "KDSHttpManager+WifiLock.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+Extension.h"
#import "KDSHomeRoutersVC.h"
#import "KDSHomeViewController.h"
#import "KDSAddVideoWifiLockStep1VC.h"
@interface KDSAddWiFiLockSuccessVC ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField * nameTf;
@property (nonatomic,strong) UIButton * selectedBtn;
@property (nonatomic,strong) UIView * supView;
@end

@implementation KDSAddWiFiLockSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationTitleLabel.text = Localized(@"addSuccess");
   // [self setUI];
    [self setupUI];
}


- (void)setupUI{
    self.supView = [UIView new];
    self.supView.backgroundColor = UIColor.whiteColor;

    [self.view addSubview:self.supView];
    [self.supView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    // 添加滚动视图的占位图
    UIView *topView = [UIView  new];
    // topView.backgroundColor = [UIColor redColor];
    [_supView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_supView).offset(20);
        make.right.left.equalTo(_supView);
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
    Circle4.backgroundColor = KDSRGBColor(0, 102, 161);
    Circle4.layer.masksToBounds = YES;
    Circle4.layer.cornerRadius = 8;
    [topView addSubview:Circle4];
    [Circle4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.centerX.equalTo(topView.mas_centerX).offset(50);
        make.height.width.equalTo(@16);
    }];

    UIView *Circle5 = [UIView new];
    Circle5.backgroundColor = KDSRGBColor(0, 102, 161);
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
    lineView3.backgroundColor = KDSRGBColor(0, 102, 161);

    [topView addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.width.equalTo(@50);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(centerCircle.mas_right);
    }];
    UIView *lineView4 = [UIView new];
    lineView4.backgroundColor = KDSRGBColor(0, 102, 161);

    [topView addSubview:lineView4];
    [lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.width.equalTo(@50);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(Circle4.mas_right);
    }];
    
    UIImageView * addWifiLockSuccessImg = [UIImageView new];
    addWifiLockSuccessImg.image = [UIImage imageNamed:@"philips_dms_img_success"];
    [self.supView addSubview:addWifiLockSuccessImg];
    [addWifiLockSuccessImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.supView.mas_top).offset(KDSSSALE_HEIGHT(72));
        make.centerX.mas_equalTo(self.supView.mas_centerX).offset(0);
        make.width.equalTo(@86);
        make.height.equalTo(@86);
    }];
    UILabel * successTipsLb = [UILabel new];
    successTipsLb.text = Localized(@"Add_a_success");
    successTipsLb.textColor = KDSRGBColor(86, 86, 86);
    successTipsLb.font = [UIFont systemFontOfSize:15];
    successTipsLb.textAlignment = NSTextAlignmentCenter;
    [self.supView addSubview:successTipsLb];
    [successTipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addWifiLockSuccessImg.mas_bottom).offset(28.5);
        make.height.equalTo(@20);
        make.centerX.mas_equalTo(self.supView.mas_centerX).offset(0);
    }];
    UIView  * inputView = [UIView new];
    inputView.layer.masksToBounds = YES;
    inputView.layer.borderWidth = 1 ;
    inputView.layer.cornerRadius = 5;
    inputView.layer.borderColor = KDSRGBColor(0, 102, 161).CGColor;
    [self.supView addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successTipsLb.mas_bottom).offset(40);
        make.left.equalTo(self.supView.mas_left).offset(15);
        make.right.equalTo(self.supView.mas_right).offset(-15);
        make.height.equalTo(@40);
    }];
    // 添加输入框
    UIImageView * editImg = [UIImageView new];
    editImg.image = [UIImage imageNamed:@"philips_dms_icon_username"];
    [inputView addSubview:editImg];
    [editImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@22.5);
        make.height.equalTo(@21.5);
        make.centerY.mas_equalTo(inputView.mas_centerY).offset(0);
        make.left.mas_equalTo(inputView.mas_left).offset(15);
        
    }];
    
    _nameTf= [UITextField new];
    _nameTf.placeholder = Localized(@"Edit_add_DeviceName");
    _nameTf.textColor = UIColor.blackColor;
    _nameTf.font = [UIFont systemFontOfSize:15];
    _nameTf.textAlignment = NSTextAlignmentLeft;
    _nameTf.borderStyle=UITextBorderStyleNone;
    [_nameTf addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [inputView addSubview:_nameTf];
    [_nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(editImg.mas_right).offset(10);
        make.right.mas_equalTo(inputView.mas_right).offset(-10);
        make.top.bottom.mas_equalTo(0);
        
    }];
    
    
    UIButton * myHomeBtn = [UIButton new];
    [myHomeBtn setTitle:Localized(@"Tips_MyLock") forState:UIControlStateNormal];
    [myHomeBtn setTitleColor:KDSRGBColor(31, 150, 247) forState:UIControlStateNormal];
    [myHomeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [myHomeBtn setBackgroundColor:UIColor.whiteColor forState:UIControlStateNormal];
    [myHomeBtn setBackgroundColor:KDSRGBColor(31, 150, 247) forState:UIControlStateSelected];
    myHomeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.selectedBtn = myHomeBtn;
    myHomeBtn.layer.masksToBounds = YES;
    myHomeBtn.layer.cornerRadius = 5;
    [myHomeBtn addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.supView addSubview:myHomeBtn];
    [myHomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inputView.mas_bottom).offset(10);
        make.width.equalTo(@62);
        make.height.equalTo(@30);
        make.left.mas_equalTo(self.view.mas_left).offset(18);
        
    }];
    UIButton * bedroomBtn = [UIButton new];
    [bedroomBtn setTitle:Localized(@"Tips_MyBedroom") forState:UIControlStateNormal];
    [bedroomBtn setTitleColor:KDSRGBColor(31, 150, 247) forState:UIControlStateNormal];
    [bedroomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [bedroomBtn setBackgroundColor:UIColor.whiteColor forState:UIControlStateNormal];
    [bedroomBtn setBackgroundColor:KDSRGBColor(31, 150, 247) forState:UIControlStateSelected];
    bedroomBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    bedroomBtn.layer.masksToBounds = YES;
    bedroomBtn.layer.cornerRadius = 5;
    [bedroomBtn addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.supView addSubview:bedroomBtn];
    [bedroomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inputView.mas_bottom).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
        make.left.mas_equalTo(myHomeBtn.mas_right).offset(10);
    }];
    UIButton * companyBtn = [UIButton new];
    [companyBtn setTitle:Localized(@"Tips_MyCompany") forState:UIControlStateNormal];
    [companyBtn setTitleColor:KDSRGBColor(31, 150, 247) forState:UIControlStateNormal];
    [companyBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [companyBtn setBackgroundColor:UIColor.whiteColor forState:UIControlStateNormal];
    [companyBtn setBackgroundColor:KDSRGBColor(31, 150, 247) forState:UIControlStateSelected];
    companyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    companyBtn.layer.masksToBounds = YES;
    companyBtn.layer.cornerRadius = 5;
    [companyBtn addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.supView addSubview:companyBtn];
    [companyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inputView.mas_bottom).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
        make.left.mas_equalTo(bedroomBtn.mas_right).offset(10);
        
    }];
    
    UIButton * finishBtn = [UIButton new];
    [finishBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    [finishBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    finishBtn.backgroundColor = KDSRGBColor(0, 102, 161);
   
    [finishBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.supView addSubview:finishBtn];
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(companyBtn.mas_bottom).offset(KDSSSALE_HEIGHT(188));
        make.height.equalTo(@44);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.right.equalTo(self.view).offset(-15);
        make.left.equalTo(self.view).offset(15);
    }];

}

-(void)dealloc{

}

- (void)navBackClick
{
    // 方案二使用通知 调用getallbind 方法  queryP2P_passwordNotication
       NSNotification *notification =[NSNotification notificationWithName:@"queryP2P_passwordNotication" object:nil userInfo:nil];
       [[NSNotificationCenter defaultCenter] postNotification:notification];
       NSLog(@"zhu-- 发送通知--back方法");
    [self.navigationController popToRootViewControllerAnimated:YES];

}

#pragma mark button点击事件

-(void)finishClick:(UIButton *)btn
{
    NSLog(@"点击了完成按钮");
    if (self.nameTf.text.length == 0) {
        [MBProgressHUD showError:@"设备昵称不能为空"];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.removeFromSuperViewOnHide = YES;
    [[KDSHttpManager sharedManager] alterWifiBindedDeviceNickname:self.nameTf.text withUid:[KDSUserManager sharedManager].user.uid wifiModel:self.model success:^{
        [hud hideAnimated:NO];
        [MBProgressHUD showSuccess:Localized(@"saveSuccess")];
        [self.navigationController popToRootViewControllerAnimated:NO];
        UITabBarController *vc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        if ([vc isKindOfClass:UITabBarController.class] && vc.viewControllers.count)
        {
            vc.selectedIndex = 0;
        }
    } error:^(NSError * _Nonnull error) {
        [hud hideAnimated:NO];
        [MBProgressHUD showError:Localized(@"saveFailed")];
    } failure:^(NSError * _Nonnull error) {
        [hud hideAnimated:NO];
        [MBProgressHUD showError:Localized(@"saveFailed")];
    }];
    
    //  移除指定的控制器
    [self removeKnownViewController];
}

- (void)removeKnownViewController{
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    for (UIViewController  * viewController in self.navigationController.viewControllers) {
        NSLog(@"zhushiqi= 所有的控制器==%@",[viewController class]);
        if([viewController isKindOfClass:[KDSAddVideoWifiLockStep1VC class]])
         {
          [navigationArray  removeObject:viewController];
         }
        
    }
  self.navigationController.viewControllers = navigationArray;
}


-(void)supportedHomeRoutersClickTap:(UITapGestureRecognizer *)sender
{
    KDSHomeRoutersVC * VC = [KDSHomeRoutersVC new];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)selectedClick:(UIButton *)sender
{
    if (sender!= self.selectedBtn)
    {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
    }else{
        self.selectedBtn.selected = YES;
    }
    self.nameTf.text = sender.titleLabel.text;
}
///锁昵称文本框文字改变后，限制长度不超过16个字符。
- (void)textFieldTextDidChange:(UITextField *)sender
{
    [sender trimTextToLength:-1];
}


@end
