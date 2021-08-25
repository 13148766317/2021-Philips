//
//  KDSMyAlbumVC.m
//  2021-Philips
//
//  Created by zhaoxueping on 2020/9/16.
//  Copyright © 2020 com.Kaadas. All rights reserved.
//

#import "KDSMyAlbumVC.h"
#import "KDSMyAlbumListCell.h"
#import "XMUtil.h"
#import "KDSDBManager+XMMediaLock.h"
#import "KDSXMMediaLockModel.h"
#import "XMUtil.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "KDSMyAlbumDetailsVC.h"
#import "PLPEmptyDataHub.h"

static NSString * const deviceListCellId = @"MyAlbumCell";

@interface KDSMyAlbumVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//用来展示相册内容的视图
@property (nonatomic,readwrite,strong)UICollectionView * collectionView;

//从数据库中取出的缓存的截图、录屏的数据。
@property (nonatomic, strong) NSMutableArray<KDSXMMediaLockModel *> *mediaRecordArr;

//缓存的截图、录屏的数据按日期(天)提取的记录分组数组。
@property (nonatomic, strong) NSMutableArray<NSArray<KDSXMMediaLockModel *> *> *mediaRecordSectionArr;

///A date formatter with format yyyy-MM-dd HH:mm:ss
@property (nonatomic, strong) NSDateFormatter *dateFmt;

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *rightBtn;

//是否有录屏
@property (nonatomic, assign) BOOL isHaveVideo;

//标记是否正在删除图片或者视频状态
@property (nonatomic, assign) BOOL isSelecting;

//上个导航控制器的代理。
@property (nonatomic, weak) id<UINavigationControllerDelegate> preDelegate;

//在数据空的情况下提示框
@property (nonatomic, strong) PLPEmptyDataHub *emptyDataHub;

//删除选中数组
@property (nonatomic, strong) NSMutableArray *selectPhoneArr;

@end

@implementation KDSMyAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化主视图
    [self setupMainView];
    
    //从手机相册获取拍摄的照片和录制的视频
    [self getOriginalImages];
    
    //媒体库数据删除成功通知
    [KDSNotificationCenter addObserver:self selector:@selector(updataMediaData:) name:@"updataMediaData" object:nil];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.preDelegate = self.navigationController.delegate;
    self.navigationController.delegate = self;
    
    //数据为空时，显示空数据提示
    if (self.mediaRecordArr.count <=0) {
        [self showEmptyDataHub];
    }else{
        [self dismissEmptyDataHub];
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.delegate = self.preDelegate;
}

#pragma mark - 初始化主视图
-(void) setupMainView{
    
    UIView * navView = [UIView new];
    navView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.height.equalTo(@(kNavBarHeight+kStatusBarHeight));
    }];
    
    //返回Button
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    self.leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(navView.mas_left).offset(10);
        make.top.mas_equalTo(navView.mas_top).offset(kStatusBarHeight);
        make.size.mas_offset(CGSizeMake(44, 44));
    }];
    
    //右Button  删除按钮
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setImage:[UIImage imageNamed:@"philips_album_icon_delete"] forState:UIControlStateNormal];
    self.rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(navView).offset(-15);
        make.top.mas_equalTo(navView.mas_top).offset(kStatusBarHeight);
        make.size.mas_offset(CGSizeMake(44, 44));
    }];
    
    //标题
    UILabel * titleLb = [UILabel new];
    titleLb.text = Localized(@"MediaLibrary_Album");
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    titleLb.textColor = UIColor.blackColor;
    [navView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(navView.mas_left).offset(0);
        make.right.mas_equalTo(navView.mas_right).offset(0);
        make.top.mas_equalTo(navView.mas_top).offset(10+kStatusBarHeight);
        make.bottom.mas_equalTo(navView.mas_bottom).offset(-10);
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
    
    //初始化collectionView
    [self.view addSubview:self.collectionView];
    
    self.isHaveVideo = NO;
    self.isSelecting = NO;
    
    // 注册Cell
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([KDSMyAlbumListCell class]) bundle:nil] forCellWithReuseIdentifier:deviceListCellId];
    
    //注册头部视图
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([KDSMyAlbumListCell class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"myAlbumCollectionViewHeader"];
    
    ////添加猫眼、网关父视图
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(navView.mas_left).offset(0);
        make.right.mas_equalTo(navView.mas_right).offset(0);
        make.top.mas_equalTo(navView.mas_bottom).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
}

#pragma mark - 左Button点击事件
-(void)backBtnAction:(UIButton *)sender{
    
    if (self.isSelecting) {
        
        //将选中状态置为--正常模式
        self.isSelecting = NO;
        
        //将选中状态置为No
        [self allMediaDataSettingNoSelect];
        
        //将选中的元素置空
        if (self.selectPhoneArr) {
            [self.selectPhoneArr removeAllObjects];
        }
        
        //刷新视图
        [self.collectionView reloadData];
        
        //修改左上角按钮的显示状态
        [self.leftBtn setTitle:@"" forState:UIControlStateNormal];
        [self.leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 右上角删除按钮点击事件
-(void) rightBtnAction:(UIButton *)sender{
    
    //删除反选
    self.isSelecting = !self.isSelecting;
    
    //检查是否有将要删除选中的照片
    if (self.selectPhoneArr.count > 0) {
        for (NSInteger i=0; i< self.selectPhoneArr.count; i++) {
            KDSXMMediaLockModel *model = self.selectPhoneArr[i];
            [self removeSelectImage:model];
        }
    }
    
    //选中状态下
    if (self.isSelecting) {
        //更新左Button显示状态
        [self.leftBtn setTitle:Localized(@"MediaLibrary_Cancel") forState:UIControlStateNormal];
        [self.leftBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else{
        if (self.selectPhoneArr.count <=0) {
            [self.leftBtn setTitle:@"" forState:UIControlStateNormal];
            [self.leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        }
    }
    
    [self.collectionView reloadData];
}

#pragma mark - 更新数据源 -- 未选中状态
-(void) allMediaDataSettingNoSelect{
    
    for (NSInteger i=0; i< self.mediaRecordSectionArr.count; i++) {
        NSArray *sectionArr = self.mediaRecordSectionArr[i];
        for (NSInteger j=0; j< sectionArr.count; j++) {
            KDSXMMediaLockModel *model = sectionArr[j];
            model.isSelect = NO;
        }
    }
    
    [self.collectionView reloadData];
}

#pragma mark UICollecionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.mediaRecordSectionArr[section].count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.mediaRecordSectionArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KDSMyAlbumListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:deviceListCellId forIndexPath:indexPath];
    cell.playBtn.hidden = YES;
    cell.iconImg.contentMode = UIViewContentModeScaleAspectFill;
    KDSXMMediaLockModel * model = self.mediaRecordSectionArr[indexPath.section][indexPath.row];
    
    if (self.isSelecting) {
        
        //将标记图标显示出来
        cell.selectImageView.hidden = NO;
        
        //根据选中状态显示
        if (model.isSelect) {
            cell.selectImageView.image = [UIImage imageNamed:@"philips_album_icon_selected"];
        }else{
            cell.selectImageView.image = [UIImage imageNamed:@"philips_album_icon_default"];
        }
    }else{
        cell.selectImageView.hidden = YES;
    }
    
    if (model.mp4Address.length >0) {
        cell.iconImg.image = [self getScreenShotImageFromVideoPath:model.mp4Address];
        cell.playBtn.hidden = NO;
        cell.maskView.hidden = NO;
        __weak typeof(self)wekSelf = self;
        cell.playBtnClickBlock = ^{
            if (!wekSelf.isSelecting) {
                KDSXMMediaLockModel * model = self.mediaRecordSectionArr[indexPath.section][indexPath.row];
                KDSMyAlbumDetailsVC * vc = [KDSMyAlbumDetailsVC new];
                vc.model = model;
                [wekSelf.navigationController pushViewController:vc animated:YES];
            }
        };
    }else{
        NSData * imageData = [NSData dataWithData:model.lockCutData];
        cell.iconImg.image = [UIImage imageWithData:imageData];
        cell.playBtn.hidden = YES;
        cell.maskView.hidden = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KDSXMMediaLockModel * model = self.mediaRecordSectionArr[indexPath.section][indexPath.row];
    if (self.isSelecting) {
        model.isSelect = !model.isSelect;
       
        if (model.isSelect) {
            [self.selectPhoneArr addObject:model];
        }else{
            for (NSInteger i=0; i< self.selectPhoneArr.count; i++) {
                KDSXMMediaLockModel * selectModel = self.selectPhoneArr[i];

                //找到相同的删除
                if ([model.imageName isEqualToString:selectModel.imageName]) {
                    [self.selectPhoneArr removeObjectAtIndex:i];
                }
            }
        }
        
        [self.collectionView reloadData];
    }else{
        KDSMyAlbumDetailsVC * vc = [KDSMyAlbumDetailsVC new];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 视图 头部 内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    // 视图添加到 UICollectionReusableView 创建的对象中
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"myAlbumCollectionViewHeader" forIndexPath:indexPath];
        headerView.backgroundColor = UIColor.clearColor;
        UIView * supview = [UIView new];
        supview.backgroundColor = UIColor.whiteColor;
        [headerView addSubview:supview];
        [supview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.right.equalTo(headerView);
        }];
        
        UILabel * timeLb = [UILabel new];
        //timeLb.text = @"2020/08/23";
        timeLb.font = [UIFont systemFontOfSize:15];
        timeLb.textColor = UIColor.blackColor;
        timeLb.textAlignment = NSTextAlignmentLeft;
        timeLb.backgroundColor = UIColor.whiteColor;
        [supview addSubview:timeLb];
        [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(15);
            make.right.equalTo(headerView.mas_right).offset(-15);
            make.bottom.equalTo(headerView.mas_bottom).offset(0);
            make.height.equalTo(@30);
        }];
        
        NSString *todayStr = [[self.dateFmt stringFromDate:[NSDate date]] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSInteger today = [todayStr substringToIndex:8].integerValue;
        NSString *dateStr = dateStr = self.mediaRecordSectionArr[indexPath.section].firstObject.imageName;
        NSInteger date = [[dateStr stringByReplacingOccurrencesOfString:@"-" withString:@""] substringToIndex:8].integerValue;
        if (today == date)
        {
            timeLb.text = Localized(@"MessageRecord_Date_Today");
        }
        else if (today - date == 1)
        {
            timeLb.text = Localized(@"MessageRecord_Date_YesTerday");
        }
        else
        {
            timeLb.text = [[dateStr componentsSeparatedByString:@" "].firstObject stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        }
        return headerView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((kScreenWidth - 10) / 3.0, (kScreenWidth - 10) / 3.0);
    
    return size;
}

// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

#pragma mark - 获取相应的图片和视频资源
- (void)getOriginalImages
{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:YES];
    }
    

    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    
    // 遍历相机胶卷,获取大图
    [self enumerateAssetsInAssetCollection:cameraRoll original:YES];
}

/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original{
    
    //NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    // 获得某个相簿中的所有PHAsset对象
    NSString *title =[NSString stringWithFormat:@"KDS:%@",self.lock.wifiDevice.wifiSN];
    if ([assetCollection.localizedTitle isEqualToString:title]) {
        //遍历获取相册
        //获取当前相册里所有的PHAsset，也就是图片或者视频
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        for (NSInteger j = 0; j < fetchResult.count; j++) {
            //从相册中取出照片
            PHAsset* asset = fetchResult[j];
            if (asset.mediaType == PHAssetMediaTypeImage) {
               //得到一个图片类型资源
                //NSLog(@"当前图片PHAsset的值%ld",(long)j);
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                // 同步获得图片, 只会返回1张图片
                options.synchronous = YES;
                // 是否要原图
                CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;

                // 从asset中获得图片
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    
                    //NSLog(@"凯迪仕智能相册里面的图片%@", result);
                    KDSXMMediaLockModel * mode = [KDSXMMediaLockModel new];
                    UIImage * image = result;
                    NSString * imageCreationDate = [NSString stringWithFormat:@"%@",[self getNowDateFromatAnDate:asset.creationDate]];
                    mode.lockCutData = UIImagePNGRepresentation(image);
                    mode.imageName = [imageCreationDate stringByReplacingOccurrencesOfString:@".png" withString:@""];
                    mode.isSelect = NO;
                    mode.phAsset = asset;
                    mode.filePath = [[NSString alloc] initWithFormat:@"%@/%@.png", [XMUtil cachesPathWithWifiSN:self.lock.wifiDevice.wifiSN], [KDSTool getLocalDateFormateUTCDate:asset.creationDate]];
                    if (mode.lockCutData) [self.mediaRecordArr addObject:mode];
                    if (self.mediaRecordArr.count == fetchResult.count) {
                        [self refreshData];
                    }
                    
                }];
            }else if (asset.mediaType == PHAssetMediaTypeVideo) {
                //得到一个视频类型资源
                //NSLog(@"当前视频PHAsset的值%ld",(long)j);
                KDSXMMediaLockModel * mode = [KDSXMMediaLockModel new];
                NSString * imageCreationDate = [NSString stringWithFormat:@"%@",[self getNowDateFromatAnDate:asset.creationDate]];
                mode.imageName = [imageCreationDate stringByReplacingOccurrencesOfString:@".mp4" withString:@""];
                mode.isSelect = NO;
                mode.phAsset = asset;
                mode.filePath =  [[NSString alloc] initWithFormat:@"%@/%@.mp4", [XMUtil cachesPathWithWifiSN:self.lock.wifiDevice.wifiSN],  [KDSTool getLocalDateFormateUTCDate:asset.creationDate]];
                PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                options.version = PHImageRequestOptionsVersionCurrent;
                options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
                [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    AVURLAsset *urlAsset = (AVURLAsset *)asset;
                    NSURL *url = urlAsset.URL;
                    //NSData *data = [NSData dataWithContentsOfURL:url];
                    //NSLog(@"%@",data);
                    mode.mp4Address = [NSString stringWithFormat:@"%@",url];
                    if (mode.mp4Address) [self.mediaRecordArr addObject:mode];
                    if (self.mediaRecordArr.count == fetchResult.count) {
                        self.isHaveVideo = YES;
                        [self refreshData];
                    }
                }];
            }else if (asset.mediaType == PHAssetMediaTypeAudio) {
                  //音频，PHAsset的mediaType属性有三个枚举值，笔者对PHAssetMediaTypeAudio暂时没有进行处理
           }
        }
    }
}

#pragma mark - 刷新数据
- (void)refreshData{
    
    NSMutableArray *sections = [NSMutableArray array];
    NSMutableArray<KDSXMMediaLockModel *> *section = [NSMutableArray array];
    
    __block NSString *date = nil;
    [self.mediaRecordArr sortUsingComparator:^NSComparisonResult(KDSXMMediaLockModel *  _Nonnull obj1, KDSXMMediaLockModel *  _Nonnull obj2) {
        
        return [obj2.imageName compare:obj1.imageName];
    }];
    
    [self.mediaRecordArr enumerateObjectsUsingBlock:^(KDSXMMediaLockModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!date){
            if (obj.imageName) {
                date = [obj.imageName componentsSeparatedByString:@" "].firstObject;
                [section addObject:obj];
            }else{
                [self.mediaRecordArr removeObject:obj];
            }
        }else if ([date isEqualToString:[obj.imageName componentsSeparatedByString:@" "].firstObject]){

            [section addObject:obj];
        }else
        {
            if (section.count >0) {
                [sections addObject:[NSArray arrayWithArray:section]];
            }
            [section removeAllObjects];
            if (obj.imageName) {
                date = [obj.imageName componentsSeparatedByString:@" "].firstObject;
                [section addObject:obj];
            }else{
                [self.mediaRecordArr removeObject:obj];
            }
        }
    }];
    if (section.count >0) {
        [sections addObject:[NSArray arrayWithArray:section]];
    }
    self.mediaRecordSectionArr = sections;
    if (self.isHaveVideo) {
        ///有视频录屏的时候需要异步刷新UI，只有图片的时候不用
        dispatch_async(dispatch_get_main_queue(), ^{//dispatch_sync
            if (self.mediaRecordSectionArr.count > 0) {
                [self dismissEmptyDataHub];
            }else{
                [self showEmptyDataHub];
            }
            [self.collectionView reloadData];
        });
    }else{
        if (self.mediaRecordSectionArr.count > 0) {
            [self dismissEmptyDataHub];
        }else{
            [self showEmptyDataHub];
        }
        [self.collectionView reloadData];
    }
}

#pragma mark - 删除选中的图片
-(void) removeSelectImage:(KDSXMMediaLockModel *)model{
    
    __weak typeof(self) weakSelf = self;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest deleteAssets:@[model.phAsset]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        //删除相册的照片和视频
        if (strongSelf.selectPhoneArr.count > 0) {

            //删除在选中数组已操作的数据，允许删除+不允许删除
            [strongSelf.selectPhoneArr removeObjectAtIndex:0];
            
            if (strongSelf.selectPhoneArr.count <=0) {
                //将选中状态置为--正常模式
                strongSelf.isSelecting = NO;
                
                //清除数据源
                [strongSelf.mediaRecordArr removeAllObjects];
                [strongSelf.mediaRecordSectionArr removeAllObjects];
                
                //重新获取数据
                [strongSelf getOriginalImages];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //当数据为空是，显示无数据提示
                    if (strongSelf.mediaRecordArr.count <= 0) {
                        [strongSelf showEmptyDataHub];
                    }
                    
                    //刷新视图
                    [strongSelf.collectionView reloadData];
                    
                    //更新左Button显示状态
                    [strongSelf.leftBtn setTitle:@"" forState:UIControlStateNormal];
                    [strongSelf.leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
                });
            }
        }
        
        //删除本地沙河的图片和视频
        if (success) {
            [KDSTool removeFile:model.filePath];
        }
    }];
}

#pragma mark - 获取当前的时间
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    //转为现在时间
    NSDate * destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];

    return destinationDateNow;
}

#pragma mark - 在数据为空时提示视图加载
-(void) showEmptyDataHub{
    
    [self.emptyDataHub removeFromSuperview];
    
    self.emptyDataHub = [[PLPEmptyDataHub alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavBarHeight-kStatusBarHeight) HeadImage:[UIImage imageNamed:@"PLPEmptyData_Media_Normal"] Title:@"暂无照片"];
    [self.collectionView addSubview:self.emptyDataHub];
}

-(void)dismissEmptyDataHub
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
       
    } completion:^(BOOL finished) {
        [weakSelf.emptyDataHub removeFromSuperview];
    }];
}

/**
 *  获取视频的缩略图方法
 *  @param filePath 视频的本地路径
 *  @return 视频截图
 */
- (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath{
    
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    shotImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return shotImage;
}

#pragma mark - 通知中心--更新数据
-(void) updataMediaData:(NSNotification *)sender{
    
    if (self.mediaRecordArr) {
        [self.mediaRecordArr removeAllObjects];
    }
    
    if (self.mediaRecordSectionArr) {
        [self.mediaRecordSectionArr removeAllObjects];
    }
    
    //从手机相册获取拍摄的照片和录制的视频
    [self getOriginalImages];
    
    //刷新视图
    [self.collectionView reloadData];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [navigationController setNavigationBarHidden:YES animated:YES];
}


#pragma mark --Lazy Load

- (NSMutableArray<KDSXMMediaLockModel *> *)mediaRecordArr{
    if (!_mediaRecordArr) {
        _mediaRecordArr = [NSMutableArray array];
    }
    return _mediaRecordArr;
}

-(NSMutableArray *)mediaRecordSectionArr{
    if (!_mediaRecordSectionArr) {
        _mediaRecordSectionArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _mediaRecordSectionArr;
}

-(NSMutableArray *) selectPhoneArr{
    if (!_selectPhoneArr) {
        _selectPhoneArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _selectPhoneArr;
}

- (NSDateFormatter *)dateFmt{
    if (!_dateFmt)
    {
        _dateFmt = [[NSDateFormatter alloc] init];
        _dateFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFmt;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.layer.masksToBounds = YES;
        _collectionView.layer.shadowColor = [UIColor colorWithRed:121/255.0 green:146/255.0 blue:167/255.0 alpha:0.1].CGColor;
        _collectionView.layer.shadowOffset = CGSizeMake(0,-4);
        _collectionView.layer.shadowOpacity = 1;
        _collectionView.layer.shadowRadius = 12;
        _collectionView.layer.cornerRadius = 5;
         layout.headerReferenceSize = CGSizeMake(KDSScreenWidth, 40);
        [_collectionView flashScrollIndicators];
    }
    return _collectionView;
}

@end
