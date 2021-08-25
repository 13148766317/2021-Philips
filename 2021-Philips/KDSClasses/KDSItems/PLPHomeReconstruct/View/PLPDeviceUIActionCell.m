//
//  PLPDeviceUIActionCell.m
//  Pages
//
//  Created by Apple on 2021/5/25.
//

#import "PLPDeviceUIActionCell.h"

@implementation PLPDeviceUIActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(id<PLPCellDataProtocol>)data {
    
    if (data && [data conformsToProtocol:@protocol(PLPCellDataProtocol)]) {
        self.labTitle.text = [data plpCellTitle];
        [self.ivImage setImage:[UIImage imageNamed:[data plpCellImageName]]];
    }
    
}



@end
