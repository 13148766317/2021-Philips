//
//  KDSFuntionTabListCell.h
//  2021-Philips
//
//  Created by kaadas on 2021/1/28.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDSFuntionTabModel.h"
#import "PLPCellProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface KDSFuntionTabListCell : UICollectionViewCell
- (void)setupData:(KDSFuntionTabModel *)data;
- (void)setupDataModel:(id<PLPCellProtocol>) dataModel;
@end

NS_ASSUME_NONNULL_END
