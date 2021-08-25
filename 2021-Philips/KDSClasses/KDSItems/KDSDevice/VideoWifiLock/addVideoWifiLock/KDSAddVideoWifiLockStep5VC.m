//
//  KDSAddVideoWifiLockStep5VC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2020/9/8.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSAddVideoWifiLockStep5VC.h"
#import "MBProgressHUD+MJ.h"
#import "KDSVideoLockDistributionNetworkVC.h"
#import "KDSMediaLockInPutAdminPwdVC.h"
#import "KDSWifiLockModel.h"
#import "KDSAddWiFiLockFailVC.h"
#import "KDSXMMediaLockHelpVC.h"

@interface KDSAddVideoWifiLockStep5VC ()

@property (nonatomic, strong) UIImageView *QRCodeImg;
///是否已经push过（只能执行一次）
@property (nonatomic, assign) BOOL ispushing;
// 当前试图控制器的亮度
@property (nonatomic, readwrite, assign) CGFloat currentLight;

// 下一步按钮
@property (nonatomic, strong )  UIButton * nextButton;

// 语音提示
@property (nonatomic,strong ) UILabel * failelabel;
@property (nonatomic,strong)  UIButton  * selectBtn;

@end

///label之间多行显示的行间距
#define labelWidth 5
@implementation KDSAddVideoWifiLockStep5VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.ispushing = YES;
    self.navigationTitleLabel.text = Localized(@"扫描二维码");
    [self setRightButton];
//    [self.rightButton setImage:[UIImage imageNamed:@"questionMark"] forState:UIControlStateNormal];
   //  [self setUI];
    [self setupUI];
    KDSUserManager *user = [KDSUserManager sharedManager];
    ///先去服务器请求讯美认证token，请求失败的话，没有必要进行下一步了，直接返回
    NSString *jsonStr = [self convertToJsonData:@{ @"s": self.ssid, @"p": self.pwd, @"u": user.user.uid }];
    [self generateQRCodeWithStr:jsonStr];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaLockBindStatus:) name:KDSMQTTEventNotification object:nil];
}

// 进入控制器完成后，让控制器变量
- (void)viewDidAppear:(BOOL)animated
{
    [[UIScreen mainScreen] setBrightness:0.9]; //0.1~1.0之间，值越大越亮
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KDSMQTTEventNotification object:nil];
    [[UIScreen mainScreen] setBrightness:0.5];
}

- (void)setupUI {
    UIView *supView = [UIView new];
    // supView.backgroundColor = UIColor.whiteColor;
    supView.backgroundColor = KDSRGBColor(247, 247, 247);
    [self.view addSubview:supView];
    [supView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    // 添加滚动视图的占位图
    UIView *topView = [UIView  new];
    [supView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(supView).offset(20);
        make.right.left.equalTo(supView);
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

    // 二维码图片
    self.QRCodeImg = [UIImageView new];
    [self.view addSubview:self.QRCodeImg];
    [self.QRCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(176);
        make.width.mas_equalTo(166);
        make.top.equalTo(topView.mas_bottom).offset(60);
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    UILabel *tipslable = [UILabel new];
    tipslable.text = @"请将二维码正对门锁摄像头8-20CM范围内";
    tipslable.font = [UIFont systemFontOfSize:14];
    tipslable.textColor = KDSRGBColor(102, 102, 102);
    [self.view addSubview:tipslable];
    [tipslable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QRCodeImg.mas_bottom).offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    
  // 点击进行下一步的按钮
  _nextButton = [UIButton new];
   [_nextButton setBackgroundColor:KDSRGBColor(179, 200, 230)];
   [_nextButton setTitle:Localized(@"下一步") forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(connectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   [self.view addSubview:_nextButton];
   [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.view).offset(15);
       make.height.equalTo(@44);
       make.right.equalTo(self.view).offset(-15);
       make.bottom.equalTo(self.view).offset(-80);
   }];
   
   UIView  * view = [UIView new];
  // view.backgroundColor = UIColor.whiteColor;
    UITapGestureRecognizer  * selectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(visibleBtn)];
    [view addGestureRecognizer:selectTap];
     view.userInteractionEnabled = YES;
   [self.view addSubview:view];
   [view mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.equalTo(_nextButton.mas_top).offset(0);
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

  _selectBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    _selectBtn.backgroundColor = [UIColor clearColor];
   [_selectBtn setTintColor:[UIColor clearColor]];
   //self.agreeBtn.selected = YES;
   [_selectBtn setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_default"] forState:UIControlStateNormal];
   [_selectBtn setBackgroundImage:[UIImage imageNamed:@"philips_dms_icon_selected"] forState:UIControlStateSelected];
   [_selectBtn addTarget:self action:@selector(visibleBtn:) forControlEvents:UIControlEventTouchUpInside];
   [self.view addSubview:_selectBtn];
   
   [_selectBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(view.mas_centerY);
       make.height.width.equalTo(@18);
       make.right.equalTo(plaseLable.mas_left).offset(-10);
   }];
   _failelabel = [UILabel new];
    _failelabel.text= @"语音提示设置失败 ？";
    _failelabel.textColor = KDSRGBColor(233, 131, 0);
    _failelabel.font = [UIFont systemFontOfSize:14];
    UITapGestureRecognizer  *  failtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(failTap)];
    _failelabel.userInteractionEnabled = YES;
    [_failelabel addGestureRecognizer:failtap];
   [self.view addSubview:_failelabel];
   [_failelabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(_nextButton.mas_bottom).offset(10);
       make.centerX.equalTo(self.view.mas_centerX);
   }];

}



- (void)setLabelSpace:(UILabel *)label withSpace:(CGFloat)space withFont:(UIFont *)font  {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    if (label.tag == 2) {
        paraStyle.alignment = NSTextAlignmentCenter;
    } else {
        paraStyle.alignment = NSTextAlignmentLeft;
    }
    paraStyle.lineSpacing = space; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{ NSFontAttributeName: font, NSParagraphStyleAttributeName: paraStyle, NSKernAttributeName: @0.0f };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:label.text attributes:dic];
    label.attributedText = attributeStr;
}

- (void)generateQRCodeWithStr:(NSString *)mesStr {
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];

    //过滤器恢复默认
    [filter setDefaults];
    //给过滤器添加数据
    NSString *string = mesStr;
    //将NSString格式转化成NSData格式
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSLog(@"配网时候的json字符串：%@-----data数据：%@", mesStr, data);
    [filter setValue:data forKeyPath:@"inputMessage"];
    //获取二维码过滤器生成的二维码
    CIImage *image = [filter outputImage];
    //将获取到的二维码添加到imageview上
    self.QRCodeImg.image = [self createNonInterpolatedUIImageFormCIImage:image withSize:550];
    //----------------给 二维码 中间增加一个 自定义图片----------------
    //开启绘图,获取图形上下文  (上下文的大小,就是二维码的大小)
    UIGraphicsBeginImageContext(self.QRCodeImg.image.size);
    //把二维码图片画上去. (这里是以,图形上下文,左上角为 (0,0)点)
    UIGraphicsBeginImageContextWithOptions(self.QRCodeImg.image.size, NO, [[UIScreen mainScreen] scale]);
    [self.QRCodeImg.image drawInRect:CGRectMake(0, 0, self.QRCodeImg.image.size.width, self.QRCodeImg.image.size.height)];
//    //再把小图片画上去                去掉kds小图标
//    UIImage *sImage = [UIImage imageNamed:@"RQCodeLogo"];
//    CGFloat sImageW = 150;
//    CGFloat sImageH = 66;
//    CGFloat sImageX = (self.QRCodeImg.image.size.width - sImageW) * 0.5;
//    CGFloat sImgaeY = (self.QRCodeImg.image.size.height - sImageH) * 0.5;
//    [sImage drawInRect:CGRectMake(sImageX, sImgaeY, sImageW, sImageH)];
    //获取当前画得的这张图片
    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    //设置图片
    self.QRCodeImg.image = finalyImage;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));

    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

// 字典转json字符串方法
- (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(void)visibleBtn{
    self.selectBtn.selected = !self.selectBtn.selected;
    if (self.selectBtn.selected ) {
        [self.nextButton setBackgroundColor:KDSRGBColor(0, 102, 161)];
    }else{
        [self.nextButton setBackgroundColor:KDSRGBColor(179, 200, 230)];
        }
    
}
- (void)visibleBtn :(UIButton *)sender{
    NSLog(@"是否收到锁端的语音提示");
    sender.selected = !sender.selected;
    //更改按钮的颜色
    if (sender.selected) {
        [self.nextButton setBackgroundColor:KDSRGBColor(0, 102, 161)];
    }else{
        [self.nextButton setBackgroundColor:KDSRGBColor(179, 200, 230)];
        }
}


#pragma mark --点击事件
//Wi-Fi已连接，下一步
- (void)connectBtnClick:(UIButton *)sender
{
    if (!self.selectBtn.selected) {
        return;
    }
    KDSVideoLockDistributionNetworkVC *vc = [KDSVideoLockDistributionNetworkVC new];
    vc.ssid = self.ssid;
    vc.pwd = self.pwd;
    [self.navigationController pushViewController:vc animated:YES];
}

//语音播报”配网失败“回到输入ssid、pwd页面重新输入
- (void)reNetworkBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navRightClick
{
    KDSXMMediaLockHelpVC *vc = [KDSXMMediaLockHelpVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)failTap{
    NSLog(@"失败的提示弹窗");
    [MBProgressHUD  showSuccess:@"设置失败"];
}

#pragma mark -- 视频锁绑定结果的通知
- (void)mediaLockBindStatus:(NSNotification *)noti
{
    KDSWifiLockModel *model = [KDSWifiLockModel new];
    MQTTSubEvent subevent = noti.userInfo[MQTTEventKey];
    NSDictionary *param = noti.userInfo[MQTTEventParamKey];
    if ([subevent isEqualToString:MQTTSubEventMdeiaLockBindSucces]) {//视频锁绑定成功
        model.device_sn = param[@"device_sn"];
        model.mac = param[@"mac"];
        model.device_did = param[@"device_did"];
        model.p2p_password = param[@"p2p_password"];
        // 数据对比
        NSLog(@"zhu--  KDSAddVideoWifiLockStep5VC --数据对比 p2p 密码 ==%@", model.p2p_password);

        model.wifiName = self.ssid;
        model.wifiSN = param[@"wfId"];
        KDSMediaLockInPutAdminPwdVC *vc = [KDSMediaLockInPutAdminPwdVC new];
        vc.model = model;
        vc.crcData = param[@"randomCode"];
        if (self.ispushing) {
            self.ispushing = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([subevent isEqualToString:MQTTSubEventMdeiaLockBindErrorNotity]) {
        //不管超时还是其他错误，都结束配网且失败
        KDSAddWiFiLockFailVC *vc = [KDSAddWiFiLockFailVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
