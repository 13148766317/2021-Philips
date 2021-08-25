//
//  KDSLockedWayViewController.m
//  2021-Philips
//
//  Created by kaadas on 2021/3/1.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "KDSLockedWayViewController.h"
#import "KDSMQTTManager+SmartHome.h"
@interface KDSLockedWayViewController ()
/// 自动上锁。
@property (nonatomic, strong) UIButton *autoLockBtn;
/// 定时5秒。
@property (nonatomic, strong) UIButton *timing5secBtn;
/// 定时10秒。
@property (nonatomic, strong) UIButton *timing10secBtn;
/// 定时15秒。
@property (nonatomic, strong) UIButton *timing15secBtn;
/// 关闭自动上锁 。
@property (nonatomic, strong) UIButton *closeAutoLockBtn;
@end

@implementation KDSLockedWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitleLabel.text = @"上锁方式";


    [self setUI];
}

- (void)setUI
{
    UIView *cornerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 151 + 75 +75 +75)];
    cornerView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:cornerView];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = KDSRGBColor(0x33, 0x33, 0x33);
    UIImage *normalImg = [UIImage imageNamed:@"unselected22x22"];
    UIImage *selectedImg = [UIImage imageNamed:@"selected22x22"];
    
    NSString *zh =@"自动上锁";
    UILabel *zhLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 75)];
    zhLabel.text = zh;
    zhLabel.textColor = color;
    zhLabel.font = font;
    [cornerView addSubview:zhLabel];
    
    self.autoLockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.autoLockBtn setImage:normalImg forState:UIControlStateNormal];
    [self.autoLockBtn setImage:selectedImg forState:UIControlStateSelected];
    self.autoLockBtn.frame = CGRectMake(cornerView.bounds.size.width - 17 - 22, 26.5, 22, 22);
    
    [self.autoLockBtn addTarget:self action:@selector(selectLockLanguage:) forControlEvents:UIControlEventTouchUpInside];
    [cornerView addSubview:self.autoLockBtn];
    
    UIView *separactor = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(zhLabel.frame), cornerView.bounds.size.width - 20, 1)];
    separactor.backgroundColor = KDSRGBColor(0xea, 0xe9, 0xe9);
    [cornerView addSubview:separactor];
    NSString *en = @"定时5秒";
    UILabel *enLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(separactor.frame), 200, 75)];
    enLabel.text = en;
    enLabel.textColor = color;
    enLabel.font = font;
    [cornerView addSubview:enLabel];
    
    self.timing5secBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.timing5secBtn setImage:normalImg forState:UIControlStateNormal];
    [self.timing5secBtn setImage:selectedImg forState:UIControlStateSelected];
    self.timing5secBtn.frame = CGRectMake(cornerView.bounds.size.width - 17 - 22, 102.5, 22, 22);
    
    [self.timing5secBtn addTarget:self action:@selector(selectLockLanguage:) forControlEvents:UIControlEventTouchUpInside];
    [cornerView addSubview:self.timing5secBtn];
    // 定时10秒
    UIView *separactor1 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(enLabel.frame), cornerView.bounds.size.width - 20, 1)];
    separactor1.backgroundColor = KDSRGBColor(0xea, 0xe9, 0xe9);
    [cornerView addSubview:separactor1];
    NSString *timing10 = @"定时10秒";
    UILabel *timing10Label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(separactor1.frame), 200, 75)];
    timing10Label.text = timing10;
    timing10Label.textColor = color;
    timing10Label.font = font;
    [cornerView addSubview:timing10Label];
    
    self.timing10secBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.timing10secBtn setImage:normalImg forState:UIControlStateNormal];
    [self.timing10secBtn setImage:selectedImg forState:UIControlStateSelected];
    self.timing10secBtn.frame = CGRectMake(cornerView.bounds.size.width - 17 - 22, 102.5+75, 22, 22);
    [self.timing10secBtn addTarget:self action:@selector(selectLockLanguage:) forControlEvents:UIControlEventTouchUpInside];
    [cornerView addSubview:self.timing10secBtn];
    
    // 定时15秒
    UIView *separactor2 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(timing10Label.frame), cornerView.bounds.size.width - 20, 1)];
    separactor2.backgroundColor = KDSRGBColor(0xea, 0xe9, 0xe9);
    [cornerView addSubview:separactor2];
    NSString *timing15 = @"定时15秒";
    UILabel *timing15Label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(separactor2.frame), 200, 75)];
    timing15Label.text =timing15;
    timing15Label.textColor = color;
    timing15Label.font = font;
    [cornerView addSubview:timing15Label];
    
    self.timing15secBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.timing15secBtn setImage:normalImg forState:UIControlStateNormal];
    [self.timing15secBtn setImage:selectedImg forState:UIControlStateSelected];
    self.timing15secBtn.frame = CGRectMake(cornerView.bounds.size.width - 17 - 22, 102.5+75 +75, 22, 22);
    [self.timing15secBtn addTarget:self action:@selector(selectLockLanguage:) forControlEvents:UIControlEventTouchUpInside];
    [cornerView addSubview:self.timing15secBtn];
   // 关闭自动上锁功能
    UIView *separactor3 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(timing15Label.frame), cornerView.bounds.size.width - 20, 1)];
    separactor3.backgroundColor = KDSRGBColor(0xea, 0xe9, 0xe9);
    [cornerView addSubview:separactor3];
    NSString *closeAuto = @"关闭自动上锁";
    UILabel *closeAutoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(separactor3.frame), 200, 75)];
    closeAutoLabel.text =closeAuto;
    closeAutoLabel.textColor = color;
    closeAutoLabel.font = font;
    [cornerView addSubview:closeAutoLabel];
    
    self.closeAutoLockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeAutoLockBtn setImage:normalImg forState:UIControlStateNormal];
    [self.closeAutoLockBtn setImage:selectedImg forState:UIControlStateSelected];
    self.closeAutoLockBtn.frame = CGRectMake(cornerView.bounds.size.width - 17 - 22, 102.5+75 +75+75, 22, 22);
    [self.closeAutoLockBtn addTarget:self action:@selector(selectLockLanguage:) forControlEvents:UIControlEventTouchUpInside];
    [cornerView addSubview:self.closeAutoLockBtn];
     // 同步锁端的设置
    if (self.lock.wifiDevice){
      
        switch (self.lock.wifiDevice.lockingMethod.intValue) {
            case 1:
                self.autoLockBtn.selected = YES;
                break;
            case 2:
                self.timing5secBtn.selected = YES;
                break;
            case 3:
                self.timing10secBtn.selected = YES;
                break;
            case 4:
                self.timing15secBtn.selected = YES;
                break;
            case 5:
                self.closeAutoLockBtn.selected = YES;
                break;
            default:
                break;
        }
        
    }
}
    

#pragma mark - 控件等事件方法。
///左开门右开门切换
- (void)selectLockLanguage:(UIButton *)sender
{
    self.autoLockBtn.selected = self.timing5secBtn.selected =  self.timing10secBtn.selected  = self.timing15secBtn.selected = self.closeAutoLockBtn.selected =NO;
    sender.selected = YES;
}
///左开门右开门切换
- (void)selectPayStyle:(UIButton *)btn {
    if (btn != self.autoLockBtn) {
        self.autoLockBtn.selected = NO;
        btn.selected = YES;
        self.autoLockBtn = btn;
    } else {
        self.autoLockBtn.selected = YES;
    }
}


// 返回按钮的状态
- (void)navBackClick{
    NSString *openDir ;
    NSString *isold ;
    if (self.autoLockBtn.selected) {
        isold = @"1";
        openDir =@"自动上锁";
    }else if(self.timing5secBtn.selected){
        isold = @"2";
        openDir =@"定时5秒";
    }else if(self.timing10secBtn.selected){
        isold = @"3";
        openDir =@"定时10秒";
    }else if(self.timing15secBtn.selected){
        isold = @"4";
        openDir =@"定时15秒";
    }else if(self.closeAutoLockBtn.selected){
        isold = @"5";
        openDir =@"关闭自动上锁";
    }
    if (!isold){
        [MBProgressHUD showError:Localized(@"您未切换，请选择切换")];
        return;
    }
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"设置上锁方式"];
    if (self.lock.wifiDevice)
    {
        [[KDSMQTTManager sharedManager] setLockingMethodWithWf:self.lock.wifiDevice volume:isold.intValue completion:^(NSError * _Nullable error, BOOL success) {
            [hud hideAnimated:YES];
            if (success) {
                NSLog(@"zhu 设置上锁方式成功");
                if (self.myBlock) {
                    self.myBlock(openDir);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSLog(@"zhu 设置上锁方式失败");
                // 测试的数据
//                if (self.myBlock) {
//                    self.myBlock(openDir);
//                }
            
                [self.navigationController popViewControllerAnimated:YES];
            }
                }];
        return;
    }
}

@end
