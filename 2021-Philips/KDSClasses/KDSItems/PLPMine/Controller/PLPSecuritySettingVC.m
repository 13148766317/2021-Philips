//
//  PLPSecuritySettingVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/20.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPSecuritySettingVC.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "KDSDBManager.h"

@interface PLPSecuritySettingVC ()

///touch ID状态标签。
@property (nonatomic, strong) UILabel *touchIDStateLabel;
///touch ID状态选择开关。
@property (nonatomic, strong) UIButton *touchIDBtn;
///数据库管理对象。
@property (nonatomic, strong, readonly) KDSDBManager *dbMgr;

@end

@implementation PLPSecuritySettingVC

- (KDSDBManager *)dbMgr
{
    return [KDSDBManager sharedManager];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationTitleLabel.text = @"系统设置";//Localized(@"securitySetting");
    CGFloat height = 60;
    UIView *cornerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, height * 1)];
    cornerView.layer.cornerRadius = 5;
    cornerView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:cornerView];
    
    self.touchIDStateLabel = [UILabel new];
    BOOL idOn = self.dbMgr.queryUserTouchIDState;
    self.touchIDStateLabel.text = Localized(idOn ? @"closeTouchID" : @"openTouchID");
    self.touchIDStateLabel.textColor = UIColor.blackColor;
    self.touchIDStateLabel.font = [UIFont systemFontOfSize:16];
    self.touchIDStateLabel.textAlignment = NSTextAlignmentLeft;
    [cornerView addSubview:self.touchIDStateLabel];
    [self.touchIDStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cornerView.mas_left).offset(15);
        make.top.bottom.equalTo(cornerView);
        make.width.equalTo(@(KDSScreenWidth/2));
    }];
    self.touchIDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.touchIDBtn setBackgroundImage:[UIImage imageNamed:@"philips_icon_switch_close"] forState:UIControlStateNormal];
    [self.touchIDBtn setBackgroundImage:[UIImage imageNamed:@"philips_icon_switch_open"] forState:UIControlStateSelected];
    [self.touchIDBtn addTarget:self action:@selector(switchGesturePwdOrTouchIDState:) forControlEvents:UIControlEventTouchUpInside];
    [cornerView addSubview:self.touchIDBtn];
    
    [self.touchIDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cornerView.mas_right).offset(-15);
        make.width.equalTo(@57);
        make.height.equalTo(@37);
        make.centerY.equalTo(cornerView.mas_centerY);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    BOOL idOn = self.dbMgr.queryUserTouchIDState;
    self.touchIDStateLabel.text = Localized(idOn ? @"closeTouchID" : @"openTouchID");
    LAContext *ctx = [[LAContext alloc] init];
    if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
         if (@available(iOS 11.0, *))
           {
               if (ctx.biometryType == LABiometryTypeFaceID)
               {
                   self.touchIDStateLabel.text = Localized(idOn ? @"closeFaceID" : @"openFaceID");
               }
           }
    }
    self.touchIDBtn.selected = idOn;
}

#pragma mark - 控件等事件方法。
///选择手势密码或者touch ID状态，0是手势开关，1是touch ID开关。
-(void)switchGesturePwdOrTouchIDState:(UIButton *)swi
{
    //touch ID开关
        LAContext *ctx = [[LAContext alloc] init];
        NSError * __autoreleasing error;
        //用来检查当前设备是否可用touchID，返回一个BOOL值
        if (![ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
        {//设备不支持指纹识别
            NSString *title = nil;
            if (@available(iOS 11.0, *))
            {
                BOOL fid = ctx.biometryType == LABiometryTypeFaceID;
                switch (error.code)
                {
                    case LAErrorBiometryLockout:
                        title = Localized((fid ? @"There were too many failed Face ID attempts and Face ID is now locked" : @"There were too many failed Touch ID attempts and Touch ID is now locked"));
                        break;
                        
                    case LAErrorBiometryNotAvailable:
                        title = Localized((fid ? @"deviceNotSupportOrCan'tUseFaceID" : @"deviceNotSupportOrCan'tUseTouchID"));
                        break;
                        
                    case LAErrorBiometryNotEnrolled:
                        title = Localized((fid ? @"The user has no enrolled Face ID" : @"The user has no enrolled Touch ID fingers"));
                        break;
                        
                    default:
                        break;
                 }
             }else{
                 switch (error.code)
                 {
                     case LAErrorTouchIDNotAvailable:
                         title = Localized(@"deviceNotSupportOrCan'tUseTouchID");
                         break;
                         
                     case LAErrorTouchIDNotEnrolled:
                         title = Localized(@"The user has no enrolled Touch ID fingers");
                         break;
                         
                     case LAErrorTouchIDLockout:
                         title = Localized(@"There were too many failed Touch ID attempts and Touch ID is now locked");
                         break;
                         
                     default:
                         break;
                 }
             }
            if (title){
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:Localized(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [swi setOn:!swi.on animated:YES];
//                    swi.selected = !swi.selected;
                }];
                [ac addAction:ok];
                [self presentViewController:ac animated:YES completion:nil];
            }

        }
        else
        {
            NSLog(@"--{Kaadas}--swi.on=%d",swi.selected);
            NSString *reason = Localized(swi.selected ? @"authAndOpenTouchID" : @"authAndCloseTouchID");
            BOOL isFaceID = NO;
            if (@available(iOS 11.0, *))
            {
                if (ctx.biometryType == LABiometryTypeFaceID)
                {
                    reason = Localized(swi.selected ? @"authAndOpenFaceID" : @"authAndCloseFaceID");
                    isFaceID = YES;
                }
            }
            ctx.localizedFallbackTitle = @"";
            //调用验证方法，会弹验证指纹密码框
            [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reason reply:^(BOOL success, NSError * _Nullable error) {
                
                NSLog(@"808080808080");
                dispatch_async(dispatch_get_main_queue(), ^{

                    BOOL res = NO;
                    if (success)
                    {
                        BOOL ison ;
                        if (swi.selected) {
                            ison = NO;
                        }else{
                            ison = YES;
                        }
                        res = [self.dbMgr updateUserTouchIDState:ison];
                        swi.selected = !swi.selected;
                    }
                    if (error) {
                    //指纹识别失败，回主线程更新UI
                        LAError errorCode = error.code;
                        NSLog(@"--{Kaadas}--errorCode=%ld",(long)errorCode);
                        switch (errorCode) {
                            case LAErrorAuthenticationFailed: {
//                                NSLog(@"授权失败"); // -1 连续三次指纹识别错误
                                break;
                            }
                            case LAErrorUserCancel: // Authentication was canceled by user (e.g. tapped Cancel button)
                            {
                                NSLog(@"用户取消验证Touch ID"); // -2 在TouchID对话框中点击了取消按钮
                            }
                                break;
                            case LAErrorUserFallback: {
//                                NSLog(@"用户选择输入密码，切换主线程处理"); // -3 在TouchID对话框中点击了输入密码按钮
                                break;
                            }
                            case LAErrorSystemCancel: {
//                                NSLog(@"取消授权，如其他应用切入"); // -4 TouchID对话框被系统取消，例如按下Home或者电源键
                                break;
                            }
                            case LAErrorPasscodeNotSet: {
//                                NSLog(@"设备系统未设置密码"); // -5
                                break;
                            }
                            case LAErrorTouchIDNotAvailable: {
//                                 NSLog(@"设备未设置Touch ID"); // -6
                                break;
                            }
                            case LAErrorTouchIDNotEnrolled: {
//                                 NSLog(@"用户未录入指纹"); // -7
                                break;
                            }
                            case LAErrorTouchIDLockout: {
//                                NSLog(@"Touch ID被锁，需要用户输入密码解锁"); // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                                break;
                            }
                            case LAErrorAppCancel: {
//                                NSLog(@"用户不能控制情况下APP被挂起"); // -9
                                break;
                            }
                            case LAErrorInvalidContext: {
//                                NSLog(@"LAContext传递给这个调用之前已经失效"); // -10
                                break;
                            }
                            case LAErrorNotInteractive: {
//                            NSLog(@"验证失败，因为它需要显示被禁止的UI"); //验证失败，因为它需要显示被禁止的UI
                                break;
                            }
                           
                        }
                    }
                    
                    if (res)
                    {
                        self.touchIDStateLabel.text = Localized(swi.selected ? (isFaceID ? @"closeFaceID" : @"closeTouchID") : (isFaceID ? @"openFaceID" : @"openTouchID"));
                    }
                    else
                    {
//                        [swi setOn:!swi.on animated:YES];
//                        swi.selected = !swi.selected;
                    }
                });
            }];
        }
}


@end
