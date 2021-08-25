//
//  KDSMyAlbumDetailsVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2020/10/9.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSMyAlbumDetailsVC.h"
#import <Photos/Photos.h>
#import <AVKit/AVKit.h>
#import "PLPProgressHub.h"

@interface KDSMyAlbumDetailsVC ()<UINavigationControllerDelegate,PLPProgressHubDelegate>

@property (nonatomic, strong)AVPlayerViewController *playerVC;

///上个导航控制器的代理。
@property (nonatomic, weak) id<UINavigationControllerDelegate> preDelegate;

//蒙板
@property (nonatomic, strong) UIView *maskView;

//提示框
@property (nonatomic, strong) PLPProgressHub *progressHub;

@end

@implementation KDSMyAlbumDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化指主视图
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.preDelegate = self.navigationController.delegate;
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.delegate = self.preDelegate;
}

#pragma mark - 初始化主视图
- (void)setUI{
    
    self.view.backgroundColor = UIColor.blackColor;
    
    UIView * navView = [UIView new];
    navView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(kNavBarHeight+kStatusBarHeight+10));
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    backBtn.frame = CGRectMake(0, kStatusBarHeight, 44, 44);
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];//加粗
    titleLabel.textColor = UIColor.blackColor;
    titleLabel.text = Localized(@"MediaLibrary_Album");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navView).offset(kStatusBarHeight + 15);//原来11
        make.centerX.equalTo(navView);
        make.left.mas_equalTo(navView.mas_left).offset(30);
        make.right.mas_equalTo(navView.mas_right).offset(-30);
        make.height.equalTo(@25);
    }];
    
    //右Button  删除按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"philips_album_icon_delete"] forState:UIControlStateNormal];
    rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(navView).offset(-15);
        make.top.mas_equalTo(navView.mas_top).offset(kStatusBarHeight);
        make.size.mas_offset(CGSizeMake(44, 44));
    }];
    
    //分割线
    UIView *lineView = [UIView new];
    lineView.backgroundColor = KDSRGBColor(191, 190, 193);
    [navView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(navView.mas_left).offset(0);
        make.right.mas_equalTo(navView.mas_right).offset(0);
        make.bottom.mas_equalTo(navView).offset(-0.4);
        make.height.equalTo(@(0.4));
    }];
    
    //UILabel * lb = [UILabel new];
    //lb.textColor = UIColor.blackColor;
    //NSArray *array = [self.model.imageName componentsSeparatedByString:@"+"];
    //lb.text = array[0];
    //lb.font = [UIFont systemFontOfSize:12];
    //lb.textAlignment = NSTextAlignmentCenter;
    //[navView addSubview:lb];
    //[lb mas_makeConstraints:^(MASConstraintMaker *make) {
    //    make.bottom.left.right.equalTo(navView);
    //    make.height.equalTo(@18);
    //}];
    
    if (self.model.mp4Address.length >0) {
        ///使用系统的播放器
        self.playerVC = [[AVPlayerViewController alloc] init];
        self.playerVC.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:self.model.mp4Address]];
        self.playerVC.showsPlaybackControls = YES;
        self.playerVC.view.backgroundColor = self.view.backgroundColor;
        self.playerVC.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.view addSubview:self.playerVC.view];
        [self.playerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(navView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(@(-kBottomSafeHeight));
        }];
        if (self.playerVC.readyForDisplay) {
            [self.playerVC.player play];
        }
    }else{
        UIImageView * imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSData * imageData = [NSData dataWithData:self.model.lockCutData];
        imageView.image = [UIImage imageWithData:imageData];
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(navView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
}

#pragma mark --左Button点击事件
- (void)backBtnAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 右Button点击事件
-(void) rightBtnAction:(UIButton *)sender{
    
    //删除数据
    [self removeSelectImage:self.model.phAsset];
    //[self showContactView];
}
    
#pragma mark - 删除选中的图片
-(void) removeSelectImage:(PHAsset *)asset{
    
    __weak typeof(self) weakSelf = self;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest deleteAssets:@[asset]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (success) {//确定删除
            
            //删除沙河存储的图标或者视频
            [KDSTool removeFile:self.model.filePath];
            
            //刷新视图
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //刷新界面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updataMediaData" object:nil];
                
                //返回上级视图
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

#pragma mark -PLPProgressHubDelegate(弹窗)
-(void) informationBtnClick:(NSInteger)index{
    
    switch (index) {
        case 10://取消
        {
            [self dismissContactView];
            
            break;
        }
        case 11://删除
        {
            //删除数据
            [self removeSelectImage:self.model.phAsset];
            
            //收回视图
            [self dismissContactView];
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - PLPProgressHub显示视图
-(void)showContactView{
    
    [_maskView removeFromSuperview];
    [_progressHub removeFromSuperview];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _maskView.alpha = 0.5;
    _maskView.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    
    NSString *titleStr = nil;
    if (self.model.mp4Address.length >0){
        titleStr = @"确定删除视频吗?";
    }else{
        titleStr = @"确定删除图片吗?";
    }
    _progressHub = [[PLPProgressHub alloc] initWithFrame:CGRectMake(50, kScreenHeight/2 - 150/2, kScreenWidth-100, 150) Title:titleStr];
    _progressHub.backgroundColor = [UIColor whiteColor];
    _progressHub.progressHubDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_progressHub];
}

#pragma mark - PLPProgressHub删除视图
-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.maskView removeFromSuperview];
        [weakSelf.progressHub removeFromSuperview];
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [navigationController setNavigationBarHidden:YES animated:YES];
}


@end
