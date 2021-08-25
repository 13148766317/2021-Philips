//
//  PLPNewAddDeviceVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2021/7/22.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPNewAddDeviceVC.h"
// 弹窗提示
#import "PLPScanAddDeviceHelpView.h"
#import "SYAlertView.h"
#import "RHScanPermissions.h"
#import "RHScanNative.h"
#import "RHScanView.h"
#import <AudioToolbox/AudioToolbox.h> //声音提示
#import "KDSAddGWThreVC.h"
#import "KDSProductActivationVC.h"
#import "KDSAddNewWiFiLockStep1VC.h"
#import "MBProgressHUD+MJ.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "KDSAddBleAndWiFiLockStep1.h"
#import "KDSAddVideoWifiLockStep1VC.h"
#import "KDSAddSmartHangerStep1VC.h"
#import "PLPProductListManager.h"
#import "KDSAddVideoWifiLockStep3VC.h"
#import "PLPScanAddDeviceHelpView.h"
///手动添加设备相关
#import "KDSFuntionTabListCell.h"
#import "KDSAddVideoWifiLockStep3VC.h"
#import "PLPAddVideoWifiLockStep3VC.h"
#import "PLPProductListManager.h"
#import "KDSFormController.h"
#import "PLPFormUtils.h"
#import "PLPAddDeviceSectionHeaderView.h"

static NSString * const funtionTabListCell = @"KDSFuntionTabListCell";

@interface PLPNewAddDeviceVC ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,WKNavigationDelegate, WKUIDelegate,UIImagePickerControllerDelegate,backBtnDelegate,UICollectionViewDelegate ,UICollectionViewDataSource,UITextFieldDelegate>

///扫码添加设备按钮。
@property (nonatomic, strong) UIButton *sweepAddDevBtn;
///手动添加设备按钮。
@property (nonatomic, strong) UIButton *manuallyAddDevBtn;
///扫码添加设备的UI
@property (nonatomic, strong) UIView * sweepAddDevView;
///手动添加设备的UI
@property (nonatomic, strong) UIView * manuallyAddDeView;
///白色移动游标。
@property (nonatomic, strong) UIView *cursorView;
///横向滚动的滚动视图，装着扫码添加和手动添加视图。
@property (nonatomic, strong) UIScrollView *scrollView;

#pragma mark -----  扫码使用的库对象 -------
@property (nonatomic,strong) RHScanNative* scanObj;
/// 扫码区域视图,二维码一般都是框
@property (nonatomic,strong) RHScanView* qRScanView;
///记录开始的缩放比例
@property(nonatomic,assign)CGFloat beginGestureScale;
///最后的缩放比例
@property(nonatomic,assign)CGFloat effectiveScale;
///上个导航控制器的代理。
@property (nonatomic, weak)id<UINavigationControllerDelegate> preDelegate;
@property (nonatomic,strong)WKWebView *webView;
///请求web页面超时
@property (nonatomic,strong)NSTimer * timeOut;
///获取开锁记录时转的菊花。
@property (nonatomic, strong)UIActivityIndicatorView *nodataActivity;
@property (nonatomic,strong)UIView * supView;
///添加成功之后弹出的提示设置开关的视图
@property (nonatomic, strong) PLPScanAddDeviceHelpView *successShowView;
@property (nonatomic, strong) SYAlertView *alertView;
///手动添加设备的展示UI
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) PLPProductCategory datasourceCategory;
@property (nonatomic, strong) NSArray *productCategorys;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *,NSMutableArray<PLPProductInfo *>*> *productListDict;
//用于搜索产品
@property (nonatomic, strong) NSString *lastSearchKeyword;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) KDSFormController *searchFormController;
@property (nonatomic, strong) NSMutableArray<XLFormRowDescriptor *> *searchDataSource;
@property (nonatomic, strong) XLFormSectionDescriptor *searchFormSection;
@property(nonatomic,strong) UITextField  *devTextField;

@end

@implementation PLPNewAddDeviceVC

- (UIActivityIndicatorView *)nodataActivity
{
    if (!_nodataActivity)
    {
        _nodataActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGPoint center = CGPointMake(kScreenWidth / 2.0, self.sweepAddDevView.bounds.size.height / 2.0);
        _nodataActivity.center = center;
        [self.sweepAddDevView addSubview:_nodataActivity];
    }
    return _nodataActivity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.productCategorys = [[PLPProductListManager sharedInstance] productCategorys];
    
    [self setUI];
    self.view.backgroundColor = KDSRGBColor(0, 102, 161);
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.sweepAddDevView.backgroundColor = UIColor.blackColor;
    _effectiveScale = 1;
    [self cameraInitOver];
    [self drawScanView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.preDelegate = self.navigationController.delegate;
    self.navigationController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [RHScanPermissions requestCameraPemissionWithResult:^(BOOL granted) {
        if (granted) {
            //不延时，可能会导致界面黑屏并卡住一会
            [self performSelector:@selector(startScan) withObject:nil afterDelay:0.1];
        }else{
            [_qRScanView stopDeviceReadying];
            [self showError:@"请到设置隐私中开启本程序相机权限" withReset:NO];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.delegate = self.preDelegate;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self stopScan];
    [_qRScanView stopScanAnimation];
    self.navigationController.navigationBar.barTintColor = UIColor.whiteColor;
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setUI{
    
    UIView * topFunView = [UIView new];
    topFunView.backgroundColor = KDSRGBColor(0, 102, 161);
    [self.view addSubview:topFunView];
    [topFunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(kStatusBarHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.equalTo(@50);
    }];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"whiteBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [topFunView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topFunView.mas_left).offset(0);
        make.top.mas_equalTo(topFunView.mas_top).offset(0);
        make.bottom.mas_equalTo(topFunView.mas_bottom).offset(0);
        make.width.equalTo(@40);
    }];
    
    UIButton * helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpBtn setImage:[UIImage imageNamed:@"icon_help-1"] forState:UIControlStateNormal];
    [helpBtn addTarget:self action:@selector(helpClick:) forControlEvents:UIControlEventTouchUpInside];
    [topFunView addSubview:helpBtn];
    [helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(topFunView.mas_right).offset(0);
        make.top.mas_equalTo(topFunView.mas_top).offset(0);
        make.bottom.mas_equalTo(topFunView.mas_bottom).offset(0);
        make.width.equalTo(@40);
    }];
    
    self.sweepAddDevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sweepAddDevBtn setTitle:@"扫码添加" forState:UIControlStateNormal];
    [self.sweepAddDevBtn setTitleColor:KDSRGBColor(127, 169, 199) forState:UIControlStateNormal];
    [self.sweepAddDevBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    self.sweepAddDevBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.sweepAddDevBtn.selected = YES;
    [self.sweepAddDevBtn addTarget:self action:@selector(clickMsgBtnAdjustScrollViewContentOffset:) forControlEvents:UIControlEventTouchUpInside];
    [topFunView addSubview:self.sweepAddDevBtn];
    [self.sweepAddDevBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topFunView.mas_left).offset(60);
        make.top.mas_equalTo(topFunView.mas_top).offset(0);
        make.bottom.mas_equalTo(topFunView.mas_bottom).offset(0);
        make.width.equalTo(@((KDSScreenWidth-120)/2));
    }];
    
    
    self.manuallyAddDevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.manuallyAddDevBtn setTitle:@"手动添加" forState:UIControlStateNormal];
    [self.manuallyAddDevBtn setTitleColor:KDSRGBColor(127, 169, 199) forState:UIControlStateNormal];
    [self.manuallyAddDevBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    self.manuallyAddDevBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.manuallyAddDevBtn.selected = NO;
    [self.manuallyAddDevBtn addTarget:self action:@selector(clickMsgBtnAdjustScrollViewContentOffset:) forControlEvents:UIControlEventTouchUpInside];
    [topFunView addSubview:self.manuallyAddDevBtn];
    [self.manuallyAddDevBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(topFunView.mas_right).offset(-60);
        make.top.mas_equalTo(topFunView.mas_top).offset(0);
        make.bottom.mas_equalTo(topFunView.mas_bottom).offset(0);
        make.width.equalTo(@((KDSScreenWidth-120)/2));
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.alwaysBounceVertical = NO;
    //    self.scrollView.scrollEnabled = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topFunView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    self.cursorView = [[UIView alloc] init];
    self.cursorView.layer.cornerRadius = 1.5;
    self.cursorView.backgroundColor = UIColor.whiteColor;
    [topFunView addSubview:self.cursorView];
    [self.cursorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.sweepAddDevBtn);
        make.bottom.mas_equalTo(topFunView.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(50, 3));
    }];
    
    self.sweepAddDevView = [[UIView alloc] init];
    self.sweepAddDevView.backgroundColor = UIColor.redColor;
    [self.scrollView addSubview:self.sweepAddDevView];
    
    
    self.manuallyAddDeView = [[UIView alloc] init];
    self.manuallyAddDeView.backgroundColor = KDSRGBColor(247, 247, 247);
    [self.scrollView addSubview:self.manuallyAddDeView];
    
    ///搜索框视图
    UIView * bottomView = [UIView new];
    bottomView.backgroundColor = KDSRGBColor(0, 102, 161);
    [self.manuallyAddDeView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.manuallyAddDeView);
        make.height.equalTo(@50);
    }];
    
    ///搜索框视图
    UIView * serachView = [UIView new];
    serachView.backgroundColor = UIColor.whiteColor;
    serachView.layer.cornerRadius = 3;
    [bottomView addSubview:serachView];
    [serachView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView.mas_top).offset(5);
        make.left.mas_equalTo(bottomView.mas_left).offset(16);
        make.right.mas_equalTo(bottomView.mas_right).offset(-16);
        make.bottom.mas_equalTo(bottomView.mas_bottom).offset(-7);
    }];
    
    UIImageView * searchIconImg = [UIImageView new];
    searchIconImg.image = [UIImage imageNamed:@"philips_home_scan_icon_search"];
    [serachView addSubview:searchIconImg];
    [searchIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.left.equalTo(serachView.mas_left).offset(5);
        make.centerY.equalTo(serachView);
        
    }];
    _devTextField = [UITextField new];
    _devTextField.borderStyle = UITextBorderStyleNone;
    _devTextField.font = [UIFont systemFontOfSize:15];
    _devTextField.keyboardType = UIKeyboardTypeDefault;
    _devTextField.placeholder = Localized(@"请输入门锁型号");
    _devTextField.delegate = self;
    [serachView addSubview:_devTextField];
    [_devTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIconImg.mas_right).offset(7);
        make.right.equalTo(serachView.mas_right).offset(0);
        make.top.equalTo(serachView.mas_top).offset(0);
        make.bottom.equalTo(serachView.mas_bottom).offset(0);
    }];
    
    [self.manuallyAddDeView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.manuallyAddDeView.mas_right).offset(-20);
        make.left.mas_equalTo(self.manuallyAddDeView.mas_left).offset(KDSScreenWidth /4 +20);
        make.bottom.equalTo(self.manuallyAddDeView.mas_bottom).offset(-kBottomSafeHeight);
        make.top.mas_equalTo(serachView.mas_bottom).offset(30);
    }];
    
    UILabel * tipsLb = [UILabel new];
    tipsLb.text = @"智能锁";
    tipsLb.textColor = KDSRGBColor(0, 102, 161);
    tipsLb.textAlignment = NSTextAlignmentLeft;
    tipsLb.font = [UIFont systemFontOfSize:16];
    [self.manuallyAddDeView addSubview:tipsLb];
    [tipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.manuallyAddDeView.mas_left).offset(16);
        make.right.mas_equalTo(self.collectionView.mas_left).offset(-10);
        make.top.mas_equalTo(serachView.mas_bottom).offset(45);
        make.height.equalTo(@30);
    }];
}
#pragma mark  -  二微码扫描相册相关
- (void)presentPhotoLibraryWithRooter:(UIViewController *)rooter callback:(nonnull void (^)(NSString * _Nonnull))callback {
   // _callback = callback;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [rooter presentViewController:imagePicker animated:YES completion:nil];
}
// 实现代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *pickedImage = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
       CIImage *detectImage = [CIImage imageWithData:UIImagePNGRepresentation(pickedImage)];
       
       CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
       CIQRCodeFeature *feature = (CIQRCodeFeature *)[detector featuresInImage:detectImage options:nil].firstObject;
       
       [picker dismissViewControllerAnimated:YES completion:^{
           if (feature.messageString) {
             //  [self handleCodeString:feature.messageString];
           }
       }];

}

//绘制扫描区域
- (void)drawScanView
{
    if (!_qRScanView)
    {
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        if (_style == nil) {
            _style = [RHScanViewStyle new];
        }
        self.qRScanView = [[RHScanView alloc]initWithFrame:rect style:_style];
        self.qRScanView.delegate = self;
        [self.sweepAddDevView addSubview:_qRScanView];
    }
    [_qRScanView startDeviceReadyingWithText:_cameraInvokeMsg];
}

#pragma mark 增加拉近/远视频界面
- (void)cameraInitOver
{
    if (self.isVideoZoom) {
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
        pinch.delegate = self;
        [self.sweepAddDevView addGestureRecognizer:pinch];
    }
}

- (void)pinchDetected:(UIPinchGestureRecognizer*)recogniser
{
    self.effectiveScale = self.beginGestureScale * recogniser.scale;
    if (self.effectiveScale < 1.0){
        self.effectiveScale = 1.0;
    }
    [self.scanObj setVideoScale:self.effectiveScale];
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        _beginGestureScale = _effectiveScale;
    }
    return YES;
}

- (void)reStartDevice
{
    [_scanObj startScan];
}

//启动设备
- (void)startScan
{
    if ( ![RHScanPermissions cameraPemission] )
    {
        [_qRScanView stopDeviceReadying];
        [self showError:@"请到设置隐私中开启本程序相机权限" withReset:NO];
        return;
    }
    
    UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.sweepAddDevView.frame), CGRectGetHeight(self.sweepAddDevView.frame))];
    videoView.backgroundColor = [UIColor clearColor];
    [self.sweepAddDevView insertSubview:videoView atIndex:0];
    __weak __typeof(self) weakSelf = self;
    
    if (!_scanObj )
    {
        CGRect cropRect = CGRectZero;
        if (_isOpenInterestRect) {
            //设置只识别框内区域
            cropRect = [RHScanView getScanRectWithPreView:self.sweepAddDevView style:_style];
        }
        //AVMetadataObjectTypeITF14Code 扫码效果不行,另外只能输入一个码制，虽然接口是可以输入多个码制
        self.scanObj = [[RHScanNative alloc]initWithPreView:videoView ObjectType:nil cropRect:cropRect success:^(NSArray<NSString *> *array) {
            [weakSelf scanResultWithArray:array];
        }];
        [_scanObj setNeedCaptureImage:NO];
        [_scanObj setNeedAutoVideoZoom:YES];
    }
    [_scanObj startScan];
    [_qRScanView stopDeviceReadying];
    [_qRScanView startScanAnimation];
    self.sweepAddDevView.backgroundColor = [UIColor clearColor];
}

- (void)stopScan
{
    [_scanObj stopScan];
}

#pragma mark - 扫码结果处理

- (void)scanResultWithArray:(NSArray<NSString*>*)array
{
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    if (array.count < 1)
    {
        [self showError:@"识别失败了" withReset:YES];
        return;
    }
    if (!array[0] || [array[0] isEqualToString:@""] ) {
        [self showError:@"识别失败了" withReset:YES];
        return;
    }
    NSString *scanResult = array[0];
    NSLog(@"%@",scanResult);
    [self showError:scanResult withReset:YES];
    //TODO: 这里可以根据需要自行添加震动或播放声音提示相关代码
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"scanSuccess.wav" withExtension:nil];
    //2.加载音效文件，创建音效ID（SoundID,一个ID对应一个音效文件）
    SystemSoundID soundID=8787;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    //3.播放音效文件
    //下面的两个函数都可以用来播放音效文件，第一个函数伴随有震动效果
    AudioServicesPlayAlertSound(soundID);
    AudioServicesPlaySystemSound(8787);
}

#pragma mark - 提示语
- (void)showError:(NSString*)str withReset:(BOOL)isRest
{
    if (str==nil || [str isEqualToString:@""]) {
        str =@"扫码失败，请重新扫一扫";
    }else{
        if ([self.fromWhereVC isEqualToString:@"GatewayVC"]) {///网关
            KDSAddGWThreVC *vc = [[KDSAddGWThreVC alloc] init];
            vc.dataStr = str;
            [self.navigationController pushViewController:vc animated:YES];
        }if ([self.fromWhereVC isEqualToString:@"MineVC"]) {///产品激活
            KDSProductActivationVC * vc = [KDSProductActivationVC new];
            vc.productId = str;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        if ([self.fromWhereVC isEqualToString:@"AddDeviceVC"]) {///扫一扫
            if ([str containsString:@"GW"]) {//扫描的网关
                KDSAddGWThreVC *vc = [[KDSAddGWThreVC alloc] init];
                vc.dataStr = str;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([str containsString:@"_WiFi_1"] || [str containsString:@"_WiFi_master"] || [str containsString:@"_WiFi_2"] || [str containsString:@"_WiFi_fast"] ||  [str containsString:@"_WiFi_Fast"]){
                ///wifi配网
                KDSAddNewWiFiLockStep1VC * vc = [KDSAddNewWiFiLockStep1VC new];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([str containsString:@"_WiFi&BLE_"]){
                if ([str containsString:@"SmartHanger"]){///晾衣机：kaadas_M8-E1_WiFi&BLE_SmartHanger
                    //晾衣机：kaadas_M8-E1_WiFi&BLE_Fast
                    
                    NSArray *array = [str componentsSeparatedByString:@"_"]; //从字符_中分隔成2个元素的数组
                    //                    NSLog(@"array:%@",array[1]);
                    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@晾衣机，是否进入配网？",array[1]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 15], NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
                    //                    NSString *message = [NSString stringWithFormat:@"%@晾衣机，是否进入配网？",array[1]];
                    UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:nil message:@"message" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alerVC setValue:message forKey:@"attributedMessage"];
                    
                    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:Localized(@"yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        KDSAddSmartHangerStep1VC * vc = [KDSAddSmartHangerStep1VC new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:Localized(@"no") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //不延时，可能会导致界面黑屏并卡住一会
                        [self performSelector:@selector(startScan) withObject:nil afterDelay:0.1];
                    }];
                    [alerVC addAction:cancleAction];
                    [alerVC addAction:sureAction];
                    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                    [rootViewController presentViewController:alerVC animated:YES completion:nil];
                    
                }else{
                    ///锁
                    KDSAddBleAndWiFiLockStep1 * vc = [KDSAddBleAndWiFiLockStep1 new];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else if ([str containsString:@"kaadas_WiFi_camera"]){
                ///video+wifi
                KDSAddVideoWifiLockStep1VC * vc = [KDSAddVideoWifiLockStep1VC new];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                if ([str hasPrefix:@"http://"] || [str hasPrefix:@"https://"]) {///这里是有个产品经理搞错二维码的代价
                    
                    self.supView = [UIView new];
                    self.supView.backgroundColor = UIColor.whiteColor;
                    self.supView.layer.cornerRadius = 4;
                    self.supView.layer.masksToBounds = YES;
                    [self.sweepAddDevView addSubview:self.supView];
                    [self.supView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@200);
                        make.height.equalTo(@100);
                        make.centerX.centerY.equalTo(self.sweepAddDevView);
                    }];
                    
                    [self.nodataActivity startAnimating];
                    if (self.webView == nil) {
                        self.webView = [[WKWebView alloc] init];
                    }
                    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    self.webView.UIDelegate = self;
                    self.webView.navigationDelegate = self;
                    [self.supView addSubview:self.webView];
                    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@150);
                        make.height.equalTo(@50);
                        make.top.equalTo(self.supView.mas_top).offset(0);
                        make.centerX.equalTo(self.supView);
                    }];
                    UILabel * lb = [UILabel new];
                    lb.text = @"加载中。。。。";
                    lb.textColor = UIColor.blackColor;
                    lb.textAlignment = NSTextAlignmentCenter;
                    lb.font = [UIFont systemFontOfSize:15];
                    [self.supView addSubview:lb];
                    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@20);
                        make.centerX.equalTo(self.supView);
                        make.bottom.equalTo(self.supView.mas_bottom).offset(-5);
                        
                    }];
                    self.timeOut = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(timeOutClick:) userInfo:nil repeats:NO];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                    hud.mode =MBProgressHUDModeText;
                    hud.detailsLabel.text = str;
                    hud.bezelView.backgroundColor = [UIColor blackColor];
                    hud.detailsLabel.textColor = [UIColor whiteColor];
                    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                    });
                }
            }
        }
    }
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //根据标识符获取不同内容
    [webView evaluateJavaScript:@"document.documentElement.innerHTML" completionHandler:^(NSString *result, NSError * _Nullable error) {
        NSLog(@"当前扫描的结果：%@",result);
        if (![result containsString:@"jump_url"]) {
            [self.nodataActivity stopAnimating];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.timeOut invalidate];
                self.timeOut = nil;
                if ([result containsString:@"_WiFi_2"] || [result containsString:@"_WiFi_fast"] || [result containsString:@"_WiFi_1"] || [result containsString:@"_WiFi_master"]){
                    
                    //新的添加Wi-Fi锁流程 目前新旧配网合成一个
                    KDSAddNewWiFiLockStep1VC * vc = [KDSAddNewWiFiLockStep1VC new];
                    [self.navigationController pushViewController:vc animated:YES];
                    [self.webView removeFromSuperview];
                    
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.webView removeFromSuperview];
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                    hud.mode =MBProgressHUDModeText;
                    hud.detailsLabel.text = @"扫描的二维码不符合规定";
                    hud.bezelView.backgroundColor = [UIColor blackColor];
                    hud.detailsLabel.textColor = [UIColor whiteColor];
                    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                    });
                }
            });
        }
        
    }];
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    //根据标识符获取不同内容
    [webView evaluateJavaScript:@"document.documentElement.innerHTML" completionHandler:^(id result, NSError * _Nullable error) {
        NSLog(@"当前扫描的结果：%@",result);
        NSString *attach_title = @"";
        if ([result isKindOfClass:[NSString class]]) {
            attach_title = result;
        }
    }];
    
}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [navigationController setNavigationBarHidden:YES animated:YES];//!iOS 9
}

-(void)popViewControl
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 定时器响应事件
-(void)timeOutClick:(NSTimer *)overTimer
{
    [self.navigationController popViewControllerAnimated:YES];
    [MBProgressHUD showError:@"请检查网络或扫描正确的二维码！"];
}

- (void)viewDidLayoutSubviews
{
    if (CGRectIsEmpty(self.sweepAddDevView.frame))
    {
        self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, self.scrollView.bounds.size.height);
        CGRect frame = self.scrollView.bounds;
        self.sweepAddDevView.frame = frame;
        frame.origin.x += kScreenWidth;
        self.manuallyAddDeView.frame = frame;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidScroll:scrollView];
}

#pragma mark - 控件等事件方法。
///点击门锁消息、系统消息调整滚动视图的偏移，切换页面。
- (void)clickMsgBtnAdjustScrollViewContentOffset:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.cursorView.center = CGPointMake(sender.center.x, self.cursorView.center.y);
        self.scrollView.contentOffset = CGPointMake(sender == self.sweepAddDevBtn ? 0 : kScreenWidth, 0);
        if (sender == self.sweepAddDevBtn) {
            self.sweepAddDevBtn.selected = YES;
            self.manuallyAddDevBtn.selected = NO;
        }else{
            self.sweepAddDevBtn.selected = NO;
            self.manuallyAddDevBtn.selected = YES;
        }
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView)
    {
        self.cursorView.center = CGPointMake(self.sweepAddDevBtn.center.x + (self.manuallyAddDevBtn.center.x - self.sweepAddDevBtn.center.x) * scrollView.contentOffset.x / scrollView.bounds.size.width, self.cursorView.center.y);
        self.sweepAddDevBtn.selected = scrollView.contentOffset.x == 0;
        self.manuallyAddDevBtn.selected = !self.sweepAddDevBtn.selected;
    }
}

#pragma mark --点击事件
-(void)backClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)helpClick:(UIButton *)sender
{
    KDSLog(@"点击了帮助界面");
    // 进行弹窗提示
  
    if (self.sweepAddDevBtn.selected == YES) {
        self.cursorView.center = CGPointMake(self.sweepAddDevBtn.center.x, self.cursorView.center.y);
    }else{
        self.cursorView.center = CGPointMake(self.manuallyAddDevBtn.center.x, self.cursorView.center.y);
    }
    self.alertView.animation = nil;
    self.alertView.addDevicecontainerView.frame = CGRectMake(0, 0, KDSScreenWidth, KDSScreenHeight);
    [self.alertView.addDevicecontainerView addSubview:self.successShowView];
    [self.successShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView.mas_top).offset(KDSScreenWidth <= 375 ? 5: kNavBarHeight+kStatusBarHeight);
    }];
    [self.alertView show];
    
}

- (void)selectPhotoBtnClick{
    KDSLog(@"点击了选择图片添加");
    [self  presentPhotoLibraryWithRooter:self callback:^(NSString * _Nonnull message) {
        KDSLog(@"扫描 二维码中的信息Message");
    }];
}
- (UITableView *)searchTableView {
    if (!_searchTableView) {
        self.searchTableView
        = [[UITableView alloc] init];
        [self.manuallyAddDeView addSubview:_searchTableView];
        [_searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.devTextField.mas_bottom).offset(10);
            make.left.right.bottom.equalTo(self.manuallyAddDeView);
        }];
        _searchTableView.tableFooterView = [UIView new];
    }
    return _searchTableView;
}

- (KDSFormController *)searchFormController {
    if (!_searchFormController) {
        XLFormDescriptor *form = [XLFormDescriptor formDescriptor];
        self.searchFormSection = [XLFormSectionDescriptor formSection];
        [form addFormSection:self.searchFormSection];
        self.searchFormController= [[KDSFormController alloc] initWithForm:form];
        _searchFormController.tableView = self.searchTableView;
        [_searchFormController viewDidLoad];
    }
    return _searchFormController;
}


- (NSMutableArray<XLFormRowDescriptor *> *)searchDataSource {
    if (!_searchDataSource) {
        self.searchDataSource = [[NSMutableArray alloc] init];
    }
    return _searchDataSource;
}

-(void) updateSearchDataSource: (NSArray <PLPProductInfo *>*) dataSource {
    NSUInteger count = self.searchDataSource.count;
    for (NSUInteger i=0; i< count; i++) {
        [self.searchFormSection removeFormRow:self.searchDataSource[i]];
    }
    
    [self.searchDataSource removeAllObjects];
    if (dataSource && dataSource.count) {
        __weak __typeof(self)weakSelf = self;
        for (NSUInteger i=0; i<dataSource.count; i++) {
            PLPProductInfo *product = dataSource[i];
            XLFormRowDescriptor *row = [PLPFormUtils genRowTag:product.idField imageName:@"" title:[product plpDisplayName]  subTitle:nil formBlock:^(XLFormRowDescriptor * _Nonnull sender) {
                [weakSelf presentAddDeviceVC:sender.value];
            } cellStyle:UITableViewCellStyleDefault enableDefaultAccessoryView:NO];
            //row.value = product;
            [self.searchFormSection addFormRow:row];
            [self.searchDataSource addObject:row];
        }
    }
    
    [self.searchTableView reloadData];
}

#pragma mark - 添加设备
-(void) presentAddDeviceVC:(PLPProductInfo *) product {
    
    KDSAddVideoWifiLockStep3VC  *vc  = [KDSAddVideoWifiLockStep3VC new];
    vc.isAgainNetwork = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark   UICollectionView 代理的实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSNumber *category = self.productCategorys[section];
    NSArray *productList = [[PLPProductListManager sharedInstance] searchProductList:[category unsignedIntegerValue]];
    return productList.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  self.productCategorys.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KDSFuntionTabListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:funtionTabListCell forIndexPath:indexPath];
    NSNumber *category = self.productCategorys[indexPath.section];
    NSArray *productList = [[PLPProductListManager sharedInstance] searchProductList:[category unsignedIntegerValue]];
    [cell setupDataModel:productList[indexPath.row]];
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    return cell;
}
// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KDSLog(@"控件的点击事件");
    NSNumber *category = self.productCategorys[indexPath.section];
    NSArray *productList = [[PLPProductListManager sharedInstance] searchProductList:[category unsignedIntegerValue]];
    [self presentAddDeviceVC:productList[indexPath.row]];
}
//  控件懒加载
- (UICollectionView *)collectionView{
    if (_collectionView ==nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = ((kScreenWidth/4)*3 -30*2 -40) / 3;
        CGFloat itemH = 130;
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize=CGSizeMake(((kScreenWidth/4)*3 -30*2 -40), 80);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[KDSFuntionTabListCell class] forCellWithReuseIdentifier:funtionTabListCell];
        [_collectionView registerClass:[UICollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeaderCell"];
        _collectionView.scrollEnabled = YES;
    }
    return _collectionView;
}

#pragma mark - 视图内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    // 视图添加到 UICollectionReusableView 创建的对象中
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *firstHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeaderCell" forIndexPath:indexPath];
        firstHeaderView.backgroundColor = UIColor.clearColor;
        UIView * supview = [UIView new];
        supview.backgroundColor = UIColor.clearColor;
        [firstHeaderView addSubview:supview];
        [supview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.right.equalTo(firstHeaderView);
        }];
        UILabel * timeLb = [UILabel new];
        timeLb.font = [UIFont systemFontOfSize:14];
        timeLb.textColor = KDSRGBColor(51, 51, 51);
        timeLb.textAlignment = NSTextAlignmentCenter;
        [supview addSubview:timeLb];
        [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(firstHeaderView.mas_top).offset(20);
            make.height.equalTo(@25);
            make.width.equalTo(@60);
            make.centerX.mas_equalTo(firstHeaderView.mas_centerX).offset(0);
        }];
        timeLb.text = @"智能锁";
        ///线1
        UIView * line1 = [UIView new];
        line1.backgroundColor = KDSRGBColor(217, 217, 217);
        [firstHeaderView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(firstHeaderView.mas_left).offset(15);
            make.right.mas_equalTo(timeLb.mas_left).offset(-5);
            make.height.equalTo(@1);
            make.centerY.mas_equalTo(timeLb.mas_centerY).offset(0);
        }];
        ///线2
        UIView * line2 = [UIView new];
        line2.backgroundColor = KDSRGBColor(217, 217, 217);
        [firstHeaderView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(timeLb.mas_right).offset(5);
            make.right.mas_equalTo(firstHeaderView.mas_right).offset(-15);
            make.height.equalTo(@1);
            make.centerY.mas_equalTo(timeLb.mas_centerY).offset(0);
        }];
        
        return firstHeaderView;
    }
    return nil;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    KDSLog(@"textFieldDidBeginEditing");
    self.searchFormController.tableView.hidden = NO;
    [self updateSearchDataSource:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    KDSLog(@"textFieldDidEndEditing");

    self.searchFormController.tableView.hidden = YES;
    textField.text = @"";
    self.lastSearchKeyword = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void) textFieldTextDidChange {
    KDSLog(@"textFieldTextDidChange %@",self.devTextField.text);
    NSString *searchText = [self.devTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![searchText isEqualToString:self.lastSearchKeyword
        ]) {
        
        self.lastSearchKeyword = searchText;
        
        if (self.lastSearchKeyword.length) {
            [self updateSearchDataSource:[[PLPProductListManager sharedInstance] searchProductList:PLPProductCategoryAll keyword:searchText]];
        }else {
            [self updateSearchDataSource:nil];
        }
        
    }
    
}

#pragma mark  -  lazy
- (PLPScanAddDeviceHelpView *)successShowView
{
    __weak typeof(self) weakSelf = self;
    if (_successShowView == nil) {
        _successShowView = [[PLPScanAddDeviceHelpView alloc] init];
        _successShowView.cancelBtnClickBlock = ^{//重新输入
            [weakSelf.alertView hide];
            KDSLog(@" xxxx 点击了重新输入密码  重新输入密码");
        };
        _successShowView.settingBtnClickBlock = ^{// 忘记密码
            [weakSelf.alertView hide];
            KDSLog(@" xxxx  点击了忘记密码");
        };
    }
    return _successShowView;
}

- (SYAlertView *)alertView
{
    if (_alertView == nil) {
        _alertView = [[SYAlertView alloc] init];
        _alertView.isAnimation = YES;
        _alertView.userInteractionEnabled = YES;
    }
    return _alertView;
}

@end
