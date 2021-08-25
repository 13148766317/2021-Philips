//
//  PLPLockMsgTwoCell.m
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/10.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPLockMsgTwoCell.h"
#import "PLPWarnMsgCollectionCell.h"
#import "KDSHttpManager+VideoWifiLock.h"
#import "KDSPlaybackCaptureVC.h"
#import <ImageIO/ImageIO.h>

static NSString * const deviceListCellId = @"PLPWarnMsgCollectionCell";

@interface PLPLockMsgTwoCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UIButton * leftBtn;
@property (nonatomic,strong)UIButton * rightBtn;
@property (nonatomic,assign)NSInteger selectedIdx;
@property (nonatomic,strong)NSMutableArray * dataSouceArr;

@end

@implementation PLPLockMsgTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setUpUI];
            
}

- (void)setLock:(KDSLock *)lock
{
    _lock = lock;
    [[KDSHttpManager sharedManager] getXMMediaLockBindedDeviceAlarmRecordWithWifiSN:self.lock.wifiDevice.wifiSN index:1 StartTime:1 EndTime:1 MarkIndex:1 success:^(NSArray<KDSWifiLockAlarmModel *> * _Nonnull models) {
        BOOL contain = NO;
        for (KDSWifiLockAlarmModel * alarm in models)
        {
            if ([self.dataSouceArr containsObject:alarm])
            {
                contain = YES;
                break;
            }
            [self.dataSouceArr insertObject:alarm atIndex:[models indexOfObject:alarm]];
        }
        if (!contain)
        {
            [self.dataSouceArr removeAllObjects];
            [self.dataSouceArr addObjectsFromArray:models];
        }
        [self.warnMsgNotionCell reloadData];
    } error:^(NSError * _Nonnull error) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
- (void)setUpUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userInteractionEnabled = YES;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.warnMsgNotionCell = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.warnMsgNotionCell.dataSource = self;
    self.warnMsgNotionCell.delegate = self;
    self.warnMsgNotionCell.backgroundColor = UIColor.whiteColor;
    ///设置横向滚动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.warnMsgNotionCell.layer.masksToBounds = YES;
    self.warnMsgNotionCell.layer.shadowColor = [UIColor colorWithRed:121/255.0 green:146/255.0 blue:167/255.0 alpha:0.1].CGColor;
    self.warnMsgNotionCell.layer.shadowOffset = CGSizeMake(0,-4);
    self.warnMsgNotionCell.layer.cornerRadius = 3;
    [self addSubview:self.warnMsgNotionCell];
    [self.warnMsgNotionCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.top.mas_equalTo(self.warnMsgTipsLb.mas_bottom).offset(20);
        make.height.equalTo(@110);
    }];
    [self.warnMsgNotionCell flashScrollIndicators];
    // 注册
    [self.warnMsgNotionCell registerNib:[UINib nibWithNibName:NSStringFromClass([PLPWarnMsgCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:deviceListCellId];
    
    [self.warnMsgNotionCell registerNib:[UINib nibWithNibName:NSStringFromClass([PLPWarnMsgCollectionCell class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PLPWarnMsgCollectionCell"];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"philips_icon_more_left_default_02"] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"philips_icon_more_left_selected_02"] forState:UIControlStateSelected];
    self.leftBtn.selected = NO;
    [self.leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.warnMsgTipsLb.mas_bottom).offset(20);
        make.height.equalTo(@110);
        make.width.equalTo(@14);
        make.left.mas_equalTo(self.mas_left).offset(20);
        
    }];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"philips_icon_more_right_default_02"] forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"philips_icon_more_right_selected_02"] forState:UIControlStateSelected];
    self.rightBtn.selected = NO;
    [self.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.warnMsgTipsLb.mas_bottom).offset(20);
        make.height.equalTo(@110);
        make.width.equalTo(@14);
        make.right.mas_equalTo(self.mas_right).offset(-20);
    }];
    self.selectedIdx = 0;
}

//  CollectionView代理 方法的实现
#pragma mark UICollecionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSouceArr.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KDSWifiLockAlarmModel *m = self.dataSouceArr[indexPath.row];
    
    PLPWarnMsgCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:deviceListCellId forIndexPath:indexPath];
    cell.playBtn.hidden = YES;
    cell.backgroundColor = UIColor.clearColor;
    cell.warnMsgTipsImgView.userInteractionEnabled = NO;
    if (m.thumbState == YES && m.fileName.length > 0) {
        cell.playBtn.hidden = NO;
        cell.warnMsgTipsImgView.userInteractionEnabled = YES;
    }
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:m.thumbUrl]];
    UIImage * backImage = [UIImage imageWithData:data ?: UIImagePNGRepresentation([UIImage imageNamed:@"img_default"])];
    //改变该图片的方向
    backImage = [UIImage imageWithCGImage:backImage.CGImage
                                    scale:backImage.scale
                              orientation:UIImageOrientationRight];


    cell.warnMsgTipsImgView.image = backImage;
    cell.warnMsgTipsImgView.contentMode = UIViewContentModeScaleAspectFill;
    cell.plpPlayBtnClickBlock = ^{
        KDSPlaybackCaptureVC * vc = [KDSPlaybackCaptureVC new];
        vc.lock = self.lock;
        vc.model = m;
//        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((kScreenWidth - 72) / 4.0, 110);
    return size;
}

// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

#pragma mark - UIScrollViewDelegate
//预计出大概位置，经过精确定位获得准备位置
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;

}
//计算落在哪个item上
- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = 4 + (kScreenWidth - 72) / 4.0;
    //四舍五入
    NSInteger page = roundf(offset.x / pageSize);
    ///page+4等于item的个数
    if (page + 4 == self.dataSouceArr.count) {
        self.selectedIdx = self.dataSouceArr.count -1;
    }else{
        self.selectedIdx = page;
    }
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}

#pragma mark 点击事件

- (void)leftBtnClick:(UIButton *)sender
{
    UICollectionViewCell * cell = [self.warnMsgNotionCell cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIdx inSection:0]];
    CGRect cellRect = [self.warnMsgNotionCell convertRect:cell.frame toView:self.warnMsgNotionCell];
    UIWindow* window=[[[UIApplication sharedApplication] delegate] window];
    CGRect  rect2 = [self.warnMsgNotionCell convertRect:cellRect toView:window];
    int ccc =  rect2.origin.x/cell.frame.size.width;
    if (self.selectedIdx < self.dataSouceArr.count && self.selectedIdx !=0) {
        if (ccc == 0) {
            self.selectedIdx --;
        }else{
            self.selectedIdx -= ccc+(4-ccc);
        }
        
        [UIView animateWithDuration:0.1 animations:^{
            [self.warnMsgNotionCell scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIdx inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }];
        self.leftBtn.selected = NO;
        self.rightBtn.selected = YES;
    }else{
        [MBProgressHUD showSuccess:@"已到第一个"];
    }
    
}

-(void)rightBtnClick:(UIButton *)sender
{
    UICollectionViewCell * cell = [self.warnMsgNotionCell cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIdx inSection:0]];
    CGRect cellRect = [self.warnMsgNotionCell convertRect:cell.frame toView:self.warnMsgNotionCell];
    UIWindow* window=[[[UIApplication sharedApplication] delegate] window];
    CGRect  rect2 = [self.warnMsgNotionCell convertRect:cellRect toView:window];
    int ccc =  rect2.origin.x/cell.frame.size.width;
    if (self.selectedIdx < self.dataSouceArr.count -1) {
        int tt = 4-ccc;
        self.selectedIdx +=tt;
        [UIView animateWithDuration:0.1 animations:^{
            [self.warnMsgNotionCell scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIdx inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }];
        self.leftBtn.selected = YES;
        self.rightBtn.selected = NO;
    }else{
        [MBProgressHUD showSuccess:@"已到最后一个"];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame{
    //frame.origin.x +=10;
    frame.origin.y += 10;
    frame.size.height -= 10;
    //frame.size.width -= 20;
    [super setFrame:frame];
}

#pragma mark --Lazy load

- (NSMutableArray *)dataSouceArr
{
    if (!_dataSouceArr) {
        _dataSouceArr = [NSMutableArray array];
    }
    return _dataSouceArr;
}

@end
