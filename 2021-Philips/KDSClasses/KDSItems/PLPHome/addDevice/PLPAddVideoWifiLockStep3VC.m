//
//  PLPAddVideoWifiLockStep3VC.m
//  2021-Philips
//
//  Created by kaadas on 2021/4/27.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPAddVideoWifiLockStep3VC.h"
#import "PLPAddVideoWifiLockConfigureWiFiVC.h"
///  进入管理者模式
@interface PLPAddVideoWifiLockStep3VC ()
@end

@implementation PLPAddVideoWifiLockStep3VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitleLabel.text = Localized(@"进入管理着模式");
    [self setRightButton];
    [self.rightButton setImage:[UIImage imageNamed:@"icon_help"] forState:UIControlStateNormal];
    
    [self setupUI];
}


- (void) setupUI{
      // 顶部的进度条
    UIView  * topView = [UIView new];
    topView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topView];
    [topView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@60);
    }];
     // 中间的图片
    UIImageView  * promptImg = [UIImageView new];
    promptImg.image = [UIImage imageNamed:@"dms_img_keying"];
    [self.view addSubview:promptImg];
    [promptImg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@156);
        make.width.equalTo(@120);
        make.top.equalTo(topView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX).offset(20);
    }];
    
    // 底部的文字
    //
    UILabel * tipsLabel = [UILabel new];
    tipsLabel.text = @"1.触摸门锁数字键区域，唤醒门锁面板";
    [self.view addSubview: tipsLabel];
    [tipsLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptImg.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        
    }];
    UILabel * tipsLabel2 = [UILabel new];
    tipsLabel2.text = @"2.连续2次点击“*”号键，输入管理员密码后按“#”号键确认";
    tipsLabel2.numberOfLines= 0;
    tipsLabel2.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview: tipsLabel2];
    [tipsLabel2  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        
    }];
    UILabel * tipsLabel3 = [UILabel new];
    tipsLabel3.text = @"3.根据语音提示，在门锁菜单中选择“4-1”";
    [self.view addSubview: tipsLabel3];
    [tipsLabel3  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel2.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
     // 点击进行下一步的按钮
    UIButton * nextButton = [UIButton new];
    [nextButton setBackgroundColor:KDSRGBColor(179, 200, 230)];
    [nextButton setTitle:Localized(@"下一步") forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.height.equalTo(@44);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-80);
    }];
    
    UIView  * view = [UIView new];
    view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(nextButton.mas_top).offset(0);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    UILabel * plaseLable = [UILabel new];
    plaseLable.text= @"门锁已语音提示“配网中，请稍后”";
    plaseLable.textColor = KDSRGBColor(102, 102, 102);
    plaseLable.font = [UIFont systemFontOfSize:14];
    [view addSubview:plaseLable];
    [plaseLable mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.top.equalTo(nextButton.mas_bottom).offset(10);
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
    }];
 
    UIButton  * selectBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    selectBtn.backgroundColor = [UIColor clearColor];
    [selectBtn setTintColor:[UIColor clearColor]];
    //self.agreeBtn.selected = YES;
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"signin_icon_default"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"signin_icon_selected"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(visibleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    
    [selectBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.height.width.equalTo(@18);
        make.right.equalTo(plaseLable.mas_left).offset(-10);
    }];
    
    UILabel * failelabel = [UILabel new];
    failelabel.text= @"语音提示设置失败 ？";
    failelabel.textColor = KDSRGBColor(233, 131, 0);
    failelabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:failelabel];
    [failelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nextButton.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

#pragma  mark  - 点击事件

-(void)nextBtnClick{
    KDSLog(@"进行了事件点击");
    PLPAddVideoWifiLockConfigureWiFiVC  * vc = [PLPAddVideoWifiLockConfigureWiFiVC new];
   // vc.lock = self.lock;
   // vc.isAgainNetwork = self.isAgainNetwork;
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)navRightClick{
    KDSLog(@"进入的帮助界面");
    
}
///密码是否显示出来
- (void)visibleBtn:(UIButton *)sender {
    KDSLog(@"btn的选中事件");
    sender.selected = !sender.selected;
    if (sender.selected) {
       
    } else {
        
    }
}

@end
