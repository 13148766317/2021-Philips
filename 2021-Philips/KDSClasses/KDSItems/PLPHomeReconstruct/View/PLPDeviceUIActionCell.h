//
//  PLPDeviceUIActionCell.h
//  Pages
//
//  Created by Apple on 2021/5/25.
//

#import <UIKit/UIKit.h>
#import "PLPCellDataProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface PLPDeviceUIActionCell : UICollectionViewCell
@property(nonatomic, strong) id<PLPCellDataProtocol> data;
@property(nonatomic, weak) IBOutlet UIImageView *ivImage;
@property(nonatomic, weak) IBOutlet UILabel *labTitle;
@end

NS_ASSUME_NONNULL_END
