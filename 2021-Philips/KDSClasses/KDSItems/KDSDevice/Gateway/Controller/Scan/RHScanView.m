
//
//  RHScanView.m
//
//
//  Created by Richinfo on 16/11/16.
//  Copyright © 2016年 Richinfo. All rights reserved.
//

#import "RHScanView.h"
#import <AVFoundation/AVCaptureDevice.h>
#import "SJButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface RHScanView ()
///扫码区域各种参数
@property (nonatomic, strong, nullable) RHScanViewStyle *viewStyle;
///扫码区域
@property (nonatomic, assign) CGRect scanRetangleRect;
///线条扫码动画封装
@property (nonatomic, strong, nullable) RHScanLineAnimation *scanLineAnimation;
///网格扫码动画封装
@property (nonatomic, strong, nullable) RHScanNetAnimation *scanNetAnimation;
///线条在中间位置，不移动
@property (nonatomic, strong, nullable) UIImageView *scanLineStill;
///启动相机时 菊花等待
@property (nonatomic, strong, nullable) UIActivityIndicatorView *activityView;
///启动相机中的提示文字
@property (nonatomic, strong, nullable) UILabel *labelReadying;

@property (nonatomic,strong) UIView *line ;
@property (nonatomic,strong) UIView *line2 ;

@end

NS_ASSUME_NONNULL_END

@implementation RHScanView

- (id)initWithFrame:(CGRect)frame style:(RHScanViewStyle *)style
{
    if (self = [super initWithFrame:frame]) {
        self.viewStyle = style;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawScanRect];
    
}

- (void)startDeviceReadyingWithText:(NSString *)text
{
    int XRetangleLeft = _viewStyle.xScanRetangleOffset;

    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - XRetangleLeft * 2, self.frame.size.width - XRetangleLeft * 2);

    if (!_viewStyle.isNeedShowRetangle) {
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / _viewStyle.whRatio;

        NSInteger hInt = (NSInteger)h;
        h = hInt;

        sizeRetangle = CGSizeMake(w, h);
    }

    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height / 2.0 - _viewStyle.centerUpOffset;

    //设备启动状态提示
    if (!_activityView) {
        self.activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, -80, 30, 30)];

        if (nil == text) {
            [_activityView setCenter:CGPointMake(XRetangleLeft +  sizeRetangle.width / 2, YMinRetangle + sizeRetangle.height / 2)];
        } else {
            [_activityView setCenter:CGPointMake(XRetangleLeft +  sizeRetangle.width / 2 - 50, YMinRetangle + sizeRetangle.height / 2)];
        }

        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:_activityView];

        CGRect labelReadyRect = CGRectMake(_activityView.frame.origin.x + _activityView.frame.size.width + 10, _activityView.frame.origin.y, 100, 30);
        self.labelReadying = [[UILabel alloc]initWithFrame:labelReadyRect];
        _labelReadying.backgroundColor = [UIColor clearColor];
        _labelReadying.textColor = [UIColor whiteColor];
        _labelReadying.font = [UIFont systemFontOfSize:18.];
        _labelReadying.text = text;

        [self addSubview:_labelReadying];

        [_activityView startAnimating];
    }
}

- (void)stopDeviceReadying
{
    if (_activityView) {
        [_activityView stopAnimating];
        [_activityView removeFromSuperview];
        [_labelReadying removeFromSuperview];

        self.activityView = nil;
        self.labelReadying = nil;
    }
}

/**
 *  开始扫描动画
 */
- (void)startScanAnimation
{
    switch (_viewStyle.anmiationStyle) {
        case RichScanViewAnimationStyle_LineMove: {
            //线动画
            if (!_scanLineAnimation) self.scanLineAnimation = [[RHScanLineAnimation alloc]init];
            [_scanLineAnimation startAnimatingWithRect:_scanRetangleRect
                                                InView:self
                                                 Image:_viewStyle.animationImage];
        }
        break;
        case RichScanViewAnimationStyle_NetGrid: {
            //网格动画
            if (!_scanNetAnimation) self.scanNetAnimation = [[RHScanNetAnimation alloc]init];
            [_scanNetAnimation startAnimatingWithRect:_scanRetangleRect
                                               InView:self
                                                Image:_viewStyle.animationImage];
        }
        break;
        case RichScanViewAnimationStyle_LineStill: {
            if (!_scanLineStill) {
                CGRect stillRect = CGRectMake(_scanRetangleRect.origin.x + 20,
                                              _scanRetangleRect.origin.y + _scanRetangleRect.size.height / 2,
                                              _scanRetangleRect.size.width - 40,
                                              2);
                _scanLineStill = [[UIImageView alloc]initWithFrame:stillRect];
                _scanLineStill.image = _viewStyle.animationImage;
            }
            [self addSubview:_scanLineStill];
        }

        default:
            break;
    }
}

/**
 *  结束扫描动画
 */
- (void)stopScanAnimation
{
    if (_scanLineAnimation) {
        [_scanLineAnimation stopAnimating];
    }

    if (_scanNetAnimation) {
        [_scanNetAnimation stopAnimating];
    }

    if (_scanLineStill) {
        [_scanLineStill removeFromSuperview];
    }
}

- (void)drawScanRect
{
    int XRetangleLeft = _viewStyle.xScanRetangleOffset;

    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - XRetangleLeft * 2, self.frame.size.width - XRetangleLeft * 2);

    //if (!_viewStyle.isScanRetangelSquare)
    if (_viewStyle.whRatio != 1) {
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / _viewStyle.whRatio;

        NSInteger hInt = (NSInteger)h;
        h = hInt;

        sizeRetangle = CGSizeMake(w, h);
    }
    CGFloat  reHeight = 46;
    
    /*
    if (KDSScreenHeight > 667) {
        reHeight  =KDSScreenHeight > 667 ? 130 : 130;
    }
    if (KDSScreenHeight>=896) {
        reHeight = 230;
    }
     */
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = reHeight;;
//self.frame.size.height / 2.0 - sizeRetangle.height/2.0 - _viewStyle.centerUpOffset;
    CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
    CGFloat XRetangleRight = self.frame.size.width - XRetangleLeft;

    CGContextRef context = UIGraphicsGetCurrentContext();
    //非扫码区域半透明
    {
        //设置非识别区域颜色

        const CGFloat *sc_components = CGColorGetComponents(_viewStyle.notRecoginitonArea.CGColor);

        CGFloat red_notRecoginitonArea = sc_components[0];
        CGFloat green_notRecoginitonArea = sc_components[1];
        CGFloat blue_notRecoginitonArea = sc_components[2];
        CGFloat alpa_notRecoginitonArea = sc_components[3];

        CGContextSetRGBFillColor(context, red_notRecoginitonArea, green_notRecoginitonArea,
                                 blue_notRecoginitonArea, alpa_notRecoginitonArea);

        //填充矩形
        //扫码区域上面填充
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, YMinRetangle);
        CGContextFillRect(context, rect);

        //扫码区域左边填充
        rect = CGRectMake(0, YMinRetangle, XRetangleLeft, sizeRetangle.height);
        CGContextFillRect(context, rect);

        //扫码区域右边填充
        rect = CGRectMake(XRetangleRight, YMinRetangle, XRetangleLeft, sizeRetangle.height);
        CGContextFillRect(context, rect);

        //扫码区域下面填充
        rect = CGRectMake(0, YMaxRetangle, self.frame.size.width, self.frame.size.height - YMaxRetangle);
        CGContextFillRect(context, rect);
        //执行绘画
        CGContextStrokePath(context);
        
        // 添加一张提示的视图
        UIImageView  * tipsImg = [UIImageView new];
        tipsImg.image = [UIImage imageNamed:@"scan_img_tips"];
        tipsImg.frame = CGRectMake(0, YMaxRetangle, KDSScreenWidth, 76);
        // 提示帮助的点击事件
        UITapGestureRecognizer  * helpimgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHelpTap)];
        [tipsImg addGestureRecognizer:helpimgTap];
        tipsImg.userInteractionEnabled = YES;
        
        [self addSubview:tipsImg];
        [tipsImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(YMaxRetangle+ 20));
            make.left.equalTo(self).offset(22);
            make.height.equalTo(@76);
            make.right.equalTo(self).offset(-22);
        }];
        
        UIButton *flashlightBtn = [UIButton new];
        [flashlightBtn setImage:[UIImage imageNamed:@"philips_home_scan_icon_flashlight"] forState:UIControlStateNormal];
        [flashlightBtn addTarget:self action:@selector(flashlightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:flashlightBtn];
        [flashlightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipsImg.mas_bottom).offset(70+kStatusBarHeight);
            make.width.height.equalTo(@60);
            make.centerX.equalTo(self).offset(-50-50);
        }];
        
        UILabel *tips1Lb = [UILabel new];
        tips1Lb.text = Localized(@"Flashlight");
        tips1Lb.textColor = UIColor.blackColor;
        tips1Lb.font = [UIFont systemFontOfSize:13];
        tips1Lb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tips1Lb];
        [tips1Lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(flashlightBtn.mas_bottom).offset(18);
            make.height.equalTo(@15);
            make.centerX.equalTo(self).offset(-50-50);
        }];
        //添加相册
        UIButton *photoBtn = [UIButton new];
        [photoBtn setImage:[UIImage imageNamed:@"philips_home_scan_icon_album"] forState:UIControlStateNormal];
        [photoBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:photoBtn];
        [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipsImg.mas_bottom).offset(70+kStatusBarHeight);
            make.width.height.equalTo(@60);
            make.centerX.equalTo(self).offset(50+50);
        }];
        UILabel *tipsLb = [UILabel new];
        tipsLb.text = Localized(@"Photo_Album");
        tipsLb.textColor = UIColor.blackColor;
        tipsLb.font = [UIFont systemFontOfSize:13];
        tipsLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tipsLb];
        [tipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(photoBtn.mas_bottom).offset(18);
            make.height.equalTo(@15);
            make.centerX.equalTo(self).offset(50+50);
        }];
    }
    
    if (_viewStyle.isNeedShowRetangle) {
        //中间画矩形(正方形)
        CGContextSetStrokeColorWithColor(context, _viewStyle.colorRetangleLine.CGColor);
        CGContextSetLineWidth(context, 1);

        CGContextAddRect(context, CGRectMake(XRetangleLeft + 0.5, YMinRetangle + 0.5, sizeRetangle.width - 1, sizeRetangle.height - 1));
        //CGContextMoveToPoint(context, XRetangleLeft, YMinRetangle);
        //CGContextAddLineToPoint(context, XRetangleLeft+sizeRetangle.width, YMinRetangle);
        CGContextStrokePath(context);
    }
    _scanRetangleRect = CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height);

    //画矩形框4格外围相框角
    //相框角的宽度和高度
    int wAngle = _viewStyle.photoframeAngleW;
    int hAngle = _viewStyle.photoframeAngleH;

    //4个角的 线的宽度
    CGFloat linewidthAngle = _viewStyle.photoframeLineW;// 经验参数：6和4

    //画扫码矩形以及周边半透明黑色坐标参数
    CGFloat diffAngle = 0.0f;

    switch (_viewStyle.photoframeAngleStyle) {
        case RichScanViewPhotoframeAngleStyle_Outer: {
            diffAngle = linewidthAngle / 3;//框外面4个角，与框紧密联系在一起
        }
        break;
        case RichScanViewPhotoframeAngleStyle_On: {
            diffAngle = -0.5;
        }
        break;
        case RichScanViewPhotoframeAngleStyle_Inner: {
            diffAngle = -_viewStyle.photoframeLineW / 2;
        }
        break;

        default: {
            diffAngle = linewidthAngle / 3;
        }
        break;
    }

    CGContextSetStrokeColorWithColor(context, _viewStyle.colorAngle.CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);

    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, linewidthAngle);
    //
    CGFloat leftX = XRetangleLeft - diffAngle;
    CGFloat topY = YMinRetangle - diffAngle;
    CGFloat rightX = XRetangleRight + diffAngle;
    CGFloat bottomY = YMaxRetangle + diffAngle;

    //左上角水平线
    CGContextMoveToPoint(context, leftX - linewidthAngle / 2, topY);
    CGContextAddLineToPoint(context, leftX + wAngle, topY);

    //左上角垂直线
    CGContextMoveToPoint(context, leftX, topY - linewidthAngle / 2);
    CGContextAddLineToPoint(context, leftX, topY + hAngle);

    //左下角水平线
    CGContextMoveToPoint(context, leftX - linewidthAngle / 2, bottomY);
    CGContextAddLineToPoint(context, leftX + wAngle, bottomY);

    //左下角垂直线
    CGContextMoveToPoint(context, leftX, bottomY + linewidthAngle / 2);
    CGContextAddLineToPoint(context, leftX, bottomY - hAngle);

    //右上角水平线
    CGContextMoveToPoint(context, rightX + linewidthAngle / 2, topY);
    CGContextAddLineToPoint(context, rightX - wAngle, topY);

    //右上角垂直线
    CGContextMoveToPoint(context, rightX, topY - linewidthAngle / 2);
    CGContextAddLineToPoint(context, rightX, topY + hAngle);

    //右下角水平线
    CGContextMoveToPoint(context, rightX + linewidthAngle / 2, bottomY);
    CGContextAddLineToPoint(context, rightX - wAngle, bottomY);

    //右下角垂直线
    CGContextMoveToPoint(context, rightX, bottomY + linewidthAngle / 2);
    CGContextAddLineToPoint(context, rightX, bottomY - hAngle);

    CGContextStrokePath(context);
}

- (CGRect)getScanRetangleRect
{
    return _scanRetangleRect;
}

//根据矩形区域，获取识别区域
+ (CGRect)getScanRectWithPreView:(UIView *)view style:(RHScanViewStyle *)style
{
    int XRetangleLeft = style.xScanRetangleOffset - 10;
    CGSize sizeRetangle = CGSizeMake(view.frame.size.width - XRetangleLeft * 2, view.frame.size.width - XRetangleLeft * 2);

    if (style.whRatio != 1) {
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / style.whRatio;
        NSInteger hInt = (NSInteger)h;
        h = hInt;
        sizeRetangle = CGSizeMake(w, h);
    }

    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = view.frame.size.height / 2.0 - sizeRetangle.height / 2.0 - style.centerUpOffset;
    //扫码区域坐标
    CGRect cropRect =  CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height);

    //计算兴趣区域
    CGRect rectOfInterest;

    //ref:http://www.cocoachina.com/ios/20141225/10763.html
    CGSize size = view.bounds.size;
    CGFloat p1 = size.height / size.width;
    CGFloat p2 = 1920. / 1080.;  //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height) / 2;
        rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding) / fixHeight,
                                    cropRect.origin.x / size.width,
                                    cropRect.size.height / fixHeight,
                                    cropRect.size.width / size.width);
    } else {
        CGFloat fixWidth = size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width) / 2;
        rectOfInterest = CGRectMake(cropRect.origin.y / size.height,
                                    (cropRect.origin.x + fixPadding) / fixWidth,
                                    cropRect.size.height / size.height,
                                    cropRect.size.width / fixWidth);
    }
    return rectOfInterest;
}
//根据矩形区域，获取识别区域
+ (CGRect)getZXingScanRectWithPreView:(UIView *)view style:(RHScanViewStyle *)style
{
    int XRetangleLeft = style.xScanRetangleOffset;
    CGSize sizeRetangle = CGSizeMake(view.frame.size.width - XRetangleLeft * 2, view.frame.size.width - XRetangleLeft * 2);

    if (style.whRatio != 1) {
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / style.whRatio;

        NSInteger hInt = (NSInteger)h;
        h = hInt;

        sizeRetangle = CGSizeMake(w, h);
    }
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = view.frame.size.height / 2.0 - sizeRetangle.height / 2.0 - style.centerUpOffset;

    XRetangleLeft = XRetangleLeft / view.frame.size.width * 1080;
    YMinRetangle = YMinRetangle / view.frame.size.height * 1920;
    CGFloat width = sizeRetangle.width / view.frame.size.width * 1080;
    CGFloat height = sizeRetangle.height / view.frame.size.height * 1920;

    //扫码区域坐标
    CGRect cropRect =  CGRectMake(XRetangleLeft, YMinRetangle, width, height);
    return cropRect;
}

#pragma mark - 开启手电筒的手势
- (void)flashlightBtnClick:(UIButton *)sender
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash]) {
        [device lockForConfiguration:nil];
        if (!sender.selected) {
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureFlashModeOn];
            sender.selected = YES;
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOff];
            sender.selected = NO;
        }

        [device unlockForConfiguration];
    }
}
// 事件传递
- (void)backBtnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(popViewControl)]) {
        [self.delegate popViewControl];
    }
}
- (void)selectedBtn :(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.tag ==100) {
        self.line.backgroundColor = KDSRGBColor(0, 102, 161);
        self.line2.backgroundColor = [UIColor whiteColor];
    }else{ // 选中手动添加
     
        if ([self.delegate respondsToSelector:@selector(manualAddBtnAction)]) {
            [self.delegate manualAddBtnAction];
        }
    }
    
    NSLog(@"按钮的点击事件line1");
}
//手动添加点击事件
- (void)manualAddBtnAction{
   
    if ([self.delegate respondsToSelector:@selector(manualAddBtnAction)]) {
        [self.delegate manualAddBtnAction];
    }
}
//自动添加点击事件
-(void)scanAddBtnAction{
    
    if ([self.delegate respondsToSelector:@selector(scanAddBtnAction)]) {
        [self.delegate scanAddBtnAction];
    }
}
#pragma mark  - 扫描相册中的二维码
// 点击选择相册照片
-(void)photoBtnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(selectPhotoBtnClick)]) {
        [self.delegate selectPhotoBtnClick];
    }
    
}

// 点击了帮助提示
- (void)clickHelpTap{
    if ([self.delegate respondsToSelector:@selector(clickHelpTap)]) {
        [self.delegate clickHelpTap];
    }
}
//点击了帮助的界面
- (void)helpBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(helpBtnClick)]) {
        [self.delegate helpBtnClick];
    }
    
}
@end
