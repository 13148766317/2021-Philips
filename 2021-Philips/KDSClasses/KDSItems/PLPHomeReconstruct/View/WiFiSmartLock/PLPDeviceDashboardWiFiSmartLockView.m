//
//  PLPDeviceDashboardWiFiSmartLockView.m
//  Pages
//
//  Created by Apple on 2021/5/19.
//

#import "PLPDeviceDashboardWiFiSmartLockView.h"
#import "PLPConfigUtils.h"

#import "PLPDevice+WiFiSmartLockDeviceViewDataSource.h"

@import Masonry;
@implementation PLPDeviceDashboardWiFiSmartLockView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void) configure {
    
    self.productViewType = PLPProductViewTypeDashboard;
    
    
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
    
        //生成按钮布局
        
    CGSize itemSize =  CGSizeMake(164, 56);
    CGFloat insetLeftRight = 20;
    if (self.bounds.size.width <= 375) {
        insetLeftRight = 10;
    }
    
    //根据按钮数量重置高度
    NSArray<PLPDeviceUIAction *> *actions = [PLPConfigUtils actionsFromDevice:self.device viewType:self.productViewType];
    
    if (actions.count == 2) {
        self.layoutConstraintActionsCollectionViewHeight.constant = 56;
    }
    UICollectionViewFlowLayout *collectionViewFlowLayout = [PLPDeviceUIActionsCollectionView  collectionViewFlowLayoutWithItemSize:itemSize minimumLineSpacing:12 minimumInteritemSpacing:10];
    collectionViewFlowLayout.sectionInset =
    UIEdgeInsetsMake(0, insetLeftRight, 0, insetLeftRight);
    [self.actionsView setCollectionViewLayout:collectionViewFlowLayout];
    
}
-(void) updateUI {
    
    [super updateUI];
    [self updateLastUnlockRecordLabel];
    //配置设备UI交互按钮数据源
    [self updateActionsViewData];
    [self updateDeivceImage];
    [self updateBatteryImage];
    [self updateWiFiSmartLockModelLable:self.labModel];
  
}

@end
