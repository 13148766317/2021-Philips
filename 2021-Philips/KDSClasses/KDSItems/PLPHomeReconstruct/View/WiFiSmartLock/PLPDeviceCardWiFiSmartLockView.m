//
//  PLPDeviceCardWiFiSmartLockView.m
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import "PLPDeviceCardWiFiSmartLockView.h"

#import "PLPConfigUtils.h"

@import Masonry;
@interface PLPDeviceCardWiFiSmartLockView()
@end


@implementation PLPDeviceCardWiFiSmartLockView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void) configure {
    
    self.productViewType = PLPProductViewTypeCard;
    
    //加载对应的视图
    [self loadNibNamedView];
    
    //配置大小一样
    self.contentView.frame = self.bounds;
    __weak __typeof(self)weakSelf = self;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf);
    }];
    
    //配置设备UI交互按钮
    [self configureActionsView];
    
}
-(void) layoutSubviews {
    [super layoutSubviews];
    //重新计算布局
    [self updateActionsViewLayout];
    
}

//更新CollectionViewLayout
-(void) updateActionsViewLayout {
    if (self.actionsView) {
        //生成按钮布局
        
        //显示列数
        NSArray<PLPDeviceUIAction *> *actions = [PLPConfigUtils actionsFromDevice:self.device viewType:self.productViewType];
        NSUInteger colNum = actions.count>2 ? 3 : 2;
        
        CGSize itemSize = [PLPDeviceUIActionsCollectionView itemSizeWithColNum:colNum layoutWidth:self.bounds.size.width rowHeight:64 minimumInteritemSpacing:10 edgeLeft:10 edageRight:10];
        UICollectionViewFlowLayout *collectionViewFlowLayout = [PLPDeviceUIActionsCollectionView  collectionViewFlowLayoutWithItemSize:itemSize minimumLineSpacing:10 minimumInteritemSpacing:10];
        collectionViewFlowLayout.sectionInset =
        UIEdgeInsetsMake(0, 10, 0, 10);
        [self.actionsView setCollectionViewLayout:collectionViewFlowLayout];
    }
}

//更新设备信息UI
-(void) updateUI {
 
    //配置设备UI交互按钮数据源
    //[super updateUI];
    [self updateLastUnlockRecordLabel];
    [self updateActionsViewData];
    [self updateDeivceImage];
    [self updateBatteryImage];
    
}



@end
