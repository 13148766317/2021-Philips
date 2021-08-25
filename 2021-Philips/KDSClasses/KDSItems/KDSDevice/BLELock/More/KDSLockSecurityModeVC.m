//
//  KDSLockSecurityModeVC.m
//  xiaokaizhineng
//
//  Created by orange on 2019/2/18.
//  Copyright © 2019年 shenzhen kaadas intelligent technology. All rights reserved.
//

#import "KDSLockSecurityModeVC.h"
#import "MBProgressHUD+MJ.h"
#import "KDSBleAssistant.h"
#import "KDSAlertController.h"

@interface KDSLockSecurityModeVC ()

///开关
@property (nonatomic, weak) UISwitch *swi;

@end

@implementation KDSLockSecurityModeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationTitleLabel.text = self.title = Localized(@"securityMode");
    
    //安全模式标签+开关按钮
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    view.backgroundColor = UIColor.whiteColor;
    UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 50)];
    modelLabel.text = self.title;
    modelLabel.font = [UIFont systemFontOfSize:15];
    modelLabel.textColor = KDSRGBColor(0x33, 0x33, 0x33);
    [view addSubview:modelLabel];
    
    UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 26, 15)];
    switchControl.transform = CGAffineTransformMakeScale(sqrt(0.5), sqrt(0.5));
    if (self.lock.wifiDevice) {
        //wifi锁多一个提示语
        switchControl.on = self.lock.wifiDevice.safeMode.intValue;
        UILabel * tipsLb = [UILabel new];
        tipsLb.text = @"注：请到锁端设置模式 ";
        tipsLb.font = [UIFont systemFontOfSize:13];
        tipsLb.textColor = UIColor.blackColor;
        tipsLb.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:tipsLb];
        [tipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(50 + 19);
            make.left.mas_equalTo(self.view.mas_left).offset(13);
            make.right.mas_equalTo(self.view.mas_right).offset(-13);
            make.height.mas_equalTo(@15);
        }];
    }else{
        switchControl.on = self.lock.bleTool.connectedPeripheral.isAutoMode;
    }
    switchControl.center = CGPointMake(kScreenWidth - 33, 20);
    [switchControl addTarget:self action:@selector(switchStateDidChange:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:switchControl];
    [self.view addSubview:view];
    self.swi = switchControl;
    
    //锁图片
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DKSLockBlue"]];
    CGFloat width = iv.image.size.width;
    CGFloat heitht = iv.image.size.height;
    iv.frame = CGRectMake((kScreenWidth - width) / 2, CGRectGetMaxY(view.frame) + (kScreenHeight < 667 ? 30 : 46), width, heitht);
    [self.view addSubview:iv];
    
    //提示标签+提示内容。
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.text = Localized(@"securityModeSettingTips");
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.numberOfLines = 0;
    tipsLabel.font = [UIFont systemFontOfSize:12];
    tipsLabel.textColor = KDSRGBColor(0x99, 0x99, 0x99);
    CGRect bounds = [tipsLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - 20, kScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : tipsLabel.font} context:nil];
    tipsLabel.frame = CGRectMake(10, CGRectGetMaxY(iv.frame) + (kScreenHeight < 667 ? 20 : 40), kScreenWidth - 20, ceil(bounds.size.height));
    [self.view addSubview:tipsLabel];
    UIView *tipsContentView = [self createTipsContentView];
    tipsContentView.center = CGPointMake(kScreenWidth / 2, CGRectGetMaxY(tipsLabel.frame) + 22 + tipsContentView.bounds.size.height / 2);
    [self.view addSubview:tipsContentView];
    
    [self.lock.bleTool getLockInfo:^(KDSBleError error, KDSBleLockInfoModel * _Nullable infoModel) {
        if (infoModel)
        {
            switchControl.on = ((infoModel.lockFunc >> 13) & 0x1) && ((infoModel.lockState >> 5) & 0x1);
        }
    }];
}

///根据锁类型创建一个提示内容视图，包含前面的绿竖线（开锁方式1+开锁方式2），返回的视图已设置bounds。
- (UIView *)createTipsContentView
{
    ////根据蓝牙锁的功能集判断是开始记录/操作记录
    NSString *function;
    if (self.lock.wifiDevice) {
        function = self.lock.wifiLockFunctionSet;
    }else{
        function = self.lock.lockFunctionSet;
    }
    CGFloat height;
    //密码、指纹、卡片都支持
    if ([KDSLockFunctionSet[function] containsObject:@7] && [KDSLockFunctionSet[function] containsObject:@8] && [KDSLockFunctionSet[function] containsObject:@9]){
        height = kScreenHeight<667 ? 150 : 225;
    }else{
        height = kScreenHeight<667 ? 50 : 75;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, height)];
    view.backgroundColor = UIColor.whiteColor;
    view.layer.cornerRadius = 4;
    //密码、指纹、卡片
    if ([KDSLockFunctionSet[function] containsObject:@7] && [KDSLockFunctionSet[function] containsObject:@8] && [KDSLockFunctionSet[function] containsObject:@9]) {
        //密码+指纹
        UIView *pinFpContentView = [self createUnlockModeContentViewWithImages:@[@"password", @"fingerprint"] titles:@[Localized(@"PIN"), Localized(@"fingerprint")] containSeparator:YES];
        [view addSubview:pinFpContentView];
        //密码+卡片
        UIView *pinCardContentView = [self createUnlockModeContentViewWithImages:@[@"password", @"card"] titles:@[Localized(@"PIN"), Localized(@"card")] containSeparator:YES];
        CGRect frame = pinCardContentView.frame;
        frame.origin.y += CGRectGetMaxY(pinFpContentView.frame);
        pinCardContentView.frame = frame;
        [view addSubview:pinCardContentView];
        //卡片+指纹
        UIView *cardFpContentView = [self createUnlockModeContentViewWithImages:@[@"card", @"fingerprint"] titles:@[Localized(@"card"), Localized(@"fingerprint")] containSeparator:NO];
        frame = cardFpContentView.frame;
        frame.origin.y += CGRectGetMaxY(pinCardContentView.frame);
        cardFpContentView.frame = frame;
        [view addSubview:cardFpContentView];
    }else if ([KDSLockFunctionSet[function] containsObject:@7] && [KDSLockFunctionSet[function] containsObject:@8]){
        //密码、指纹
        UIView *pinFpContentView = [self createUnlockModeContentViewWithImages:@[@"password", @"fingerprint"] titles:@[Localized(@"PIN"), Localized(@"fingerprint")] containSeparator:NO];
        [view addSubview:pinFpContentView];
    }else if ([KDSLockFunctionSet[function] containsObject:@7] && [KDSLockFunctionSet[function] containsObject:@9]){
        //密码、卡片
        UIView *pinCardContentView = [self createUnlockModeContentViewWithImages:@[@"password", @"card"] titles:@[Localized(@"PIN"), Localized(@"card")] containSeparator:NO];
        [view addSubview:pinCardContentView];
    }
    
    return view;
}

///根据开锁模式1+开锁模式2创建一个安全模式下开锁模式的视图。imgs和titles分别为2种组合模式的图片名和模式名，先添加的显示在左边。
- (UIView *)createUnlockModeContentViewWithImages:(NSArray<NSString *> *)imgs titles:(NSArray<NSString *> *)titles containSeparator:(BOOL)contain
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 30, kScreenHeight<667 ? 50 : 75)];
    
    UIImageView *leftIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgs.firstObject]];
    leftIV.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:leftIV];
    [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(23);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@20);
    }];
    
    UIColor *color = KDSRGBColor(0x33, 0x33, 0x33);
    UIFont *font = [UIFont systemFontOfSize:13];
    UILabel *leftLabel = [self createLabelWithText:titles.firstObject color:color font:font];
    [view addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftIV.mas_right).offset(15);
        make.centerY.equalTo(@0);
        make.size.mas_equalTo(leftLabel.bounds.size);
    }];
    
    UILabel *centerLabel = [self createLabelWithText:@"+" color:color font:font];
    [view addSubview:centerLabel];
    [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.mas_right).offset(19);
        make.centerY.equalTo(@0);
        make.size.mas_equalTo(centerLabel.bounds.size);
    }];
    
    UIImageView *rightIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgs.lastObject]];
    rightIV.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:rightIV];
    [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerLabel.mas_right).offset(19);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@20);
    }];
    
    UILabel *rightLabel = [self createLabelWithText:titles.lastObject color:color font:font];
    [view addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightIV.mas_right).offset(15);
        make.centerY.equalTo(@0);
        make.size.mas_equalTo(rightLabel.bounds.size);
    }];
    
    if (contain)
    {
        UIView *separator = [UIView new];
        separator.backgroundColor = KDSRGBColor(0xea, 0xe9, 0xe9);
        [view addSubview:separator];
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(23);
            make.right.bottom.equalTo(view);
            make.height.equalTo(@1);
        }];
    }
    
    return view;
}

///根据内容创建一个提示内容标签，创建的标签已设置bounds。
- (UILabel *)createLabelWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font
{
    UILabel *label = [UILabel new];
    label.text = text;
    label.textColor = color;
    label.font = font;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName : font}];
    label.bounds = CGRectMake(0, 0, ceil(size.width), ceil(size.height));
    return label;
}

//MARK:点击安全模式开关启动或关闭安全模式。
- (void)switchStateDidChange:(UISwitch *)sender
{
    if (self.lock.wifiDevice) {//wifi锁不可以设置
        KDSAlertController *alert = [KDSAlertController alertControllerWithTitle:@"App不可设置，请在锁端设置" message:nil];
        [self presentViewController:alert animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:^{
                [sender setOn:!sender.isOn animated:YES];
            }];
        });
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    __weak typeof(self) weakSelf = self;
    if (self.lock.gwDevice)
    {
        return;
    }
    [weakSelf.lock.bleTool setLockSecurityModeStatus:sender.on ? 1 : 0 completion:^(KDSBleError error) {
        [hud hideAnimated:NO];
        if (error == KDSBleErrorSuccess)
        {
            weakSelf.lock.bleTool.connectedPeripheral.isAutoMode = sender.isOn;
            [MBProgressHUD showSuccess:Localized(@"setSuccess")];
        }
        else
        {
            [sender setOn:!sender.isOn animated:YES];
            [MBProgressHUD showError:Localized(@"setFailed")];
        }
    }];
}

@end
