//
//  PLPAboutImageTextCell.m
//  2021-Philips
//
//  Created by Apple on 2021/5/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPAboutImageTextCell.h"
NSString * const XLFormRowDescriptorTypeAboutImageText = @"XLFormRowDescriptorTypeAboutImageText";

@implementation PLPAboutImageTextCell

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:NSStringFromClass([PLPAboutImageTextCell class]) forKey:XLFormRowDescriptorTypeAboutImageText];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configure
{
    [super configure];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)update
{
    [super update];
    
}

@end
