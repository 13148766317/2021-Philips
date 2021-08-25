//
//  PLPOperationRecordCell.m
//  2021-Philips
//
//  Created by 小凯互联科技有限公司 on 2021/5/6.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPOperationRecordCell.h"

@implementation PLPOperationRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //头部蓝色小圆点
    self.headMarkView.layer.cornerRadius = 5;
    self.headMarkView.backgroundColor = KDSRGBColor(47, 102, 158);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
