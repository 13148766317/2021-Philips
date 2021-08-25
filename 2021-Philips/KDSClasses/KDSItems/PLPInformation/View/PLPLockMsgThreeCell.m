//
//  PLPLockMsgThreeCell.m
//  2021-Philips
//
//  Created by zhaoxueping on 2021/5/10.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPLockMsgThreeCell.h"
#import "PLPDoorLockStatusCell.h"
#import "KDSHttpManager+WifiLock.h"
#import "PLPDoorLockStatisticsModel.h"
#import "PLPMSGTypeModel.h"

static NSString * const deviceListCellId = @"PLPDoorLockStatusCell";
@interface PLPLockMsgThreeCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UIButton * leftBtn;
@property (nonatomic,strong)UIButton * rightBtn;
@property (nonatomic,assign)NSInteger selectedIdx;
@property (nonatomic,strong)PLPDoorLockStatisticsModel * doorLockStatisticsModel;
@property (nonatomic,strong)NSMutableArray <PLPMSGTypeModel *>* dataSourceArr;

@end

@implementation PLPLockMsgThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userInteractionEnabled = YES;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.lockMsgTypeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.lockMsgTypeCollectionView.dataSource = self;
    self.lockMsgTypeCollectionView.delegate = self;
    self.lockMsgTypeCollectionView.backgroundColor = UIColor.whiteColor;
    ///设置横向滚动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.lockMsgTypeCollectionView.layer.masksToBounds = YES;
    self.lockMsgTypeCollectionView.layer.shadowColor = [UIColor colorWithRed:121/255.0 green:146/255.0 blue:167/255.0 alpha:0.1].CGColor;
    self.lockMsgTypeCollectionView.layer.shadowOffset = CGSizeMake(0,-4);
    self.lockMsgTypeCollectionView.layer.cornerRadius = 3;
    [self addSubview:self.lockMsgTypeCollectionView];
    [self.lockMsgTypeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.top.mas_equalTo(self.tipsImgView.mas_bottom).offset(30);
        make.height.equalTo(@((kScreenWidth - 72) / 4.0));
    }];
    [self.lockMsgTypeCollectionView flashScrollIndicators];
    // 注册
    [self.lockMsgTypeCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PLPDoorLockStatusCell class]) bundle:nil] forCellWithReuseIdentifier:deviceListCellId];
    
    [self.lockMsgTypeCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PLPDoorLockStatusCell class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PLPDoorLockStatusCell"];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"philips_icon_more_left_default_02"] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"philips_icon_more_left_selected_02"] forState:UIControlStateSelected];
    self.leftBtn.selected = NO;
    [self.leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsImgView.mas_bottom).offset(30);
        make.height.equalTo(@((kScreenWidth - 72) / 4.0));
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
        make.top.mas_equalTo(self.tipsImgView.mas_bottom).offset(30);
        make.height.equalTo(@((kScreenWidth - 72) / 4.0));
        make.width.equalTo(@14);
        make.right.mas_equalTo(self.mas_right).offset(-20);
    }];
    
    self.selectedIdx = 0;
}

- (void)setLock:(KDSLock *)lock
{
    ///根据功能集合展示：密码开门记录统计、指纹开门记录统计、卡片开门记录统计、人脸开门记录统计、访客记录统计
    NSArray * tempArr = @[@20,@23,@89,@10,@99];
    for (int i = 1; i < 6; i ++) {
        PLPMSGTypeModel * model = [PLPMSGTypeModel new];
        model.msgType = i;
        NSString * lockCount = tempArr[i -1];
        model.msgLockCount = lockCount.intValue;
        [self.dataSourceArr addObject:model];
    }
    ///当前默认显示5种
    KDSLock * currentLock = lock;
    if (currentLock.wifiDevice) {
        [self setDataWithCurrentLock:currentLock];
    }
    
}

- (void)setDataWithCurrentLock:(KDSLock *)lock
{
    
    [[KDSHttpManager sharedManager] getwifiLockStatisticsDayWithUid:[KDSUserManager sharedManager].user.uid wifiSN:lock.wifiDevice.wifiSN success:^(PLPDoorLockStatisticsModel * _Nonnull model) {
        self.doorLockStatisticsModel = model;
        self.lockMsgCountLb.text = [NSString stringWithFormat:@"%d",model.allCount];
        for (int i = 1; i < 6; i ++) {
            PLPMSGTypeModel * model = [PLPMSGTypeModel new];
            model.msgType = i;
            NSString * lockCount;
            switch (model.msgType) {
                case pwdOpenLock:
                    lockCount = [NSString stringWithFormat:@"%d",self.doorLockStatisticsModel.pwdOpenLockCount];
                    break;
                case fingerprintOpenLock:
                    lockCount = [NSString stringWithFormat:@"%d",self.doorLockStatisticsModel.fingerprintOpenLockCount];
                    break;
                case cardOpenLock:
                    lockCount = [NSString stringWithFormat:@"%d",self.doorLockStatisticsModel.cardOpenLockCount];
                    break;
                case faceOpenLock:
                    lockCount = [NSString stringWithFormat:@"%d",self.doorLockStatisticsModel.faceOpenLockCount];
                    break;
                case doorbell:
                    lockCount = [NSString stringWithFormat:@"%d",self.doorLockStatisticsModel.doorbellCount];
                    break;
                    
                    
                default:
                    break;
            }
            
            model.msgLockCount = lockCount.intValue;
            [self.dataSourceArr addObject:model];
        }
        
    } error:^(NSError * _Nonnull error) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

//  CollectionView代理 方法的实现
#pragma mark UICollecionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PLPDoorLockStatusCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:deviceListCellId forIndexPath:indexPath];
    cell.backgroundColor = KDSRGBColor(242, 242, 242);
    PLPMSGTypeModel * model = self.dataSourceArr[indexPath.row];
    cell.model = model;
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((kScreenWidth - 72) / 4.0, (kScreenWidth - 72) / 4.0);
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
    if (page + 4 == self.dataSourceArr.count) {
        self.selectedIdx = self.dataSourceArr.count -1;
    }else{
        self.selectedIdx = page;
    }
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}

- (void)setLockMsgCountLb:(UILabel *)lockMsgCountLb
{
    lockMsgCountLb.textColor = KDSRGBColor(153, 153, 153);
    lockMsgCountLb.font = [UIFont systemFontOfSize:15];
    NSString *str1 = lockMsgCountLb.text;
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc]initWithString:str1];
    NSRange range1 = [str1 rangeOfString:@"条"];
    //设置"条"之前文字的颜色
    [attributed addAttribute:NSForegroundColorAttributeName value:KDSRGBColor(51, 51, 51) range:NSMakeRange(0, range1.location)];
    //设置"条"之前文字的大小
    [attributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, range1.location)];
    lockMsgCountLb.attributedText = attributed;
}

- (void)setMsgTipsLb:(UILabel *)msgTipsLb
{
    msgTipsLb.textColor = KDSRGBColor(153, 153, 153);
    msgTipsLb.font = [UIFont systemFontOfSize:11];
}

#pragma mark 点击事件

- (void)leftBtnClick:(UIButton *)sender
{
    UICollectionViewCell * cell = [self.lockMsgTypeCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIdx inSection:0]];
    CGRect cellRect = [self.lockMsgTypeCollectionView convertRect:cell.frame toView:self.lockMsgTypeCollectionView];
    UIWindow* window=[[[UIApplication sharedApplication] delegate] window];
    CGRect  rect2 = [self.lockMsgTypeCollectionView convertRect:cellRect toView:window];
    int ccc =  rect2.origin.x/cell.frame.size.width;
    if (self.selectedIdx < self.dataSourceArr.count && self.selectedIdx !=0) {
        if (ccc == 0) {
            self.selectedIdx --;
        }else{
            self.selectedIdx -= ccc+(4-ccc);
        }
        
        [UIView animateWithDuration:0.1 animations:^{
            [self.lockMsgTypeCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIdx inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }];
        self.leftBtn.selected = NO;
        self.rightBtn.selected = YES;
    }else{
        [MBProgressHUD showSuccess:@"已到第一个"];
    }
    
}

-(void)rightBtnClick:(UIButton *)sender
{
    UICollectionViewCell * cell = [self.lockMsgTypeCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIdx inSection:0]];
    CGRect cellRect = [self.lockMsgTypeCollectionView convertRect:cell.frame toView:self.lockMsgTypeCollectionView];
    UIWindow* window=[[[UIApplication sharedApplication] delegate] window];
    CGRect  rect2 = [self.lockMsgTypeCollectionView convertRect:cellRect toView:window];
    int ccc =  rect2.origin.x/cell.frame.size.width;
    if (self.selectedIdx < self.dataSourceArr.count -1) {
        int tt = 4-ccc;
        self.selectedIdx +=tt;
        [UIView animateWithDuration:0.1 animations:^{
            [self.lockMsgTypeCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIdx inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
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

#pragma mark -- Lazy load

- (NSMutableArray<PLPMSGTypeModel *> *)dataSourceArr
{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

@end
