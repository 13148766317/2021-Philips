//
//  KDSSetDoorStrengthViewController.m
//  2021-Philips
//
//  Created by kaadas on 2021/3/1.
//  Copyright © 2021 com.Kaadas. All rights reserved.

#import "KDSSetDoorStrengthViewController.h"

#import "KDSMQTTManager+SmartHome.h"
@interface KDSSetDoorStrengthViewController ()
///高扭力
@property (nonatomic, strong) UIButton *upDoorBtn;
///低扭力按钮。
@property (nonatomic, strong) UIButton *downDoorBtn;
@end

@implementation KDSSetDoorStrengthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitleLabel.text = @"开门力量";
    [self setUI];
}

- (void)setUI
{
    UIView *cornerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 151)];
    cornerView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:cornerView];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = KDSRGBColor(0x33, 0x33, 0x33);
    UIImage *normalImg = [UIImage imageNamed:@"unselected22x22"];
    UIImage *selectedImg = [UIImage imageNamed:@"selected22x22"];
    
    NSString *zh =@"低扭力";
    UILabel *zhLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 75)];
    zhLabel.text = zh;
    zhLabel.textColor = color;
    zhLabel.font = font;
    [cornerView addSubview:zhLabel];
    
    self.downDoorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downDoorBtn setImage:normalImg forState:UIControlStateNormal];
    [self.downDoorBtn setImage:selectedImg forState:UIControlStateSelected];
    self.downDoorBtn.frame = CGRectMake(cornerView.bounds.size.width - 17 - 22, 26.5, 22, 22);
    
    [self.downDoorBtn addTarget:self action:@selector(selectPayStyle:) forControlEvents:UIControlEventTouchUpInside];
    [cornerView addSubview:self.downDoorBtn];
    
    UIView *separactor = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(zhLabel.frame), cornerView.bounds.size.width - 20, 1)];
    separactor.backgroundColor = KDSRGBColor(0xea, 0xe9, 0xe9);
    [cornerView addSubview:separactor];
    NSString *en = @"高扭力";
    UILabel *enLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(separactor.frame), 200, 75)];
    enLabel.text = en;
    enLabel.textColor = color;
    enLabel.font = font;
    [cornerView addSubview:enLabel];
    
    self.upDoorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.upDoorBtn setImage:normalImg forState:UIControlStateNormal];
    [self.upDoorBtn setImage:selectedImg forState:UIControlStateSelected];
    self.upDoorBtn.frame = CGRectMake(cornerView.bounds.size.width - 17 - 22, 102.5, 22, 22);
    
    [self.upDoorBtn addTarget:self action:@selector(selectPayStyle:) forControlEvents:UIControlEventTouchUpInside];
    [cornerView addSubview:self.upDoorBtn];
    
    if (self.lock.wifiDevice){
        if (self.lock.wifiDevice.openForce.intValue ==1) {
            self.downDoorBtn.selected = YES;
        }else{
            self.upDoorBtn.selected = YES;
            
        }

    }
    
}
#pragma mark - 控件等事件方法。
///左开门右开门切换
- (void)selectLockLanguage:(UIButton *)sender
{
    self.downDoorBtn.selected = self.upDoorBtn.selected = NO;
    sender.selected = YES;
}

///左开门右开门切换
- (void)selectPayStyle:(UIButton *)btn {
    if (btn != self.upDoorBtn) {
        self.upDoorBtn.selected = NO;
        btn.selected = YES;
        self.upDoorBtn = btn;
    } else {
        self.upDoorBtn.selected = YES;
    }
}

// 返回按钮中的提示设置的问题
- (void)navBackClick{
    NSString  *isOld;
    
    if (self.downDoorBtn.selected == YES) {
        isOld = @"1";
    } else {
        isOld = @"2";
    }
    if (!(isOld.intValue ==1 || isOld.intValue ==2)){
        [MBProgressHUD showError:Localized(@"您未切换，请选择切换")];
        return;
    }
    __weak typeof(self) weakSelf = self;
  
    if (self.lock.wifiDevice)
    {
        
        MBProgressHUD *hud = [MBProgressHUD showMessage:@"设置门锁的力量"];
        [[KDSMQTTManager sharedManager]  setOpenForceWithWf:self.lock.wifiDevice volume:isOld.intValue completion:^(NSError * _Nullable error, BOOL success) {
            [hud hideAnimated:YES];
            if (success) {
                NSLog(@"zhu 设置力量请求成功");
                // 返回block
                [MBProgressHUD showError:@"设置成功"];
                if (self.myBlock) {
                    self.myBlock(isOld.intValue == 1 ? @"低扭力" : @"高扭力");
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSLog(@"zhu 设置力量请求失败");
                // 测试用的数据
//                if (self.myBlock) {
//                    self.myBlock(isOld.intValue == 1 ? @"低fefe扭力" : @"高扭力");
//                }

                [self.navigationController popViewControllerAnimated:YES];
             }
                }];
        return;
    }
}


@end
