//
//  KDSSetDoorDirectionViewController.m
//  2021-Philips
//
//  Created by kaadas on 2021/3/1.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "KDSSetDoorDirectionViewController.h"
#import "KDSLockMoreSettingCell.h"
#import "KDSMQTTManager+SmartHome.h"

@interface KDSSetDoorDirectionViewController ()
///左开门选择按钮。
@property (nonatomic, strong) UIButton *leftDoorBtn;
///右开门选择按钮。
@property (nonatomic, strong) UIButton *rightDoorBtn;

@end

@implementation KDSSetDoorDirectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationTitleLabel.text = @"开门方向";
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

    NSString *zh = @"左开门";
    UILabel *zhLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 75)];
    zhLabel.text = zh;
    zhLabel.textColor = color;
    zhLabel.font = font;
    [cornerView addSubview:zhLabel];

    self.leftDoorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftDoorBtn setImage:normalImg forState:UIControlStateNormal];
    [self.leftDoorBtn setImage:selectedImg forState:UIControlStateSelected];
    self.leftDoorBtn.frame = CGRectMake(cornerView.bounds.size.width - 17 - 22, 26.5, 22, 22);

    [self.leftDoorBtn addTarget:self action:@selector(selectPayStyle:) forControlEvents:UIControlEventTouchUpInside];
    [cornerView addSubview:self.leftDoorBtn];

    UIView *separactor = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(zhLabel.frame), cornerView.bounds.size.width - 20, 1)];
    separactor.backgroundColor = KDSRGBColor(0xea, 0xe9, 0xe9);
    [cornerView addSubview:separactor];
    NSString *en = @"右开门";
    UILabel *enLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(separactor.frame), 200, 75)];
    enLabel.text = en;
    enLabel.textColor = color;
    enLabel.font = font;
    [cornerView addSubview:enLabel];

    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setImage:normalImg forState:UIControlStateNormal];
    [self.rightButton setImage:selectedImg forState:UIControlStateSelected];
    self.rightButton.frame = CGRectMake(cornerView.bounds.size.width - 17 - 22, 102.5, 22, 22);

    [self.rightButton addTarget:self action:@selector(selectPayStyle:) forControlEvents:UIControlEventTouchUpInside];
    [cornerView addSubview:self.rightButton];

    //   同步wifi锁端的设置
    if (self.lock.wifiDevice) {
        if (self.lock.wifiDevice.openDirection.intValue == 1) {
            //1.左开门；  按钮被选中
            self.leftDoorBtn.selected = YES;
        } else { //2.右开门
            self.rightButton.selected = YES;
        }
    }
}

#pragma mark - 控件等事件方法。
///左开门右开门切换
- (void)selectPayStyle:(UIButton *)btn {
    if (btn != self.leftDoorBtn) {
        self.leftDoorBtn.selected = NO;
        btn.selected = YES;
        self.leftDoorBtn = btn;
    } else {
        self.leftDoorBtn.selected = YES;
    }
}

// 返回按钮：返回即触发设置事件
- (void)navBackClick {
    NSString *isold;
    if (self.leftDoorBtn.selected == YES) {
        isold = @"1";
    } else {
        isold = @"2";
    }
    if (!(isold.intValue == 1 || isold.intValue == 2)) {
        [MBProgressHUD showError:Localized(@"您未切换，请选择切换")];
        return;
    }
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"设置开锁方向"];
    if (self.lock.wifiDevice) {
        [[KDSMQTTManager  sharedManager] setOpenDirectionWithWf:weakSelf.lock.wifiDevice volume:isold.intValue completion:^(NSError *_Nullable error, BOOL success) {
            [hud hideAnimated:YES];
            if (success) {
                NSLog(@"zhu mqtt请求成功");
                [MBProgressHUD showError:@"设置成功"];
                if (self.myBlock) {
                    self.myBlock(isold.intValue == 1 ? @"左开门" : @"右开门");
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSLog(@"zhu mqtt请求失败");
                [MBProgressHUD showError:@"设置失败"];
//                if (self.myBlock) {
//                    self.myBlock(isold.intValue == 1 ? @"左开门" : @"右开门");
//                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            // [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

@end
