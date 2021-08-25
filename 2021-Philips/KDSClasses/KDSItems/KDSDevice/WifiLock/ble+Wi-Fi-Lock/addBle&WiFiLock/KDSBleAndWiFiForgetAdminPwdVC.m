//
//  KDSBleAndWiFiForgetAdminPwdVC.m
//  2021-Philips
//
//  Created by zhaona on 2020/4/21.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSBleAndWiFiForgetAdminPwdVC.h"
#import "KDSWifiLockHelpVC.h"
#import "KDSAddBleAndWiFiLockStep4.h"
#import "KDSAddVideoWifiLockStep3VC.h"

@interface KDSBleAndWiFiForgetAdminPwdVC ()

@property (nonatomic,strong) UIImageView * addZigBeeLocklogoImg;

@property (nonatomic,strong) UIView   *supView;

@property (nonatomic,strong)  UIButton  * checkButton;

@property(nonatomic ,strong) UIButton * connectBtn;

@end

@implementation KDSBleAndWiFiForgetAdminPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationTitleLabel.text = Localized(@"ChangeAdminPassword");
    [self setRightButton];
    [self.rightButton setImage:[UIImage imageNamed:@"philips_icon_help"] forState:UIControlStateNormal];
    
    
    [self setupUI];
 
  //  [self startAnimation4Connection];
}

- (void) setupUI{
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
    lineView3.backgroundColor = KDSRGBColor(0, 102, 161);

    [topView addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.width.equalTo(@50);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(centerCircle.mas_right);
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
   
    // 添加提示的图片
    self.addZigBeeLocklogoImg = [UIImageView new];
    self.addZigBeeLocklogoImg.image = [UIImage imageNamed:@"philips_dms_img_alter"];
    [self.view addSubview:self.addZigBeeLocklogoImg];
    //self.addZigBeeLocklogoImg.backgroundColor = UIColor.yellowColor;
    [self.addZigBeeLocklogoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(KDSScreenHeight < 667 ? 15 : 38);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.width.height.equalTo(@180);
       
    }];

    UILabel * tipMsgLabe = [UILabel new];
    tipMsgLabe.text = Localized(@"ChangeAdminPassword_Tips_One");
    tipMsgLabe.numberOfLines = 0;
    tipMsgLabe.lineBreakMode = NSLineBreakByWordWrapping;
    tipMsgLabe.font = [UIFont systemFontOfSize:15 weight:0.2];
    tipMsgLabe.textColor = KDSRGBColor(51, 51, 51);
    tipMsgLabe.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tipMsgLabe];
    [tipMsgLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_addZigBeeLocklogoImg.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UILabel * tipMsg1Labe = [UILabel new];
    tipMsg1Labe.text = Localized(@"ChangeAdminPassword_Tips_Two");
    tipMsg1Labe.font = [UIFont systemFontOfSize:15 weight:0.2];
    tipMsg1Labe.textColor = KDSRGBColor(51, 51, 51);
    tipMsg1Labe.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tipMsg1Labe];
    [tipMsg1Labe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipMsgLabe.mas_bottom).offset(10);
        make.height.mas_equalTo(16);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    UILabel * tipMsg2Labe = [UILabel new];
    tipMsg2Labe.text = Localized(@"ChangeAdminPassword_Tips_There");;
    tipMsg2Labe.font = [UIFont systemFontOfSize:15 weight:0.2];
    tipMsg2Labe.textColor = KDSRGBColor(51, 51, 51);
    tipMsg2Labe.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tipMsg2Labe];
    [tipMsg2Labe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipMsg1Labe.mas_bottom).offset(10);
        make.height.mas_equalTo(16);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    _connectBtn = [UIButton new];
    [_connectBtn setTitle:Localized(@"Continue_To_Verify") forState:UIControlStateNormal];
    [_connectBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_connectBtn addTarget:self action:@selector(changgeAdminPwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _connectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _connectBtn.backgroundColor = KDSRGBColor(179, 200, 230);
    _connectBtn.layer.masksToBounds = YES;
    _connectBtn.layer.cornerRadius = 3;
    [self.view addSubview:_connectBtn];
    [_connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.height.equalTo(@44);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(KDSScreenHeight <= 667 ? -30 : -62);
    }];
    
    // 添加描述文字
    UILabel * tipMsg3Labe = [UILabel new];
    tipMsg3Labe.text = Localized(@"ChangedAdminPassword");
    tipMsg3Labe.font = [UIFont systemFontOfSize:14];
    tipMsg3Labe.textColor = KDSRGBColor(102, 102, 102);
    tipMsg3Labe.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipMsg3Labe];
    [tipMsg3Labe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_connectBtn.mas_top).offset(-28);
        make.height.mas_equalTo(16);
        //make.width.equalTo(@300);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    //   加上一个选择框
    _checkButton    = [UIButton  new];
    [_checkButton  setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_default"] forState:UIControlStateNormal];
    [_checkButton  setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_selected"] forState:UIControlStateSelected];
    [_checkButton addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_checkButton];
    [_checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_connectBtn.mas_top).offset(-28);
        make.height.width.mas_equalTo(18);
        make.right.equalTo(tipMsg3Labe.mas_left).offset(-3);
       
    }];
    
    
}

#pragma mark   - button 的点击事件
- (void)clickCheckBtn:(UIButton *)sender{
    KDSLog(@" 是否修改了管理员密码 ？");
    sender.selected = !sender.selected;
    // 选中修改button的颜色
    if (sender.selected) {
        self.connectBtn.backgroundColor = KDSRGBColor(0, 102, 161);
    }else{
        
        self.connectBtn.backgroundColor = KDSRGBColor(179, 200, 230);
    }
}

//NSArray *_arrayImages4Connecting; 几张图片按顺序切换
- (void)startAnimation4Connection {
    NSArray * _arrayImages4Connecting = [NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"changeAdminiPwdImg1.jpg"],
                                        [UIImage imageNamed:@"changeAdminiPwdImg2.jpg"],
                                        [UIImage imageNamed:@"changeAdminiPwdImg3.jpg"],
                                        [UIImage imageNamed:@"changeAdminiPwdImg4.jpg"],
                                        [UIImage imageNamed:@"changeAdminiPwdImg5.jpg"],
                                        [UIImage imageNamed:@"changeAdminiPwdImg6.jpg"],
                                        [UIImage imageNamed:@"changeAdminiPwdImg7.jpg"],
                                        [UIImage imageNamed:@"changeAdminiPwdImg8.jpg"],
                                        [UIImage imageNamed:@"changeAdminiPwdImg9.jpg"],
                                        [UIImage imageNamed:@"changeAdminiPwdImg10.jpg"],
                                        [UIImage imageNamed:@"changeAdminiPwdImg11.jpg"],
                                        [UIImage imageNamed:@"changeAdminiPwdImg12.jpg"],
                                        [UIImage imageNamed:@"changeAdminiPwdImg13.jpg"],
                                        [UIImage imageNamed:@"changeAdminiPwdImg14.jpg"],
                                        [UIImage imageNamed:@"changeAdminiPwdImg15.jpg"],
                                        [UIImage imageNamed:@"changeAdminiPwdImg16.jpg"],
                                        nil];
    [self.addZigBeeLocklogoImg setAnimationImages:_arrayImages4Connecting];
    [self.addZigBeeLocklogoImg setAnimationRepeatCount:0];
    [self.addZigBeeLocklogoImg setAnimationDuration:16.0f];
    [self.addZigBeeLocklogoImg startAnimating];

}

//停止删除
-(void)imgAnimationStop{
    [self.addZigBeeLocklogoImg.layer removeAllAnimations];
}

-(void)dealloc
{
    [self imgAnimationStop];
}

-(void)setLabelSpace:(UILabel*)label withSpace:(CGFloat)space withFont:(UIFont*)font  {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = space; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:label.text attributes:dic];
    label.attributedText = attributeStr;
}


#pragma mark 控件点击事件

-(void)navRightClick
{
    KDSWifiLockHelpVC * vc = [KDSWifiLockHelpVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)navBackClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)changgeAdminPwdBtnClick:(UIButton * )sender
{
    
    if (!self.checkButton.selected) {
        return;
    }
    if (self.bleTool) {
        ///ble+wifi配网
        [self.bleTool endConnectPeripheral:self.bleTool.connectedPeripheral];
        KDSAddBleAndWiFiLockStep4 * vc = [KDSAddBleAndWiFiLockStep4 new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{ //视屏锁
    
       // 点击继续验证  应跳转至进入管理模式
          [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
      
    }
}

@end
