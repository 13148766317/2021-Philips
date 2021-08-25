//
//  PLPAddFailViewController.m
//  2021-Philips
//
//  Created by kaadas on 2021/6/1.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPAddFailViewController.h"
#import "KDSHomeRoutersVC.h"
#import "KDSWifiLockHelpVC.h"
#import "KDSXMMediaLockHelpVC.h"
#import "KDSAddNewWiFiLockStep1VC.h"
#import "KDSAddBleAndWiFiLockStep1.h"
#import "KDSAddVideoWifiLockStep1VC.h"
#import "KDSAddVideoWifiLockConfigureWiFiVC.h"
@interface PLPAddFailViewController ()

@end

@implementation PLPAddFailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitleLabel.text = Localized(@"Add_a_Fail");
    [self setupUI];
  
}
- (void)navBackClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)navRightClick
{
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//         if ([controller isKindOfClass:[KDSAddVideoWifiLockStep1VC class]]){
//            //视频锁配网的帮助页面
//             KDSXMMediaLockHelpVC * vc = (KDSXMMediaLockHelpVC *)controller;
//             [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }
//    }
//    KDSWifiLockHelpVC *vc = [[KDSWifiLockHelpVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setupUI{
    // 添加滚动视图的占位图


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
      // make.width.equalTo(@50);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(centerCircle.mas_right);
        make.right.equalTo(Circle4.mas_left);
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
  // 配网失败的图片
    UIImageView * failImg = [UIImageView new];
    failImg.image = [UIImage imageNamed:@"philips_dms_img_fail"];
    [self.view addSubview:failImg];
    [failImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(KDSScreenHeight < 667 ? 20 : KDSSSALE_HEIGHT(72));
        make.width.equalTo(@114);
        make.height.equalTo(@114);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        
    }];
    // 添加失败
    UILabel *  failLabel = [UILabel  new];
    failLabel.text =Localized(@"Add_a_Fail");
    //failLabel.textColor  = KDSRGBColor(102, 102, 102);
    failLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:failLabel];
    [failLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(failImg.mas_bottom).offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
   
    UILabel  * label1 = [UILabel new];
    label1.text = Localized(@"Tips_Des_One");
    label1.font = [UIFont systemFontOfSize:16];
    [self.view  addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(failLabel.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    UILabel  * label2 = [UILabel new];
    label2.text = Localized(@"Tips_Des_Two");;
    label2.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    UILabel  * label3 = [UILabel new];
    label3.text = Localized(@"Tips_Des_There");
    label3.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UILabel  * label4 = [UILabel new];
    label4.text = Localized(@"Tips_Des_Four");;
    label4.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UIButton * otherConFigBtn = [UIButton new];
    [otherConFigBtn setTitle:Localized(@"connect_cancel_wifi") forState:UIControlStateNormal];
    otherConFigBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    otherConFigBtn.backgroundColor = KDSRGBColor(0, 102, 161);
    otherConFigBtn.layer.masksToBounds = YES;
    otherConFigBtn.layer.cornerRadius = 3;
    [otherConFigBtn setTitleColor:[UIColor whiteColor]/*KDSRGBColor(31, 150, 247) */forState:UIControlStateNormal];
   
    [otherConFigBtn addTarget:self action:@selector(otherConFigBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:otherConFigBtn];
    
    [otherConFigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(44));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(KDSScreenHeight <= 667 ? -40 : -KDSSSALE_HEIGHT(60));
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    UIButton * rematchBtn = [UIButton new];
    [rematchBtn setTitle:Localized(@"connect_wifi_again") forState:UIControlStateNormal];
    rematchBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rematchBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    rematchBtn.backgroundColor = KDSRGBColor(0, 102, 161);
    rematchBtn.layer.masksToBounds = YES;
    rematchBtn.layer.cornerRadius = 3;
    [rematchBtn addTarget:self action:@selector(rematchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rematchBtn];
    [rematchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@(44));
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.bottom.mas_equalTo(otherConFigBtn.mas_top).offset(-KDSSSALE_HEIGHT(23));
    }];
   
}

#pragma 点击事件
///wifi路由器支持品牌解说
-(void)supportedHomeRoutersClickTap:(UITapGestureRecognizer *)btn{
    
    KDSHomeRoutersVC * VC = [KDSHomeRoutersVC new];
    [self.navigationController pushViewController:VC animated:YES];
}


///取消--回到设备首页
-(void)otherConFigBtnClick:(UIButton *)sender


{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}



///(返回提示语第一步重新配网)ap配网
-(void)rematchBtnClick:(UIButton *)sender
{
    // 1.“重新配网”跳转至：第二步：进入管理模式
#warning    需要验证跳转的步骤
  
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
   
}

///ap配网
-(void)apConfigBtnClick:(UIButton *)sender
{
    
//    [MBProgressHUD showError:@"功能暂未开放"];
}







@end
